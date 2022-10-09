//
//  WBComposeTypeView.swift
//  webo
//
//  Created by OMi on 2021/5/12.
//

import UIKit
import pop

class WBComposeTypeView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    //返回上一页按钮
    @IBOutlet weak var returnButton: UIButton!
    
    //关闭按钮底部 view 的约束
    @IBOutlet weak var closeViewHeightCons: NSLayoutConstraint!
    //关闭按钮的约束
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    //返回上一页按钮的约束
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    
    
    //按钮数据数组
    private let buttonInfo = [["imageName":"compose_btn1_icon","title":"文字","clsName":"WBComposeViewController"],
                              ["imageName":"compose_btn2_icon","title":"照片/视频"],
                              ["imageName":"compose_btn3_icon","title":"长微博"],
                              ["imageName":"compose_btn4_icon","title":"签到"],
                              ["imageName":"compose_btn5_icon","title":"点评"],
                              ["imageName":"compose_btn6_icon","title":"更多","actionName":"clickMore"],
                              ["imageName":"compose_btn7_icon","title":"好友圈"],
                              ["imageName":"compose_btn8_icon","title":"微博相机"],
                              ["imageName":"compose_btn9_icon","title":"音乐"],
                              ["imageName":"compose_btn10_icon","title":"拍摄"]]
    

    //完成回调
    private var completionBlock: ((_ clsName: String?)->())?
    
    //实例化方法
    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        v.setupUI()
        return v
    }
    
    //显示当前视图
    func show(completion:@escaping (_ clsName: String?)->()) {
        //记录回调闭包
        completionBlock = completion
        
        guard let vc = UIApplication.shared.windows.first(where: { $0.isKeyWindow})?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
        showCurrentView()
    }
    
    //Mark: - 监听方法
    @objc private func clickButton(button: WBComposeTypeButton) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        //选中按钮放大，未选中的缩小
        for (i,btn) in v.subviews.enumerated() {
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale = (button == btn) ? 2 : 0.2
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.5
            btn.pop_add(scaleAnim, forKey: nil)
            
            //渐变动画
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            btn.pop_add(alphaAnim, forKey: nil)
            
            if i == 0 {
                alphaAnim.completionBlock = {_,_ in
                    //展现对应的页面
                    self.completionBlock?(button.clsName)
                }
            }
        }
        
    }
    
    //更多
    @objc private func clickMore() {
        //切换下一页
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        //处理底部按钮
        returnButton.isHidden = false
        let margin = scrollView.bounds.width / 6
        closeButtonCenterXCons.constant += margin
        returnButtonCenterXCons.constant -= margin
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func close() {
        hideButtons()
    }
    
    @IBAction func clickReturn() {
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        //处理底部按钮
        closeButtonCenterXCons.constant = 0
        returnButtonCenterXCons.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        } completion: { _ in
            self.returnButton.isHidden = true
            self.returnButton.alpha = 1
        }
    }
    
}

//private 让 extension 中所有方法都是私有
private extension WBComposeTypeView {
    func setupUI() {
        //强行更新布局
        closeViewHeightCons.constant = SafeArea_Bottom_HEIGHT + 44
        layoutIfNeeded()
        
        //1、向 scrollview 添加视图
        let rect = scrollView.bounds
        let width = scrollView.bounds.width
        
        for i in 0..<2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            //2、向视图添加按钮
            addButtons(v: v, idx: i*6)
            
            //3、将视图添加到 scrollView
            scrollView.addSubview(v)
        }
        
        //4、设置 scrollview
        scrollView.contentSize = CGSize(width: 2 * width, height: scrollView.bounds.height)
        scrollView.bounces = false
    }
    
    func addButtons(v: UIView, idx: Int) {
        let count = 6
        for i in idx..<(idx+count) {
            if i >= buttonInfo.count {
                break
            }
            
            let dict = buttonInfo[i]
            guard let title = dict["title"],
                  let imageName = dict["imageName"] else {
                continue
            }
            
            let btn = WBComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            v.addSubview(btn)
            
            //添加监听方法
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            }
            
            //设置展现的类名
            btn.clsName = dict["clsName"]
        }
        
        //布局按钮
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        
        for (i, btn) in v.subviews.enumerated() {
            let y: CGFloat = i > 2 ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x: CGFloat = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
            
        }
    }
    
    
}

//Mark : 动画方法扩展
private extension WBComposeTypeView {
    //隐藏视图的动画
    private func hideButtons() {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i,btn) in v.subviews.enumerated().reversed() {
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + SCREEN_HEIGHT
            
            //设置动画启动的时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            
            btn.pop_add(anim, forKey: nil)
            
            if i == 0 {
                anim.completionBlock = {_,_ in
                    //隐藏当前视图
                    self.hideCurrentView()
                }
            }
        }
        
    }
    
    private func hideCurrentView() {
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        anim.completionBlock = {_,_ in
            self.removeFromSuperview()
        }
    }
    
    //显示视图的动画
    private func showCurrentView() {
        //透明度动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 2
        pop_add(anim, forKey: nil)
        
        showButton()
    }
    
    //弹力显示按钮
    private func showButton() {
        let v = scrollView.subviews[0]
        for (i,btn) in v.subviews.enumerated() {
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y + 400
            anim.toValue = btn.center.y
            //弹力系数 0-20 默认是4
            anim.springBounciness = 8
            //弹力速度，0-20 默认是12
            anim.springSpeed = 10
            //设置动画启动的时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            btn.pop_add(anim, forKey: nil)
        }
        
    }
}
