//
//  AppDelegate.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //设置应用程序额外信息
        setupAdditions()
        
        window = UIWindow()
        window?.backgroundColor = .white
        window?.rootViewController = WBMainViewController()
        window?.makeKeyAndVisible()
        
        //模拟网络异步加载应用程序所需的json
        loadAppInfo()
        
        return true
    }

}

//Mark: 设置应用程序额外信息
extension AppDelegate {
    private func setupAdditions() {
        //1、设置 SVProgressHUD 最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        //2、设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        //3、取得用户授权显示通知【上方提示条/声音/badgeNumber】
        //iOS10以下
//        let notifySettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//        application.registerUserNotificationSettings(notifySettings)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .carPlay]) { (success, error) in
            print("授权" + (success ? "成功" : "失败"))
        }
    }
}

//Mark - 从服务器加载应用程序信息
extension AppDelegate {
    private func loadAppInfo() {
        //1、模拟异步
        DispatchQueue.global().async {
            
            //1、URL
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            
            //2、data
            let data = NSData(contentsOf: url!)
            
            //3、写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            data?.write(toFile: jsonPath, atomically: true)
            
            print("应用程序加载完毕 \(jsonPath)")
            
        }
    }
}

