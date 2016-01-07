//
//  ViewController.swift
//  CycleScrollView
//
//  Created by zzh on 16/1/4.
//  Copyright © 2016年 Gavin Zeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /// init cycle scroll view
        let adView = GZCycleScrollView(frame: CGRectMake(0,64,view.frame.width,200))
        adView.delegate = self
        adView.isAutoScroll = true
        adView.timerInterval = 3
        view.addSubview(adView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: GZCycleScrollViewDelegate{

    func numberOfCells() -> Int {
        return 10
    }
    
    /**
     custom cell
     */
    func setUpCell() -> UIView {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        label.backgroundColor = UIColor.redColor()
        return label
    }
    
    /**
     bind data
     
     - parameter view:  target cell
     - parameter index: target index
     */
    func setCellModel(view: UIView, index: Int) {
        if let label = view as? UILabel{
            label.text = "\(index)"
        }
    }
    
    func didClickCellAtIndex(index: Int) {
        let alertView = UIAlertView(title: "you click at index = \(index)", message: nil, delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
    }
}

