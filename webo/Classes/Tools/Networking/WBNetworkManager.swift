//
//  WBNetworkManager.swift
//  webo
//
//  Created by OMi on 2021/4/27.
//

import UIKit
import AFNetworking

//swift 的枚举支持任意数据类型
//switch / enum 在 oc 中都是支持整数
enum WBHTTPMethod {
    case GET
    case POST
}

class WBNetworkManager: AFHTTPSessionManager {

    //静态/常量/闭包
    //在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    static let shared: WBNetworkManager = {
        //实例化对象
        let instance = WBNetworkManager()
        //设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
    
    //用户账户信息
    lazy var userAccount = WBUserAccount()
    
    //用户登录标记（计算型属性）
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    
    
    //专门负责拼接 token 的网络请求方法
    func tokenRequest(method:WBHTTPMethod = .GET, URLString:String, parameters:[String:Any]?,completion:@escaping(_ json:Any?, _ isSuccess:Bool)->()) {
        
        guard let token = userAccount.access_token else {
            print("没有 token！ 需要登录")
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
            completion(nil, false)
            return
        }
        
        var parameters = parameters
        
        if parameters == nil {
            parameters = [String:Any]()
        }
        
        parameters?["access_token"] = token
        
        request(URLString: URLString, parameters: parameters, completion: completion)
    }
    
    
    //使用一个函数封装 afn 的 get / post 请求
    func request(method:WBHTTPMethod = .GET, URLString:String, parameters:[String:Any]?,completion:@escaping(_ json:Any?, _ isSuccess:Bool)->()) {
        
        let success = {(task:URLSessionDataTask, json:Any)->() in
            completion(json, true)
        }
        
        let failure = {(task:URLSessionDataTask?, error:Error)->() in
            //针对 403 处理 token 过期
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                //发送通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token")
            }
            
            completion(nil, false)
        }
        
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
