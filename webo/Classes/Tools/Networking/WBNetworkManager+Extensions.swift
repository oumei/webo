//
//  WBNetworkManager+Extensions.swift
//  webo
//
//  Created by OMi on 2021/4/27.
//

import Foundation
//封装新浪微博的网络请求方法
extension WBNetworkManager {
    // - parameters  since_id:   返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    // - parameters  max_id:     返回ID小于或等于max_id的微博，默认为0。
    // - parameters  completion: 完成的回调
    func statusList(since_id:Int64 = 0, max_id:Int64 = 0, completion:@escaping(_ list:[[String:Any]]?, _ isSuccess:Bool)->()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["since_id":since_id, "max_id":max_id > 0 ? max_id - 1 : 0]
        
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            //Value of type 'Any' has no subscripts
            let result = (json as? [String:Any])?["statuses"] as? [[String:Any]]
            completion(result, isSuccess)
        }
    }
    
    //返回微博未读消息数量
    func unreadCount(completion:@escaping(_ count:Int)->()) {
        guard let uid = userAccount.uid else {
            return
        }
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let params = ["uid":uid]
        
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            //Value of type 'Any' has no subscripts
            let dict = json as? [String:Any]
            let count = dict?["status"] as? Int
            
            completion(count ?? 0)
        }
    }
}

//Mark OAuth相关
extension WBNetworkManager {
    func loadAccessToken(code: String, completion:@escaping(_ isSuccess: Bool)->()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":WBAppKey,
                      "client_secret":WBAppSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":WBRedirectURI]
        request(method: .POST, URLString: urlString, parameters: params) { (json, isSuccess) in
            self.userAccount.yy_modelSet(with: json as? [String: Any] ?? [:])
            
            self.loadUserInfo { (dict) in
                self.userAccount.yy_modelSet(with: dict)
                self.userAccount.saveAccount()
                //加载用户信息完成后再回调
                completion(isSuccess)
            }
            
            /**
             "access_token" = "2.00_MW9nDPlJZAEdb3377d8b3QL28tC";
             "expires_in" = 157679999;
             isRealName = true;
             "remind_in" = 157679999;
             uid = 3479235915;
             */
        }
    }
}

//Mark: 用户信息
extension WBNetworkManager {
    //加载用户信息
    func loadUserInfo(completion:@escaping(_ dict:[String:Any])->()) {
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid":uid]
        
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            completion(json as? [String:Any] ?? [:])
        }
    }
}
