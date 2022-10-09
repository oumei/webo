//
//  WBMainViewController.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import UIKit
import SVProgressHUD

class WBMainViewController: UITabBarController {
    
    //定时器
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
        //添加中间按钮
        setupComposeButton()
        
        setupTimer()
        
        updateTimer()
        
        setupNewFeatureViews()
        
        //设置代理
        delegate = self
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin(n:)), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        //销毁定时器
        timer?.invalidate()
        //注销监听
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     portrait : 竖屏
     landscape: 横屏
     - 使用代码控制设备的方向，好处，可以在需要横屏的时候，单独处理
     - 设置支持的方向之后，当前的控制器及子控制器都会遵守这个方向
     - 如果播放视频，通常是通过 modal 展现的
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return.portrait
    }
    
    //Mark:监听方法
    @objc private func userLogin(n:Notification) {
        var when = DispatchTime.now()
        
        if n.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            when = DispatchTime.now() + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)
            //展现登录的控制器
            let nav = UINavigationController(rootViewController: WBOAuthViewController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    //中间按钮方法
    @objc private func composeState() {
        print("撰写微博")
        
        //fixme判断是否登录
        let v = WBComposeTypeView.composeTypeView()
        v.show {[weak v] (clsName) in
            guard let clsName = clsName,
                  let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type else {
                v?.removeFromSuperview()
                return
            }
            
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true) {
                v?.removeFromSuperview()
            }
        }
        
    }
    
    
    // -私有控件
    private lazy var composeButton: UIButton = {() -> UIButton in
        let btn = UIButton()
        //设置 btton 的属性...
        var image = UIImage(named: "bottom_bar_add")
        image = image?.scaleImage(size: CGSize(width: 38, height: 38))
        btn.setImage(image, for: .normal)
        btn.sizeToFit()
        //计算按钮的位置
        let left = view.bounds.width / 2.0
        let btnSize = btn.bounds.size
        btn.frame = CGRect(x: left - btnSize.width/2.0, y: (49 - btnSize.height)/2.0, width: btnSize.width, height: btnSize.height)
        //禁止按钮的交互作用，比添加多一个方法更好
//        btn.isUserInteractionEnabled = false
        return btn
    }()


}

extension WBMainViewController {
    
    private func setupComposeButton() {
        tabBar.addSubview(composeButton)
        
        composeButton.addTarget(self, action: #selector(composeState), for: .touchUpInside)
    }
    
    private func setupChildControllers() {
        //获取沙盒 json 路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        //加载 data
        var data = NSData(contentsOfFile: jsonPath)
        //判断 data 是否有内容
        if data == nil {
            //从 bundle 加载 data
            //从 bundle加载配置的json
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        //反序列化转换数组
        // try? : 如果解析成功，就有值，否则为 nil
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String:Any]] else {
            return
        }
        
        
        /**
        let array: [[String:Any]] = [
            ["clsName":"WBHomeViewController","title":"首页","imageName":"bottom_bar_sy","visitorInfo":["imageName":"","message":"关注一些人，回这里看看有什么惊喜"]],
            ["clsName":"WBMessageViewController","title":"消息","imageName":"bottom_bar_xx","visitorInfo":["imageName":"no_logon_message","message":"快登录看看吧"]],
            ["clsName":"UIViewController"],
            ["clsName":"WBDiscoverViewController","title":"发现","imageName":"bottom_bar_dd","visitorInfo":["imageName":"","message":"登录后，发现周边好玩的"]],
            ["clsName":"WBProfileViewController","title":"我","imageName":"bottom_bar_we","visitorInfo":["imageName":"","message":"登录后，您的个人相册、个人资料，展示给别人"]],
        ]
        
        //转换成 plist 文件，写入沙盒
        //(array as NSArray).write(toFile: "/Users/OMi/Desktop/swiftDemo/demo.plist", atomically: true)
        //数组 -> json 序列化
        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
        (data as NSData).write(toFile: "/Users/OMi/Desktop/swiftDemo/main.json", atomically: true)
         */
        
        
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM
    }
    
    //使用字典创造一个子控制器
    //parameter dict：[clsName,title,imageName]
    //return :子控制器
    private func controller(dict:[String:Any]) -> UIViewController {
        //1、取得字典内容
        guard let clsName = dict["clsName"] as? String,
              let title = dict["title"] as? String,
              let imageName = dict["imageName"] as? String,
              let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type,
              let visitorInfo = dict["visitorInfo"] as? [String:String]
        
              else {
            return UIViewController()
        }
        
        //2、创建视图控制器
        //- 将 clsName 转换成 cls
        let vc = cls.init()
        vc.title = title
        (vc as! WBBaseViewController).visitorInfoDic = visitorInfo
        
        //3、设置图像
        //图片需要设置 withRenderingMode，否则显示默认蓝色
        var image = UIImage(named: imageName)
        image = image?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.image = image
        
        var selImage = UIImage(named: imageName + "_selected")
        selImage = selImage?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = selImage
        
        //4、设置 tabbar 标题颜色\字体大小
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.orange], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)], for: .normal)
        
        let nav = WBNavigationController(rootViewController: vc)
        return nav
        
    }
}

//Mark : 定时器相关方法
extension WBMainViewController {
    private func setupTimer () {
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        //未读数量
        WBNetworkManager.shared.unreadCount { (count) in
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            //设置 app 桌面的 badgeNumber,需要用户授权
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

//Mark : UITabBarControllerDelegate
extension WBMainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let idx = viewControllers?.firstIndex(of: viewController)
        if selectedIndex == 0 && idx == selectedIndex {
            //在首页，再点击首页，让表哥滚动到顶部
            let nav = viewControllers?[0] as! UINavigationController
            let vc = nav.viewControllers[0] as! WBHomeViewController
            //Mark：animated 为 true 时 会导致位置不对
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -NAV_BAR_HEIGHT), animated: false)
            
            //刷新数据
            vc.loadData()
            
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        
        // 判断目标控制器是否是 UIViewController
        return !viewController.isMember(of: UIViewController.self)
    }
}

//Mark: 新特性视图
extension WBMainViewController {
    private func setupNewFeatureViews() {
        
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        //1、如果更新，显示新特性，否则显示欢迎
        let v = isNewVersion ? WBNewFeatureView.newFeatureView() : WBWelcomeView.welcomeView()
        
        //2、添加视图
        view.addSubview(v)
    }
    
    private var isNewVersion: Bool {
        //1、当前版本
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        //2、沙盒版本
        let path = String().documentFilePath(fileName: "version")
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        //3、存储当前版本
        try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        //4、对比版本
        return currentVersion != sandboxVersion
    }
}
