//
//  WBBaseViewController.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import UIKit

/**
 1、主体方法加上 @objc dynamic 子类的extension 才可以重写
 2、父类的 extension 中的方法加 @objc 子类的主体才可以重写
 */


//swift 中，利用 extension 可以把 ‘函数’ 按照功能分类管理，便于阅读和维护
//注意：
//1、extension 中不能有属性
//2、extension 中不能重写‘父类’本类的方法！重写父类方法是子类的职责，扩展是对类的扩展

class WBBaseViewController: UIViewController {
    
    //自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: STATUSBAR_HIGH, width: SCREEN_WIDTH, height: 44))
    
    //自定义导航标题，以后设置导航栏内容，使用navItem
    lazy var navItem = UINavigationItem()
    
    //控制自定义导航栏的subviews只重设一遍
    var canReset = true
    
    //表哥视图，如果用户没有登录，就不创建
    var tableView: UITableView?
    //刷新控件
    var refreshControl : WBRefreshControl?
    //上拉刷新标记
    var isPullup = false
    //用户登录标记
//    var userLogon = true
    //访客视图信息
    var visitorInfoDic: [String:String]?
    
    
    
    
    //@objc dynamic override func viewDidLoad() {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        WBNetworkManager.shared.userLogon ? loadData() : ()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess(n:)), name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification), object: nil)
    }
    
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //重写 title 的 didset
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //重新设置navigationBar的子view
        //只需在初始化后设置一遍
        if canReset == true {
            navigationBar.resetSubviews()
            canReset = false
            navigationBar.isHidden = false
        }
        
    }
    
    //加载数据，具体的实现由子类负责
    @objc func loadData() {
        //如果子类不实现方法，则默认停止刷新
        refreshControl?.endRefreshing()
    }

}

//设置界面
@objc extension WBBaseViewController {
    private func setupUI(){
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        WBNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
        
        
        //取消自动缩进
        if #available(iOS 11.0, *) {
            tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    //设置导航条
    private func setupNavigationBar() {
        //添加导航条
        view.addSubview(navigationBar)
        //添加导航title
        navigationBar.items = [navItem]
        //设置 navbar 的渲染颜色
        //navigationBar.barTintColor =
        navigationBar.isHidden = canReset
        //设置navbar 的字体颜色
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        //设置系统按钮的文字颜色
        navigationBar.tintColor = .orange
    }
    
    //设置表格视图 - 用户登录之后执行
    //子类重写此方法
    func setupTableView() {
        tableView = UITableView(frame:view.bounds, style:.plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        //设置数据源&代理
        tableView?.delegate = self
        tableView?.dataSource = self
        
        //设置内容缩进
        tableView?.contentInset = UIEdgeInsets(top: NAV_BAR_HEIGHT, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        tableView?.scrollIndicatorInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        
        //设置刷新控件
        refreshControl = WBRefreshControl()
        
        //添加到表格视图
        tableView?.addSubview(refreshControl!)
        
        //添加监听事件
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    private func setupVisitorView() {
        let visitorView = WBVisitorView(frame: view.bounds)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        //设置访客视图信息
        visitorView.visitorInfo = visitorInfoDic
        
        //添加访客视图按钮的监听方法
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        //设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
}

//在拓展中实现 UITableViewDelegate,UITableViewDataSource
extension WBBaseViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //基类只是准备方法，子类负责具体的实现
    //子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //只是保证没有语法错误
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //判断 indexPath 是否最后一行
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        //如果是最后一行并且没有开始上拉刷新
        if indexPath.section == section && row == (count - 1) && !isPullup {
            print("上拉刷新...")
            isPullup = true
            loadData()
        }
        
        
    }
}

//访客视图监听方法
extension WBBaseViewController {
    @objc private func login() {
        print("用户登录")
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    @objc private func register() {
        print("用户注册")
    }
    
    //登录成功处理
    @objc private func loginSuccess(n:NSNotification) {
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        //在访问 view 的 getter 时，如果 view = nil , 会调用 loadView -> viewDidLoad
        view = nil
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
}
