//
//  MyView.swift
//  UIBezierPath实现画图板
//
//  Created by iCodeWoods on 16/5/7.
//  Copyright © 2016年 iCodeWoods. All rights reserved.
//

import Foundation
import UIKit

class MyView: UIView {
    var color = UIColor.redColor() // 线条颜色
    var lineWidth: Float = 1.0 // 线条宽度
    private var allLine: [Dictionary<String, AnyObject>] = [] // 保存已有的线条
    private var cancelLine: [Dictionary<String, AnyObject>] = [] // 保存被撤销的线条
    private var bezier = UIBezierPath() // 贝赛尔曲线
    
    // MARK:- init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- actions
    func backImage() { // 两个数组相当于两个栈。后退时，让已有的一条线出栈，进入到撤销线条的栈中。
        if allLine.isEmpty == false { // 如果数组不为空才执行
            cancelLine.append(allLine.last!) // 入栈
            allLine.removeLast() // 出栈
            setNeedsDisplay() // 重绘界面
        }
    }
    
    func forwardImage() { // 两个数组相当于两个栈。前进时，让被撤销的一条线出栈，进入到已有线条的栈中。
        if cancelLine.isEmpty == false { // 如果数组不为空才执行
            allLine.append(cancelLine.last!) // 入栈
            cancelLine.removeLast() // 出栈
            setNeedsDisplay() // 重绘界面
        }
    }
    
    // MARK:- touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        bezier = UIBezierPath() // 新建贝塞尔曲线
        let point = touches.first!.locationInView(self) // 获取触摸的点
        bezier.moveToPoint(point) // 把刚触摸的点设置为bezier的起点
        var tmpDic = Dictionary<String, AnyObject>()
        tmpDic["color"] = color
        tmpDic["lineWidth"] = lineWidth
        tmpDic["line"] = bezier
        allLine.append(tmpDic) // 把线存入数组中
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self) // 获取触摸的点
        bezier.addLineToPoint(point) // 把移动的坐标存到贝赛尔曲线中
        setNeedsDisplay() // 重绘界面
    }
    
    // MARK:- drawRect
    override func drawRect(rect: CGRect) {
        for i in 0..<allLine.count {
            let tmpDic = allLine[i]
            let tmpColor = tmpDic["color"] as! UIColor
            let tmpWidth = tmpDic["lineWidth"] as! CGFloat
            let tmpPath = tmpDic["line"] as! UIBezierPath
            tmpColor.setStroke()
            tmpPath.lineWidth = tmpWidth
            tmpPath.stroke()
        }
    }
}
