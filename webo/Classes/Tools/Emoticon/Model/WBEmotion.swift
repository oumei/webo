//
//  WBEmotion.swift
//  表情包Demo
//
//  Created by OMi on 2021/5/15.
//  Copyright © 2021 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//

import UIKit
import YYModel

@objcMembers class WBEmotion: NSObject {
    ///表情类型 false-图片表情/true-emoji
    var type = false
        
    /// 表情字符串，发送给服务器（节约流量）
    var chs: String?
        
    /// 表情的图片名称，用于本地图文混排
    var png: String?
        
    /// emoji 16进制编码
    var code: String?
    
    ///表情模型所在的目录
    var directory: String?
    
    ///‘图片’表情对应的图像
    var image: UIImage? {
        if type {
            return nil
        }
        
        guard let directory = directory,
              let png = png,
              let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
              let bundle = Bundle(path: path) else {
            return nil
        }
        
        let image = UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
        return image
    }
    
    //讲当前的图像转换生成图片的属性文本
    func imageText(font: UIFont) -> NSAttributedString {
        //1、判断图像是否存在
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        //2、创建文本附件
        let attachment = NSTextAttachment()
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        return NSAttributedString(attachment: attachment)
    }
        
    override var description: String{
        return yy_modelDescription()
    }
}
