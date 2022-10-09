//
//  WBWelcomeView.swift
//  webo
//
//  Created by OMi on 2021/5/1.
//

import UIKit
import SDWebImage

class WBWelcomeView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var iconBottomConstraint: NSLayoutConstraint!
    
    class func welcomeView()-> WBWelcomeView {
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0]
        return v as! WBWelcomeView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large,
              let url = URL(string: urlString) else {
            return
        }
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default"))
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
//        self.layoutSubviews()
        iconBottomConstraint.constant = bounds.size.height - 280
        UIView.animate(withDuration: 3.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: []) {
            self.layoutSubviews()
        } completion: { (_) in
            UIView.animate(withDuration: 1.0) {
                self.tipLabel.alpha = 1
            } completion: { (_) in
                self.removeFromSuperview()
            }
        }

    }
    
}
