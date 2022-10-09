//
//  WBJugglingRefreshView.swift
//  webo
//
//  Created by OMi on 2021/5/12.
//

import UIKit

class WBJugglingRefreshView: WBRefreshView {

    @IBOutlet weak var jugglinIconView: UIImageView!
    
    override var parentViewHeight: CGFloat {
        didSet {
            /**
            var scale = 1 - (100 - parentViewHeight) / 100
            scale = parentViewHeight > 100 ? 1 : scale
            jugglinIconView.transform = CGAffineTransform(scaleX: scale, y: scale)
             */
        }
    }
    
    override func awakeFromNib() {
        var imageArr = [UIImage]()
        for i in 0..<12 {
            let image = UIImage(named: "loading_image\(i+1)")
            imageArr.append(image!)
        }
        
        jugglinIconView.image = UIImage.animatedImage(with: imageArr, duration: 1.0)
        
        /**
        //控件旋转动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -Double.pi * 2 //逆时针
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        jugglinIconView.layer.add(anim, forKey: nil)
        
        
        
        //控件缩放动画
        //设置锚点
        jugglinIconView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        //设置frame / center
        let x = self.bounds.width * 0.5
        let y = self.bounds.height
        jugglinIconView.center = CGPoint(x: x, y: y)
        jugglinIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
         */
    }
}
