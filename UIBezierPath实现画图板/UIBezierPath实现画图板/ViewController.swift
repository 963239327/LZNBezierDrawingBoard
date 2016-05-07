//
//  ViewController.swift
//  UIBezierPath实现画图板
//
//  Created by iCodeWoods on 16/5/7.
//  Copyright © 2016年 iCodeWoods. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height

class ViewController: UIViewController {
    private let drawingBoard = MyView() // 自定义view，也就是画图板部分
    private let mySlider = UISlider() // 滑动条，控制线条宽度
    private let mySegment = UISegmentedControl.init(items: ["红", "黑", "绿"]) // 分段控制器，控制线条颜色
    private let backBtn = UIButton.init(type: UIButtonType.Custom)
    private let saveBtn = UIButton.init(type: UIButtonType.Custom)
    private let forwardBtn = UIButton.init(type: UIButtonType.Custom)

    // MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        drawingBoard.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*2/3)
        view.addSubview(drawingBoard)
        
        let line = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(drawingBoard.frame), ScreenWidth, 0.5))
        line.backgroundColor = UIColor.grayColor()
        view.addSubview(line)
        
        let sliderLabel = UILabel.init(frame: CGRectMake(30, CGRectGetMaxY(drawingBoard.frame)+20, 100, 40))
        sliderLabel.text = "线条宽度"
        view.addSubview(sliderLabel)
        
        mySlider.frame = CGRectMake(ScreenWidth-sliderLabel.frame.origin.x-100, sliderLabel.frame.origin.y, 100, sliderLabel.frame.size.height)
        mySlider.addTarget(self, action: Selector("onClickSlider:"), forControlEvents: UIControlEvents.ValueChanged)
        mySlider.maximumValue = 3
        view.addSubview(mySlider)
        
        let segentmentLabel = UILabel.init(frame: CGRectMake(sliderLabel.frame.origin.x, CGRectGetMaxY(sliderLabel.frame)+20, sliderLabel.frame.width, sliderLabel.frame.height))
        segentmentLabel.text = "线条颜色"
        view.addSubview(segentmentLabel)
        
        mySegment.frame = CGRectMake(mySlider.frame.origin.x, segentmentLabel.frame.origin.y, mySlider.frame.width, mySlider.frame.height)
        mySegment.addTarget(self, action: Selector("onClickSegment:"), forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(mySegment)
        
        backBtn.frame = CGRectMake(segentmentLabel.frame.origin.x, CGRectGetMaxY(segentmentLabel.frame)+20, 80, 40)
        backBtn.addTarget(self, action: Selector("onClickBack:"), forControlEvents: UIControlEvents.TouchUpInside)
        backBtn.setTitle("后退", forState: UIControlState.Normal)
        backBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        view.addSubview(backBtn)
        
        saveBtn.frame = CGRectMake(0, 0, backBtn.frame.width, backBtn.frame.height)
        saveBtn.center = CGPointMake(ScreenWidth/2, backBtn.frame.origin.y+saveBtn.frame.height/2)
        saveBtn.addTarget(self, action: Selector("onClickSave:"), forControlEvents: UIControlEvents.TouchUpInside)
        saveBtn.setTitle("保存", forState: UIControlState.Normal)
        saveBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        view.addSubview(saveBtn)
        
        forwardBtn.frame = CGRectMake(ScreenWidth-backBtn.frame.width-backBtn.frame.origin.x, backBtn.frame.origin.y, backBtn.frame.width, backBtn.frame.height)
        forwardBtn.addTarget(self, action: Selector("onClickForward:"), forControlEvents: UIControlEvents.TouchUpInside) // TODO: #selector(onClickForward(_:)) ???
        forwardBtn.setTitle("前进", forState: UIControlState.Normal)
        forwardBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        view.addSubview(forwardBtn)
    }
    
    // MARK:- actions
    func onClickSlider(slider: UISlider) {
        drawingBoard.lineWidth = slider.value
    }
    
    func onClickSegment(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            drawingBoard.color = UIColor.redColor()
        case 1:
            drawingBoard.color = UIColor.blackColor()
        case 2:
            drawingBoard.color = UIColor.greenColor()
        default:
            drawingBoard.color = UIColor.redColor()
        }
    }
    
    func onClickBack(button: UIButton) {
        drawingBoard.backImage()
    }
    
    func onClickForward(button: UIButton) {
        drawingBoard.forwardImage()
    }
    
    func onClickSave(button: UIButton) {
        UIGraphicsBeginImageContext(drawingBoard.bounds.size) // 开始截取画图板
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext() // 截取到的图像
        UIGraphicsEndImageContext() // 结束截取
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil) // 把截取到的图像保存到相册中
        // 最后提示用户保存成功即可
        let alert = UIAlertView.init(title: "存储照片成功", message: "您已将照片存储于图片库中，打开照片程序即可查看。", delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
}

