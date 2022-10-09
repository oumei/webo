//
//  UIBarButtonItem+Extensions.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(title:String, fontSize:CGFloat = 16, target:AnyObject?, action:Selector, isBack: Bool = false) {
        let btn = UIButton.textButton(title: title, fontSize: fontSize, normalColor: .darkGray, highlightedColor: .orange)
        
        if isBack {
            btn.setImage(UIImage(named:"nav_back_nor"), for: .normal)
            //高亮
//            btn.setImage(UIImage(named:"nav_back_high"), for: .highlighted)
            btn.sizeToFit()
        }
        btn.addTarget(target, action: action, for: .touchUpInside)
        //self.init 实例化 UIBarButtonItem
        self.init(customView: btn)
    }
}

