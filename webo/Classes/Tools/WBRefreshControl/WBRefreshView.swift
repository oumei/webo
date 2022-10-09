//
//  WBRefreshView.swift
//  刷新控件
//
//  Created by OMi on 2021/5/10.
//

import UIKit

class WBRefreshView: UIView {
    //刷新状态
    var refreshState: WBRefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                tipLabel?.text = "继续使劲拉"
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform.identity
                }
                
            case .Pulling:
                tipLabel?.text = "放手就刷新"
                //旋转的动画会按照逆时针旋转
                //如果想来回都按照同一边旋转（即先逆时针，后顺时针），则可以加上一个小数，因为动画旋转会按照就近原则
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: .pi+0.001)
                }
                
            case .willRefresh:
                tipLabel?.text = "正在刷新中"
                tipIcon?.isHidden = true
                indicator?.startAnimating()
            }
        }
    }
    
    //父视图高度
    var parentViewHeight: CGFloat = 0
    

    //指示图标
    @IBOutlet weak var tipIcon: UIImageView?
    //提示标签
    @IBOutlet weak var tipLabel: UILabel?
    //指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    class func refreshView() -> WBRefreshView {
        let nib = UINib(nibName: "WBJugglingRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nib, options: nil)[0] as! WBRefreshView
    }
}
