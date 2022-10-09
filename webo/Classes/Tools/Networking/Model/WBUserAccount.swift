//
//  WBUserAccount.swift
//  webo
//
//  Created by OMi on 2021/4/30.
//

import UIKit

private let fileName = "useraccount.json"

//用户信息
@objcMembers class WBUserAccount: NSObject {

    //访问令牌
    var access_token: String?
    //用户代号
    var uid: String?
    //access_token的生命周期，单位是秒数
    //开发者 5 年 ，使用者 3 天
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    //过期日期
    var expiresDate: Date?
    //用户昵称
    var screen_name: String?
    //用户头像
    var avatar_large: String?
    
    
    
    
    override var description: String {
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
        //从磁盘获取文件
        let jsonPath = String().documentFilePath(fileName: fileName)
        //加载 data
        //反序列化
        guard let data = NSData(contentsOfFile: jsonPath),
              let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String:Any] else {
            return
        }
        
        yy_modelSet(with: dict)
        
        if expiresDate?.compare(Date()) != .orderedDescending {
            //账户过期
            access_token = nil
            uid = nil
            
            //删除账户文件
            try? FileManager.default.removeItem(atPath: jsonPath)
        }
    }
    
    func saveAccount() {
        //模型转字典
        var dict = self.yy_modelToJSONObject() as? [String: Any] ?? [:]
        //需要删除 expires_in
        dict.removeValue(forKey: "expires_in")
        //字典序列化
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        
        //写入磁盘
        let filePath = String().documentFilePath(fileName: fileName)
        (data as NSData).write(toFile: filePath, atomically: true)
    }
    
}
