//
//  GZCycleScrollView.swift
//  CycleScrollView
//
//  Created by zzh on 16/1/4.
//  Copyright © 2016年 Gavin Zeng. All rights reserved.
//

import Foundation
import UIKit

//MARK: GZCycleScrollViewDelegate
@objc protocol GZCycleScrollViewDelegate {
    func numberOfCells() -> Int
    func setUpCell() -> UIView
    func setCellModel(view: UIView, index:Int)
    func didClickCellAtIndex(index: Int)
}

//MARK: GZCycleScrollView
class GZCycleScrollView: UIView, UIScrollViewDelegate{
    private var contentScrollView: UIScrollView!
    private var currentCell: UIView!
    private var nextCell: UIView!
    private var preCell: UIView!
    private var autoScrollTimer: NSTimer?
    private var currentIndex: Int = 0
    
    weak var delegate: GZCycleScrollViewDelegate?{
        didSet{
            if let _ = delegate{
                reloadData()
            }
        }
    }
    
    var isAutoScroll: Bool = false{
        didSet{
            if isAutoScroll{
                startTimer()
            }
        }
    }
    
    var timerInterval: NSTimeInterval = 3{
        didSet{
            if isAutoScroll{
                startTimer()
            }
        }
    }
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }
    
    //MARK: reload
    func reloadData(){
        setCellModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: setup subviews
    private func setUpSubViews(){
        contentScrollView = UIScrollView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0)
        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.pagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        addSubview(contentScrollView)
        
        setUpCells()
        setCellModel()
        contentScrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
    }
    
    private func setUpCells(){
        if let tmpDelegate = delegate where currentCell == nil{
            currentCell = tmpDelegate.setUpCell()
            currentCell.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)
            currentCell.clipsToBounds = true
            contentScrollView.addSubview(currentCell)
            
            //添加点击事件
            let cellTapGesture = UITapGestureRecognizer(target: self, action: Selector("currentCellClick:"))
            currentCell.addGestureRecognizer(cellTapGesture)
            currentCell.userInteractionEnabled = true
            
            preCell = tmpDelegate.setUpCell()
            preCell.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            preCell.clipsToBounds = true
            contentScrollView.addSubview(preCell)
            
            nextCell = tmpDelegate.setUpCell()
            nextCell.frame = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)
            nextCell.clipsToBounds = true
            contentScrollView.addSubview(nextCell)
            
            if tmpDelegate.numberOfCells() > 1{
                contentScrollView.scrollEnabled = true
            }else{
                contentScrollView.scrollEnabled = false
            }
        }
    }
    
    private func setCellModel(){
        setUpCells()
        if let tmpDelegate = delegate{
            tmpDelegate.setCellModel(nextCell, index: getNextCellIndex())
            tmpDelegate.setCellModel(preCell, index: getPreCellIndex())
            tmpDelegate.setCellModel(currentCell, index: currentIndex)
        }
    }
    
    //MARK: helper
    private func isHasCells() -> Bool{
        if let tmpDalegate = delegate where tmpDalegate.numberOfCells() > 0{
            return true
        }else{
            return false
        }
    }
    
    private func getPreCellIndex() -> Int{
        if !isHasCells(){
            return 0
        }
        
        let tempIndex = currentIndex - 1
        if let tmpDelegate = delegate where tempIndex == -1 {
            return tmpDelegate.numberOfCells() - 1
        }else{
            return tempIndex
        }
    }
    
    private func getNextCellIndex() -> Int
    {
        if !isHasCells(){
            return 0
        }
        let tempIndex = currentIndex + 1
        if let tmpDelegate = delegate{
            return tempIndex < tmpDelegate.numberOfCells() ? tempIndex : 0
        }else{
            return 0
        }
    }
    
    //MRAK: click
    @objc private func currentCellClick(tap: UITapGestureRecognizer){
        delegate?.didClickCellAtIndex(currentIndex)
    }
    
    //MARK: scrollView delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if isAutoScroll{
            autoScrollTimer?.invalidate()
            autoScrollTimer = nil
        }
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            currentIndex = getPreCellIndex()
        }else if offset == self.frame.size.width * 2 {
            currentIndex = getNextCellIndex()
        }
        //reset data
        setCellModel()
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        //restart timer
        startTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(contentScrollView)
    }
    
    //MARK: timer
    private func startTimer(){
        stopTimer()
        if isAutoScroll && isHasCells(){
            autoScrollTimer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        }
    }
    
    @objc private func timerAction() {
        contentScrollView?.setContentOffset(CGPointMake(self.frame.size.width*2, 0), animated: true)
    }
    
    private func stopTimer(){
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
}