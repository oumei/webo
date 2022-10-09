//
//  WBStatusCell.swift
//  webo
//
//  Created by OMi on 2021/5/1.
//

import UIKit
//如果设置可选协议方法需要添加 @objc
@objc protocol WBStatusCellDelegate:NSObjectProtocol {
    // 微博 cell 选中 URL 字符串
    @objc optional func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String)
}

class WBStatusCell: UITableViewCell {
    //头像
    @IBOutlet weak var iconView: UIImageView!
    //姓名
    @IBOutlet weak var nameLabel: UILabel!
    //会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    //来源
    @IBOutlet weak var sourceLabel: UILabel!
    //认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    //微博正文
    @IBOutlet weak var statusLabel: WBLabel!
    //底部工具栏
    @IBOutlet weak var toolBar: WBStatusToolBar!
    //配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    //被转发微博的正文
    @IBOutlet weak var retweetedLabel: WBLabel?
    //代理
    weak var delegate: WBStatusCellDelegate?
    
    
    var viewModel: WBStatusViewModel? {
        didSet {
            //微博正文
            statusLabel?.attributedText = viewModel?.statusAttrText
            //转发微博的文字
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
            //姓名
            nameLabel.text = viewModel?.status.user?.screen_name
            //会员图标
            memberIconView.image = viewModel?.memberIcon
            //认证图标
            vipIconView.image = viewModel?.vipIcon
            //头像
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "head_default"), isAvatar: true)
            
            toolBar.viewModel = viewModel
            
            //设置配图
            pictureView.viewModel = viewModel
            
            
            //设置来源
            //sourceLabel.text = viewModel?.sourceStr
            sourceLabel.text = viewModel?.status.source
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //离屏渲染 - 异步绘制
        self.layer.drawsAsynchronously = true
        //栅格化 - 异步绘制之后，会生成一张独立的图像，cell 在屏幕上滚动的时候，本质上滚动的是这张图片
        //cell 优化，要尽量减少图层的数量，相当于就只有一层
        //停止滚动之后，可以接收监听
        self.layer.shouldRasterize = true
        //使用“栅格化” 必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        //设置微博文本代理
        statusLabel.delegate = self
        retweetedLabel?.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension WBStatusCell: WBLabelDelegate {
    func labelDidSeletedLinkText(label: WBLabel, text: String) {
        //判断是否是 URL
        if !text.hasPrefix("http://") {
            return
        }
        delegate?.statusCellDidSelectedURLString?(cell: self, urlString: text)
    }
}
