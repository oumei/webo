//
//  WBDemoViewController.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置标题
        title = "第\(navigationController?.viewControllers.count ?? 0)个"

        // Do any additional setup after loading the view.
    }
    
    
    @objc private func showNext() {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }

}


extension WBDemoViewController{
    
    override func setupTableView() {
        super.setupTableView()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
}
