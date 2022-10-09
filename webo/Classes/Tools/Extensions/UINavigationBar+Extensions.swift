//
//  UINavigationBar+Extensions.swift
//  webo
//
//  Created by OMi on 2021/4/21.
//

import UIKit

extension UINavigationBar {
    func resetSubviews() {
        
        /// 适配iOS11及以上，遍历所有子控件，向下移动状态栏高度
        if #available(iOS 11.0, *) {
            for obj in self.subviews {
                let cls: AnyClass? = NSClassFromString("_UIBarBackground")
                let isCls = obj.isKind(of: cls ?? AnyObject.self)
                
                if isCls == true {
                    do {
                        //_UIBarBackground修改无效，所以自定义一个view，并复制_UIBarBackground的subviews
                        //复制_UIBarBackground的subviews
                        let data = try NSKeyedArchiver.archivedData(withRootObject: obj.subviews, requiringSecureCoding: false)
                        let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UIView]
                        
                        let view = UIView(frame: CGRect(x: 0, y: -STATUSBAR_HIGH, width: SCREEN_WIDTH, height: NAV_BAR_HEIGHT))
                        view.backgroundColor = self.backgroundColor
                        obj.addSubview(view)
                        for subview in array ?? [] {
                            var subFrame = subview.frame
                            if subview.isKind(of: NSClassFromString("_UIBarBackgroundShadowView")!) {
                                subFrame.origin.y = view.frame.height
                            } else {
                                subFrame.size.height = view.frame.height
                            }
                            subview.frame = subFrame
                            view.addSubview(subview)
                        }
                        
                    } catch {
                    }
                }
            }
            
        }
    }
    
}
