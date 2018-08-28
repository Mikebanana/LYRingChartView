//
//  ViewController.swift
//  LYRingChartViewDemo
//
//  Created by DisCover on 2018/8/28.
//  Copyright © 2018年 ly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ring:TDRingChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ring = TDRingChartView(frame: CGRect(x: (self.view.frame.width-150)/2, y: 150, width: 150, height: 150), percentArr: [0.25,0.25,0.25,0.25], colorArr: [UIColor.yellow ,UIColor.red,UIColor.cyan,UIColor.brown], durtion: 0.5)
        ring.titleArr =  ["可用余额","我的理财","我的资产","我的遗产"]
        self.view.addSubview(ring)
    }



}

