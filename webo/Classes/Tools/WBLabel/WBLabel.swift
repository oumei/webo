//
//  WBLabel.swift
//  webo
//
//  Created by OMi on 2021/5/16.
//

import UIKit

@objc
protocol WBLabelDelegate: NSObjectProtocol {
    @objc optional func labelDidSeletedLinkText(label: WBLabel, text: String)
}

/**
 1、使用 TextKit 接管 label 的底层实现 -- 绘制 textStorage 的文本内容
 2、使用正则表达式过滤 url
 3、交互
 
 - UILabel 不能实现垂直顶部对齐，TextKit可以
 */

class WBLabel: UILabel {
    //重写属性
    //内容变化，需要让 textStorage 响应变化
    override var text: String? {
        didSet {
            prepareTextContent()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            prepareTextContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextSystem()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareTextSystem()
    }
    
    //Mark : 交互
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1、获取用户点击的位置
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        //2、获取当前点中字符的索引
        let idx = layoutManage.glyphIndex(for: location, in: textContainer)
        
        //3、判断 idx 是否在 URL 的ranges 范围内，如果在，就高亮
        for r in urlRange ?? [] {
            if NSLocationInRange(idx, r) {
                //高亮，修改文本的字体属性
                textStorage.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.red,
                     NSAttributedString.Key.backgroundColor:UIColor.gray], range: r)
                //如果需要重绘，需要调用 setNeedsDisplay 函数，但是不是 drawRect
                setNeedsDisplay()
                
                seletedText = (textStorage.string as NSString).substring(with: r)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        prepareTextContent()
        setNeedsDisplay()
        
        if seletedText != nil && (seletedText!.count > 0) {
            delegate?.labelDidSeletedLinkText?(label: self, text: seletedText ?? "")
            seletedText = ""
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        prepareTextContent()
        setNeedsDisplay()
        
        if seletedText != nil && (seletedText!.count > 0) {
            delegate?.labelDidSeletedLinkText?(label: self, text: seletedText ?? "")
            seletedText = ""
        }
    }
    
    //绘制文本
    /**
     - 应尽量避免带透明度的颜色，会影响性能
     */
    override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        
        //绘制背景
        layoutManage.drawBackground(forGlyphRange: range, at: CGPoint())

        //绘制 Glyphs 字形
        layoutManage.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //指定绘制文本的区域
        textContainer.size = bounds.size
    }

    //属性文本存储
    private lazy var textStorage = NSTextStorage()
    //负责文本‘字形’布局
    private lazy var layoutManage = NSLayoutManager()
    //设定文本绘制的范围
    private lazy var textContainer = NSTextContainer()

    weak var delegate: WBLabelDelegate?
    //选中的字符串
    var seletedText: String?
    
    
}


extension WBLabel {
    //准备文本系统
    func prepareTextSystem() {
        //0、开启用户交互
        isUserInteractionEnabled = true
        
        //1、准备文本内容
        prepareTextContent()
        
        //2、设置对象的关系
        textStorage.addLayoutManager(layoutManage)
        layoutManage.addTextContainer(textContainer)
    }
    
    //准备文本内容, 使用textStorage 接管 label 的内容
    func prepareTextContent() {
        if let attributedText = attributedText {
            textStorage.setAttributedString(attributedText)
        } else if let text = text {
            textStorage.setAttributedString(NSAttributedString(string: text))
        } else {
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        //设置 URL 字体的属性
        for r in urlRange ?? [] {
            textStorage.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.blue], range: r)
        }
    }
}

private extension WBLabel {
    //返回 textStorage 中 url 的 range 数组
    var urlRange: [NSRange]? {
        //1、正则表达式
        let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*","#.*?#","@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
        var ranges = [NSRange]()
        for pattern in patterns {
            let regx = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
            //2、多重匹配
            let matches = regx.matches(in: textStorage.string, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSRange(location: 0, length: textStorage.length))

            //3、遍历数组，生成 range 的数组
            for m in matches {
                ranges.append(m.range(at: 0))
            }
        }
        
        return ranges
    }
    
}

