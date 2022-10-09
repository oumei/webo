//
//  WBRefreshControl.swift
//  webo
//
//  Created by OMi on 2021/5/10.
//

import UIKit

private let WBRefreshOffset: CGFloat = 100

enum WBRefreshState {
    case Normal        //普通状态，什么都不做
    case Pulling       //超过临界点，如果放手，开始刷新
    case willRefresh   //用户超过临界点，并且放手
}

class WBRefreshControl: UIControl {
    
    //滚动视图的父视图，下拉刷新应该适用于 UITableView / UICollectionView
    private weak var scrollView: UIScrollView?
    
    private lazy var refreshView: WBRefreshView = WBRefreshView.refreshView()
    
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    /**
     willMove      使用 addSubview 方法会调用
     - 当添加到父视图的时候，newSuperview 是父视图
     - 当父视图被移除，newSuperview 是nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //记录父视图
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        scrollView = sv
        
        //KVO 监听父视图的 contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print(scrollView?.contentOffset)
        
        guard let sv = scrollView else {
            return
        }
        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        //如果正在刷新，不传递
        if refreshView.refreshState != .willRefresh {
            refreshView.parentViewHeight = height
        }
        
//        print(height)
        //判断临界点
        if sv.isDragging {
            if height > WBRefreshOffset && refreshView.refreshState == .Normal{
                refreshView.refreshState = .Pulling
//                print("放手刷新...")
            } else if height <= WBRefreshOffset && (refreshView.refreshState == .Pulling){
//                print("继续使劲...")
                refreshView.refreshState = .Normal
            }
        } else {
            //放手 - 判断是否超过临界点
            if refreshView.refreshState == .Pulling {
//                print("准备开始刷新...")
                
                beginRefreshing()
                
                //发送刷新数据的事件
                sendActions(for: .valueChanged)
            }
        }
    }
    
    func beginRefreshing() {
        //print("开始刷新")
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState == .willRefresh {
            return
        }
        
        //设置刷新视图的状态
        refreshView.refreshState = .willRefresh
        //修改表格的contentInset
        var inset = sv.contentInset
        inset.top += WBRefreshOffset
        sv.contentInset = inset
        
        //刷新视图的父视图高度
        refreshView.parentViewHeight = WBRefreshOffset
    }

    func endRefreshing() {
        //print("结束刷新")
        //恢复刷新视图的状态
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState != .willRefresh {
            return
        }
        
        refreshView.refreshState = .Normal
        
        var inset = sv.contentInset;
        inset.top -= WBRefreshOffset
        sv.contentInset = inset
        
    }

}


extension WBRefreshControl {
    private func setupUI() {
        backgroundColor = superview?.backgroundColor
        
        //refreshView.clipsToBounds = true
        addSubview(refreshView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
}
