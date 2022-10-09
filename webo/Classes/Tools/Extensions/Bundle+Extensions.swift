//
//  Bundle+Extensions.swift
//  007-反射机制
//
//  Created by OMi on 2021/4/19.
//

import Foundation

extension Bundle {
    
//    //返回命名空间字符串
//    func nameSpace() -> String {
//        return infoDictionary?["CFBundleName"] as? String ?? ""
//    }
    
    //计算型属性
    var nameSpace:String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
