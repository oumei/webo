//
//  WBStatus.swift
//  webo
//
//  Created by OMi on 2021/5/1.
//

import UIKit
import YYModel

@objcMembers class WBStatus: NSObject {

    //int 类型，在 64 位的机器是 64 位， 在 32 位机器就是 32 位
    //如果不写64 在低端配置机器上无法正常运行
    //微博ID
    var id: Int64 = 0
    //微博信息内容
    var text: String?
    
    //微博创建时间
    var created_at: String?
    //微博来源 - 发布微博的客户端
    var source: String?{
        didSet {
            //重新计算来源
            //在 didset 中，给 source 赋值，不会再次调用 didset
            source = "来自 " + (source?.str_href()?.text ?? "")
        }
    }
    
    //转发数
    var reposts_count: Int = 0
    //评论数
    var comments_count: Int = 0
    //点赞数
    var attitudes_count: Int = 0
    //图片
    var pic_urls: [WBStatusPicture]?
    
    
    //用户信息
    var user: WBUser?
    
    //被转发的原微博信息字段
    var retweeted_status: WBStatus?
    
    
    
    //重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
    //类函数 -> 告诉第三方框架 yy_model 如果遇到数组类型的属性，数组中存放的对象是什么类
    //NSArray 中保存对象的类型通常是 ‘id’ 类型
    class func modelContainerPropertyGenericClass() -> [String: Any] {
        return ["pic_urls":WBStatusPicture.self]
    }
}
