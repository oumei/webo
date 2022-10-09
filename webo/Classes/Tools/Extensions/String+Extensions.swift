//
//  String+Extensions.swift
//  webo
//
//  Created by OMi on 2021/5/1.
//

import Foundation

extension String {
    func documentFilePath(fileName: String) -> String {
        //获取沙盒路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = (docDir as NSString).appendingPathComponent(fileName)
        return filePath
    }
    
    func str_href() -> (link: String, text: String)? {
        //公式
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"

        
        //查找
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) else {
//            print("没有找到匹配项")
            return nil
        }
        //链接
        let link = (self as NSString).substring(with: result.range(at: 1))
        //文本
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        return (link, text)
    }
}
