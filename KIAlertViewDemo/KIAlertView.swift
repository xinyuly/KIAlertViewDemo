//
//  AlertView.swift
//  KIAlertViewDemo
//
//  Created by lixinyu on 2018/12/19.
//  Copyright © 2018 lixinyu. All rights reserved.
//

import UIKit
import SnapKit

func kkScale(_ length: CGFloat) -> CGFloat {
    var screenRatio:CGFloat = 0
    if screenRatio == 0 {
        screenRatio = UIScreen.main.bounds.width/375.0
    }
    return screenRatio*length
}

class KIAlertView: UIView {
    
    var confirmCallBack:(()->Void)?
    var cancelCallBcak:(()->Void)?
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.layer.cornerRadius = kkScale(12)
        return view
    }()
    
    private let lTitle: UILabel = {
         let view = UILabel()
        view.textColor = UIColor.black
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: kkScale(16))
        view.numberOfLines = 1
        return view
    }()
    private let lMessage: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: kkScale(14))
        view.numberOfLines = 0
        return view
    }()
    private let bCancel: UIButton = {
        let view = UIButton()
        view.setTitleColor(UIColor.black, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: kkScale(17))
        view.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return view
    }()
    private let bConfirm: UIButton = {
        let view = UIButton()
        view.setTitleColor(UIColor.black, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: kkScale(17))
        view.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return view
    }()
    private let vline1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    private let vline2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    deinit {
        print("\(self.classForCoder)--deinit")
    }
    
    @discardableResult
    convenience init(title:String?,
                     titleAtt:NSAttributedString? = nil,
                     message: String?,
                     messsageAtt:NSAttributedString? = nil,
                     closeOutside: Bool = false,
                     action1Title:String,
                     action2Title:String? = nil,
                     handler1:(() -> Void)? = nil,
                     handler2:(() -> Void)? = nil) {
        self.init(frame: .zero)
        layout()
        lTitle.text = title
        bCancel.setTitle(action1Title, for: .normal)
        if let att = titleAtt {
            lTitle.attributedText = att
        }
        
        var attMsg = messsageAtt
        if let msg = message, msg.count > 0, attMsg == nil {
            let att = NSMutableAttributedString(string: msg)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 7
            paragraphStyle.alignment = .center
            att.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, msg.count))
            attMsg = att
        }
        lMessage.attributedText = attMsg
        if let handler = handler1 {
            cancelCallBcak = handler
        }
        if let handler = handler2 {
            confirmCallBack = handler
        }
        if closeOutside {
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        }
        
        if let title = action2Title, title.count > 0 {
            bConfirm.setTitle(action2Title, for: .normal)
            bCancel.snp.remakeConstraints { (make) in
                make.left.bottom.equalToSuperview()
                make.height.equalTo(kkScale(43))
                make.width.equalToSuperview().multipliedBy(0.5)
            }
            bConfirm.snp.makeConstraints { (make) in
                make.right.bottom.equalToSuperview()
                make.height.equalTo(bCancel)
                make.width.equalToSuperview().multipliedBy(0.5)
            }
        }
        var height: CGFloat = kkScale(80.0)
        lTitle.frame.size.width = kkScale(272) - kkScale(20)
        lTitle.sizeToFit()
        let width = kkScale(272) - kkScale(30)
        lMessage.frame.size.width = width
        lMessage.sizeToFit()
        height = height + lTitle.frame.size.height + lMessage.frame.size.height + kkScale(20)
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        show()
    }
    
    private func layout() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(contentView)
        contentView.addSubview(lTitle)
        contentView.addSubview(lMessage)
        contentView.addSubview(bCancel)
        contentView.addSubview(bConfirm)
        contentView.addSubview(vline1)
        contentView.addSubview(vline2)
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(kkScale(272))
            make.height.equalTo(kkScale(110))
            make.center.equalToSuperview()
        }
        lTitle.snp.makeConstraints { (make) in
            make.top.equalTo(kkScale(20))
            make.left.right.equalToSuperview()
        }
        lMessage.snp.makeConstraints { (make) in
            make.top.equalTo(lTitle.snp.bottom).offset(kkScale(20))
            make.left.equalToSuperview().offset(kkScale(15))
            make.right.equalToSuperview().offset(kkScale(-15))
        }
        bCancel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(kkScale(43))
             make.width.equalToSuperview().multipliedBy(1)
        }
        vline1.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bCancel.snp.top)
        }
        vline2.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.height.bottom.top.equalTo(bCancel)
            make.left.equalTo(bCancel.snp.right)
        }
        
    }
    
    private func show() {
        let view = UIApplication.shared.keyWindow!
        view.endEditing(true)
        view.addSubview(self)
        self.frame = view.bounds
        self.alpha = 0
        UIView.animate(withDuration: 0.15, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = 1.0
        }) { (finished) in
        }
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @objc func cancelAction() {
        dismiss()
        if let callBack = cancelCallBcak {
            callBack()
        }
    }
    
    @objc func confirmAction() {
        dismiss()
        if let callBack = confirmCallBack {
            callBack()
        }
    }
}

