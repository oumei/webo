//
//  WBStatusPictureView.swift
//  webo
//
//  Created by OMi on 2021/5/2.
//

import UIKit

@objcMembers class WBStatusPictureView: UIView {
    
    var viewModel: WBStatusViewModel? {
        didSet {
            calcViewSize()
            
            urls = viewModel?.picURLs
        }
    }
    
    //根据视图模型的配图视图大小，调整显示内容
    private func calcViewSize() {
        //1、单图
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: viewSize.width, height: viewSize.height - WBStatusPictureViewOutterMargin)
            
        } else {
            //2、多图
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureViewItemWidth, height: WBStatusPictureViewItemWidth)
        }
        
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    private var urls: [WBStatusPicture]? {
        didSet {
            var index = 0
            for url in urls ?? [] {
                let iv = subviews[index] as! UIImageView
                
                //处理4张图像
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                iv.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                iv.isHidden = false
                index += 1
            }
        }
    }
    

    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
}

//设置界面
extension WBStatusPictureView {
    private func setupUI() {
        backgroundColor = superview?.backgroundColor
        
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureViewItemWidth, height: WBStatusPictureViewItemWidth)
        
        for i in 0..<count * count {
            let iv = UIImageView()
            iv.isHidden = true
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            let xOffset = col * (WBStatusPictureViewItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureViewItemWidth + WBStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(iv)
        }
    }
}
