//
//  UIButton+Extensions.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import UIKit

extension UIButton {
    
    class func textButton(title:String,fontSize:CGFloat,normalColor:UIColor,highlightedColor:UIColor) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(highlightedColor, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.sizeToFit()
        
        return btn
    }
}
