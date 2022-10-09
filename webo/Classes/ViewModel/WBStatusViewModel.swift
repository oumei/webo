//
//  WBStatusViewModel.swift
//  webo
//
//  Created by OMi on 2021/5/1.
//

import Foundation
import UIKit
/**
 如果没有任何父类，如果希望在开发时调试，输出调试信息，需要
 1、遵守 CustomStringConvertible
 2、实现 description 计算型属性
 */
//单条微博视图模型
class WBStatusViewModel: CustomStringConvertible {
    
    //微博模型
    var status: WBStatus
    //会员图标
    var memberIcon: UIImage?
    //认证图标
    var vipIcon: UIImage?
    //转发文字
    var retweetedStr: String?
    //评论文字
    var commentStr: String?
    //点赞文字
    var likeStr: String?
    //来源字符串
    //var sourceStr: String?
    
    
    //配图视图大小
    var pictureViewSize = CGSize()
    
    //如果是被转发的微博，原创微博一定没有图
    var picURLs: [WBStatusPicture]? {
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    //微博正文的属性文本
    var statusAttrText: NSAttributedString?
    //被转发微博的正文
    var retweetedAttrText: NSAttributedString?
    
    //行高
    var rowHeight: CGFloat = 0
    
    
    
    init(model: WBStatus) {
        self.status = model
        //会员等级图标
        if model.user != nil && model.user!.mbrank > 0 && model.user!.mbrank < 11 {
            let imageName = "tag2_yellow\(model.user?.mbrank ?? 0)"
            memberIcon = UIImage(named: imageName)
        }
        
        //认证图标
        switch model.user?.verified_type {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
            break
            //其他状态缺少图片素材
//        case 2,3,5:
//            vipIcon = UIImage(named: "avatar_vip")
//            break
//        case 220:
//            vipIcon = UIImage(named: "avatar_vip")
//            break
        default:
            break
        }
        
        //设置底部计数字符串
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
        //计算配图视图大小(有原创计算原创的，有转发计算转发的)
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        
        //设置微博文本
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        //微博正文
        statusAttrText = WBEmonticonManager.shared.emotionString(string: model.text ?? "", font: originalFont)
        
        //转发的微博正文
        var rText = "@" + (status.retweeted_status?.user?.screen_name ?? "") + "："
        rText += (status.retweeted_status?.text ?? "")
        retweetedAttrText = WBEmonticonManager.shared.emotionString(string: rText, font: retweetedFont)
        
        //设置来源字符串
        //sourceStr = "来自 " + (model.source?.str_href()?.text ?? "")
        
        //计算行高
        updateRowHeight()
    }
    
    var description: String {
        return status.description
    }
    
    func updateRowHeight() {
        let margin: CGFloat = 12
        let iconHight: CGFloat = 34
        let toolBarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: SCREEN_WIDTH - 2 * margin, height: CGFloat(MAXFLOAT))
        
//        let originalFont = UIFont.systemFont(ofSize: 15)
//        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        //1、计算顶部高度
        height = 2 * margin + iconHight + margin
        
        //2、正文高度
        if let text = statusAttrText {
            //属性文本不需要再设置属性 attributes
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            
//            height += (text as NSString).boundingRect(with: viewSize,
//                                                      options: [.usesLineFragmentOrigin],
//                                                      attributes: [NSAttributedString.Key.font:originalFont],
//                                                      context: nil).height
        }
        
        //3、判断是否转发微博
        if status.retweeted_status != nil {
            height += 2 * margin
            //转发文本的高度
            if let text = retweetedAttrText {
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
//                height += (text as NSString).boundingRect(with: viewSize,
//                                                          options: [.usesLineFragmentOrigin],
//                                                          attributes: [NSAttributedString.Key.font:retweetedFont],
//                                                          context: nil).height
            }
        }
        
        //4、配图视图的高度
        height += pictureViewSize.height
        
        height += margin
        
        //5、底部工具栏高度
        height += toolBarHeight
        
        rowHeight = height
    }
    
    func updateSingleImageSize(image: UIImage) {
        var size = image.size
        
        //注意特大图
        let maxWidth: CGFloat = 300
        let minWidth: CGFloat = 40
        //宽度过宽
        if size.width > maxWidth {
            size.width = maxWidth
            //等比例调整高度
            size.height = size.width * image.size.height / image.size.width
        }
        //宽度过窄
        if size.width < minWidth {
            size.width = minWidth
            //等比例调整高度,控制高度不要过高，除4
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        
        size.height += WBStatusPictureViewOutterMargin
        pictureViewSize = size
        
        //更新行高
        updateRowHeight()
    }
    
    //计算评论、转发、点赞的数量字符串
    private func countString(count: Int, defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.02f万", Double(count)/10000)
    }
    
    //计算配图视图的大小
    private func calcPictureViewSize(count: Int?) -> CGSize {
        if count == 0 || count == nil {
            return CGSize()
        }
        
        
        //1、计算高度
        let row = (count! - 1)/3 + 1
        var height = WBStatusPictureViewOutterMargin
        height += CGFloat(row) * WBStatusPictureViewItemWidth
        height += CGFloat(row - 1) * WBStatusPictureViewInnerMargin
        
        
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
}
