//
//  WBNavigationController.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //隐藏默认的navigationbar
        navigationBar.isHidden = true
    }
    
    //重写push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //隐藏tabbar
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            //判断控制器的类型
            if let vc = viewController as? WBBaseViewController {
                
                var title = "返回"
                //判断控制器的级数
                if viewControllers.count == 1 {
                    title = viewControllers.first?.title ?? "返回"
                }
                
                //取出自定义的 navItem,设置左侧按钮为返回按钮
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent), isBack: true)
            }
        }
        
        
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
    @objc private func popToParent() {
        popViewController(animated: true)
    }
}
