//
//  ViewController.swift
//  KIAlertViewDemo
//
//  Created by lixinyu on 2019/1/7.
//  Copyright © 2019 lixinyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showAlert1(_ sender: Any) {
        let message = "预计您获得3个红包共\(6.7)"
        let att = NSMutableAttributedString(string: message)
        att.addAttributes([NSAttributedString.Key.foregroundColor:UIColor.red], range: NSRange(message.range(of: "\(6.7)")!, in: message))
        KIAlertView(title: "签到成功", message:nil, messsageAtt: att, action1Title: "知道了")
    }
    
    @IBAction func showAlert2(_ sender: Any) {
        KIAlertView(title: "签到成功", titleAtt: nil, message: "积分+10，坚持签到积分可以兑换好礼哦。坚持签到积分可以兑换好礼哦。坚持签到积分可以兑换好礼哦。坚持签到积分可以兑换好礼哦。", messsageAtt: nil, closeOutside: true, action1Title: "取消", action2Title:"确认", handler1: {
            print("点击了取消")
        }) {
            print("点击了确认")
        }
    }
}

