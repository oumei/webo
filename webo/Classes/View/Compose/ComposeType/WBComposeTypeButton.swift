//
//  WBComposeTypeButton.swift
//  webo
//
//  Created by OMi on 2021/5/13.
//

import UIKit

class WBComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //点击按钮跳转的控制器名称
    var clsName: String?
    
    
    class func composeTypeButton(imageName: String, title: String) -> WBComposeTypeButton {
        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        return btn
    }
}
