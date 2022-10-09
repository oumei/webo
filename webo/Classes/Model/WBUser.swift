//
//  WBUser.swift
//  webo
//
//  Created by OMi on 2021/5/1.
//

import UIKit

@objcMembers class WBUser: NSObject {

    //基本数据模型 & private 不能使用 kvc 设置
    var id: Int64 = 0
    
    //用户昵称
    var screen_name: String?
    //用户头像地址
    var profile_image_url: String?
    //认证类型, -1:没有认证，0:认证用户，2、3、5:企业认证，220:达人
    var verified_type: Int = -1
    //会员等级0-11
    var mbrank: Int = 0
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
}
