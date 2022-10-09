//
//  UIImageView+WebImage.swift
//  webo
//
//  Created by OMi on 2021/5/2.
//

import SDWebImage

extension UIImageView {
    // - urlString : 图片地址
    // - placeholderImage : 占位图片
    // - isAvatar : 是否是头像
    func cz_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) {[weak self] (image, _, _, _) in
            if isAvatar {
                self?.image = image?.avatarImage(size: self?.bounds.size)
            }
        }
    }
}

