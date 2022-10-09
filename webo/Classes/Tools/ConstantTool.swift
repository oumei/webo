//
//  ConstantTool.swift
//  webo
//
//  Created by OMi on 2021/4/20.
//

import Foundation
import UIKit


// 屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
// 屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
//是否是iphoneX
let isIPhoneX: Bool = SCREEN_HEIGHT >= 812.0 ? true : false
// 状态栏高度
let STATUSBAR_HIGH: CGFloat = isIPhoneX ? 48.0 : 20.0;
// 导航栏高度
let NAV_BAR_HEIGHT: CGFloat = STATUSBAR_HIGH + 44.0
//tabbar高度
let TabBar_HEIGHT: CGFloat = isIPhoneX ? 83.0 : 49.0
//底部安全高度
let SafeArea_Bottom_HEIGHT: CGFloat = isIPhoneX ? 34.0 : 0.0



//Mark : 微博配图视图常量
//配图视图外侧的间距
let WBStatusPictureViewOutterMargin: CGFloat = 12
//配图视图内部图像视图的间距
let WBStatusPictureViewInnerMargin: CGFloat = 3
//屏幕的宽度
let WBStatusPictureViewWidth = SCREEN_WIDTH - 2 * WBStatusPictureViewOutterMargin
//每个 item 默认的宽度
let WBStatusPictureViewItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin)/3

