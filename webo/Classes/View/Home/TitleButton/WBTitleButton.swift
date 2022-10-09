//
//  WBTitleButton.swift
//  webo
//
//  Created by OMi on 2021/4/30.
//

import UIKit

class WBTitleButton: UIButton {

    //重载构造函数
    // - title 如果为 nil， 就显示‘首页’
    // - 如果不为 nil，显示 title 和 箭头图像
    init(title: String?) {
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            setTitle(title! + " ", for: .normal)
            setImage(UIImage(named: "home_down"), for: .normal)
            setImage(UIImage(named: "home_up"), for: .selected)
        }
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(.darkGray, for: .normal)
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,
              let imageView = imageView else {
            return
        }
        
        if imageView.frame.origin.x > titleLabel.frame.origin.x {
            return
        }
        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x = titleLabel.bounds.width
    }
    
}
