//
//  WBStatusListViewModel.swift
//  webo
//
//  Created by OMi on 2021/4/27.
//

import Foundation
import SDWebImage

//微博数据列表视图模型
/**
 父类的选择
 - 如果类需要使用 ‘kvc’ 或者字典转模型框架设置对象值，类就需要继承自 NSObject
 - 如果类只是包装一些代码逻辑（写一些函数），可以不用任何父类，好处：更加轻量级
 */

///上拉刷新最大尝试次数
private let maxPullupTryTimes = 3

class WBStatusListViewModel {
    lazy var statusList = [WBStatusViewModel]()
    
    private var pullupErrorTimes = 0
    
    func loadStatus(pullup:Bool, completion:@escaping(_ isSuccess:Bool, _ shouldRefresh:Bool)->()) {
        
        //判断是否是上拉刷新，同时检查刷新错误
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        //取出数组中第一条微博的 ID
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            if !isSuccess {
                completion(false, false)
                return
            }
            
            //字典转模型
            guard let array = NSArray.yy_modelArray(with: WBStatus.self, json: list ?? []) as? [WBStatus] else {
                completion(isSuccess, false)
                return
            }
            
            var vmArray = [WBStatusViewModel]()
            for statusM in array {
                vmArray.append(WBStatusViewModel(model: statusM))
            }
            
            //拼接数据
            if pullup {
                //上拉刷新
                self.statusList += vmArray
            } else {
                //下拉刷新
                self.statusList = vmArray + self.statusList
            }
            
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                self.cacheSingleImage(list: vmArray, completion: completion)
                //完成回调
                //completion(isSuccess, true)
            }
            
        }
    }
    
    //缓存本次下载微博数组中的单张图像
    private func cacheSingleImage(list: [WBStatusViewModel], completion:@escaping(_ isSuccess:Bool, _ shouldRefresh:Bool)->()) {
        let group = DispatchGroup()
        
        //记录图片的长度
        var length = 0
        
        for vm in list {
            if vm.picURLs?.count != 1 {
                continue
            }
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                  let url = URL(string: pic) else {
                continue
            }
            
            //入组
            group.enter()
            
            //下载图片
            SDWebImageManager.shared()?.downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                if let image = image,
                   let data = image.pngData() {
                    length += data.count
                    
                    //缓存图片成功，更新配图视图的大小
                    vm.updateSingleImageSize(image: image)
                }
                
                //出组
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            //缓存完成
            print("图片缓存完成\(length/1024) K")
            //完成回调
            completion(true, true)
        }
    }
}
