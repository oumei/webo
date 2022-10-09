//
//  WBNewFeatureView.swift
//  webo
//
//  Created by OMi on 2021/5/1.
//

import UIKit

class WBNewFeatureView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //进入微博
    @IBAction func enterStatus(_ sender: Any) {
        removeFromSuperview()
    }
    

    class func newFeatureView()-> WBNewFeatureView {
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0]
        return v as! WBNewFeatureView
    }
    
    override func awakeFromNib() {
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            let imageName = "welcome0\(i+1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
        }
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.delegate = self
        
        enterButton.isHidden = true
    }

}

extension WBNewFeatureView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        enterButton.isHidden = true
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        pageControl.currentPage = page
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}
