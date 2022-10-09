//
//  WBHomeViewController.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import UIKit

//定义全局常量，尽量使用 private 否则全局可以调用
private let originalCellId = "originalCellId"
private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController {
    //微博数据数组
    private lazy var listViewModel = WBStatusListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //显示好友
    @objc private func showFriends() {
        print(#function)
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 加载数据
    override func loadData() {
        
        //用网络工具加载微博数据
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            print("加载数据结束")
            //结束下拉刷新控件
            self.refreshControl?.endRefreshing()
            //恢复上拉刷新标记
            self.isPullup = false
            //刷新表格
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
        
    }

}

//Mark： -表格数据源方法  具体的数据源方法实现，不需要super
extension WBHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let statusVM = listViewModel.statusList[indexPath.row]
        
        let cellId = (statusVM.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        
        cell.viewModel = statusVM
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let vm = listViewModel.statusList[indexPath.row]
        return vm.rowHeight
    }
}

//Mark: WBStatusCellDelegate
extension WBHomeViewController: WBStatusCellDelegate {
    func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String) {
        let vc = WBWebViewController()
        vc.urlString = urlString
        navigationController?.pushViewController(vc, animated: true)
    }
}

//设置界面
extension WBHomeViewController {
    //重写父类的方法
    override func setupTableView(){
        super.setupTableView()
        
        //设置导航栏按钮
        //无法高亮
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友",  target: self, action: #selector(showFriends))
        
        //注册cell
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        
        //设置行高
        //tableView?.rowHeight = UITableView.automaticDimension
        //tableView?.estimatedRowHeight = 300
        
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    private func setupNavTitle() {
        let title = WBNetworkManager.shared.userAccount.screen_name
        let btn = WBTitleButton(title: title)
        btn.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
        navItem.titleView = btn
    }
    
    @objc func clickTitleButton(btn:UIButton) {
        btn.isSelected = !btn.isSelected
    }
}
