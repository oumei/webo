//
//  WBEmoticonPackage.swift
//  表情包Demo
//
//  Created by OMi on 2021/5/15.
//  Copyright © 2021 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//

import UIKit
import YYModel

@objcMembers class WBEmoticonPackage: NSObject {

    /// 表情包的分组名
    var groupName: String?
    
    /// 表情包目录，从目录下加载info.plist 可以创建表情模型数组
    var directory: String? {
        didSet {
            guard let directory = directory,
                  let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                  let bundle = Bundle(path:path),
                  let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                  let array = NSArray(contentsOfFile: infoPath) as? [[String: String]],
                  let models = NSArray.yy_modelArray(with: WBEmotion.self, json: array) as? [WBEmotion] else {
                return
            }
            
            //设置表情符号的目录
            for m in models {
                m.directory = directory
            }
            
            emoticons += models
        }
    }
    
    // 懒加载表情模型空数组，使用懒加载可以避免后续的解包
    lazy var emoticons = [WBEmotion]()
    
    override var description: String{
        return yy_modelDescription()
    }
}
