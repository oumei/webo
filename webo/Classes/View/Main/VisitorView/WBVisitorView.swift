//
//  WBVisitorView.swift
//  webo
//
//  Created by OMi on 2021/4/24.
//

import UIKit

//访客视图
class WBVisitorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    //Mark -方式1：设置访客视图信息
    //提示：如果首页 imageName == ""
    func setupInfo(dic:[String:String]) {
        guard let imageName = dic["imageName"],
              let message = dic["message"] else {
            return
        }
        
        tipLabel.text = message
        
        if imageName == "" {
            return
        }
        
        iconView.image = UIImage(named: imageName)
    }
     */
    
    //-方式2：设置访客视图信息
    var visitorInfo: [String:String]? {
        didSet{
            guard let imageName = visitorInfo?["imageName"],
                  let message = visitorInfo?["message"] else {
                return
            }
            
            tipLabel.text = message
            
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            circle1View.isHidden = true
            circle2View.isHidden = true
        }
    }
    
    //Mark 私有控件
    //图片、提示标签、按钮
    private lazy var iconView = UIImageView(image: UIImage(named: "no_logon"))
    private lazy var circle1View = UIImageView(image: UIImage(named: "znmj_img_innerring"))
    private lazy var circle2View = UIImageView(image: UIImage(named: "znmj_img_outerring"))
    
    
    private lazy var tipLabel: UILabel = {() -> UILabel in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜"
        label.textAlignment = .center
        return label
    }()
    
    lazy var registerButton: UIButton = {() -> UIButton in
        let btn = UIButton()
        //设置 btton 的属性...
        btn.setTitle("注册", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitleColor(.black, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.backgroundColor = .white
//        btn.sizeToFit()
        return btn
    }()
    
    lazy var loginButton: UIButton = {() -> UIButton in
        let btn = UIButton()
        //设置 btton 的属性...
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.setTitleColor(.orange, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.backgroundColor = .white
//        btn.sizeToFit()
        return btn
    }()
    
    //旋转图标动画
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = Double.pi * 2   //M_PI == Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 5
        //动画完成不删除，如果视图被释放，动画会一起销毁
        //在设置连续播放的动画非常有用
        anim.isRemovedOnCompletion = false
        //将动画添加到涂层
        circle1View.layer.add(anim, forKey: nil)
        
        anim.toValue = -Double.pi * 2
        circle2View.layer.add(anim, forKey: nil)
        
    }
    
}

//Mark 设置界面
extension WBVisitorView {
    func setupUI() {
        backgroundColor = .white
        
        //1、添加视图
        addSubview(circle1View)
        addSubview(circle2View)
        addSubview(iconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //2、取消autoresing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //3、自动布局
        //图片
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -80))
        
        //圆圈1
        addConstraint(NSLayoutConstraint(item: circle1View,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: circle1View,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        
        //圆圈2
        addConstraint(NSLayoutConstraint(item: circle2View,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: circle2View,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        
        //提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: circle2View,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 20))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: SCREEN_WIDTH - 120))
        
        //注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: -30))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 20))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0, constant: 80))
        
        //登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 30))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 20))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
        
        /**
        //views:定义 VFL 中的控件名称和实际名称的映射关系
        //metrics:定义 VFL 中（）指定的常数映射关系
        let viewDic = ["iconView":iconView,"registerButton":registerButton]
        let metrics = ["spacing":30]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[iconView]-0-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: viewDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[iconView]-(30)-[registerButton]]",
                                                      options: [],
                                                      metrics: nil,
                                                      views: viewDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[iconView]-(spacing)-[registerButton]]",
                                                      options: [],
                                                      metrics: metrics,
                                                      views: viewDic))
         */
        
    }
}
