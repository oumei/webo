//
//  UIScreen+Extensions.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import UIKit

extension UIScreen {
    class func wb_screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func wb_screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
