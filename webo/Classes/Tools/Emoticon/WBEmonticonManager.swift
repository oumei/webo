//
//  WBEmonticonManager.swift
//  表情包Demo
//
//  Created by OMi on 2021/5/15.
//  Copyright © 2021 Guangxi City Network Technology Co.,Ltd. All rights reserved.
//

import Foundation
import UIKit

//表情单例：为了便于表情是复用，使用单例，只加载一次表情数据
class WBEmonticonManager {
    static let shared = WBEmonticonManager()
    
    /// 表情包懒加载数组
    lazy var packages = [WBEmoticonPackage]()
    
    //构造函数 如果在init之前增加private 修饰符，可以要求调用者必须通过 shared 访问对象
    // OC 要重写 allocWithZone方法
    private init() {
        loadPackages()
    }
}

private extension WBEmonticonManager {
    func loadPackages() {
        //读取 emoticons.plist
        //只要按照 Bundle 默认的结构目录设定，就可以直接读取 Resources 目录的文件
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String:String]],
            let models = NSArray.yy_modelArray(with: WBEmoticonPackage.self, json: array) as? [WBEmoticonPackage] else {
                return
        }

        packages += models
    }
}

extension WBEmonticonManager {
    //根据 string 在所有的表情符号中查找对应的表情模型对象
    func findEmoticon(string: String) -> WBEmotion? {
        //1、遍历表情包
        for p in packages {
            //2、在表情数组中过滤 string
            //方法一
//            let result = p.emoticons.filter { (em) -> Bool in
//                return em.chs == string
//            }
            
            //方法二：尾随闭包
//            let result = p.emoticons.filter() { (em) -> Bool in
//                return em.chs == string
//            }
            
            //方法三：如果闭包中只有一句，并且是返回，闭包格式可以省略【闭包格式 指的是 in之前的语句】，参数省略之后，使用$0,$1依次替代
//            let result = p.emoticons.filter() {
//                return $0.chs == string
//            }
            
            //方法四：如果闭包中只有一句，并且是返回，闭包格式可以省略【闭包格式 指的是 in之前的语句】，参数省略之后，使用$0,$1依次替代,return也可以省略
            let result = p.emoticons.filter() { $0.chs == string }
            
            //3、判断结果数组的数量
            if result.count == 1 {
                return result[0]
            }
        }
        
        return nil
    }
    
    
    func emotionString(string: String, font: UIFont) -> NSAttributedString {
        let attString = NSMutableAttributedString(string: string)
        
        //1、建立正则表达式，过滤表情文字
        //[] () 都是正则表达式的关键字，如果要参与匹配，需要转义
        let patter = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: patter, options: []) else {
            return attString
        }
        
        //2、匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attString.length))
        
        //3、遍历所有匹配项, 注意：倒序
        for m in matches.reversed() {
            let r = m.range(at: 0)
            let subStr = (attString.string as NSString).substring(with: r)
            
            //使用 substr 查找对应的表情符号
            if let em = WBEmonticonManager.shared.findEmoticon(string: subStr) {
                //使用表情符号中的属性文本，替换原有的属性文本的内容
                attString.replaceCharacters(in: r, with: em.imageText(font: font))
            }
        }
        
        //4、统一设置一遍字符串的属性
        attString.addAttributes([NSAttributedString.Key.font: font,
                                 NSAttributedString.Key.foregroundColor:UIColor.darkGray],
                                range: NSRange(location: 0, length: attString.length))
        
        return attString
    }
}
