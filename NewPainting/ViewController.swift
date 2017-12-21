//
//  ViewController.swift
//  NewPainting
//
//  Created by 桑島侑己 on 2017/12/07.
//  Copyright © 2017年 桑島侑己. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var selfView: UIView!
    var controlView: UIView!
    let labelValueX = UILabel()
    let labelValueY = UILabel()
    let sliderX = UISlider()
    let sliderY = UISlider()
    var valueX: Int = 0
    var valueY: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        mode = .setting //最初の画面のモード
        
        //scrollViewの設定
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 50.0
        scrollView.delegate = self
        
        //初期設定
        start()
    }
    
    enum Mode{ //モード
        case setting //最初のサイズ設定画面
        case writing //絵を描くとき
        case sub //その他操作中
    }
    
    var mode: Mode!
    
    func start(){
        //view設定
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        selfView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        controlView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        controlView.backgroundColor = UIColor.cyan
        controlView.alpha = 0.5
//        self.view.addSubview(controlView)
     
        //Width&Heightラベル
        let labelX = UILabel()
        let labelY = UILabel()
        labelX.frame.origin = CGPoint(x: 20, y: 160)
        labelY.frame.origin = CGPoint(x: 20, y: 240)
        labelX.text = "Width"
        labelY.text = "Height"
        labelX.sizeToFit()
        labelY.sizeToFit()
        self.selfView.addSubview(labelX)
        self.selfView.addSubview(labelY)
        
        //slider設定
        sliderX.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        sliderY.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        sliderX.center = CGPoint(x: self.selfView.center.x, y: labelX.layer.position.y)
        sliderY.center = CGPoint(x: self.selfView.center.x, y: labelY.layer.position.y)
        sliderX.minimumValue = 1
        sliderY.minimumValue = 1
        sliderX.maximumValue = 2000
        sliderY.maximumValue = 2000
        sliderX.setValue(300, animated: true)
        sliderY.value = 300
        self.selfView.addSubview(sliderX)
        self.selfView.addSubview(sliderY)
        sliderX.addTarget(self, action: #selector(valueXChanged(sender:)), for: .valueChanged)
        sliderY.addTarget(self, action: #selector(valueYChanged(sender:)), for: .valueChanged)
        
        //mainStartで呼ばれる
        valueX = Int(sliderX.value)
        valueY = Int(sliderY.value)

        //sliderの数値を表示するラベル
        labelValueX.frame.origin = CGPoint(x: 330, y: 160)
        labelValueY.frame.origin  = CGPoint(x: 330, y: 240)
        labelValueX.text = "______"
        labelValueY.text = "______"
        labelValueX.sizeToFit()
        labelValueY.sizeToFit()
        labelValueX.text = String(Int(sliderX.value))
        labelValueY.text = String(Int(sliderY.value))
        self.selfView.addSubview(labelValueX)
        self.selfView.addSubview(labelValueY)
        
        //設定終了ボタン
        let startButton = UIButton()
        startButton.frame.origin = CGPoint(x: 250, y: 450)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(UIColor.black, for: .normal)
        startButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        startButton.sizeToFit()
        self.selfView.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonPressed(sender:)), for: .touchUpInside)
    }
    @objc func photoButtonPressed(sender: UIButton){
        let rect2 = self.selfView.frame
        UIGraphicsBeginImageContextWithOptions(rect2.size, false, 10.0)
        let con = UIGraphicsGetCurrentContext()
        con!.setAllowsAntialiasing(false)
        self.selfView.layer.render(in: con!)
        let capture2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let subviews = self.selfView.subviews
        for subview in subviews{
                subview.removeFromSuperview()
        }
        let imageview = UIImageView()
        imageview.frame = rect2
        imageview.image = capture2
        self.selfView.addSubview(imageview)
        self.selfView.bringSubview(toFront: photoButton)
    }
    @objc func valueXChanged(sender: UISlider){
        valueX = Int(sender.value)
        labelValueX.text = String(Int(sender.value))
    }
    @objc func valueYChanged(sender: UISlider){
        valueY = Int(sender.value)
        labelValueY.text = String(Int(sender.value))
    }
    @objc func startButtonPressed(sender: UIButton){
        let subviews = self.selfView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
        mainStart()
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.selfView
    }
    var array: [[UIImageView]] = []
    func mainStart(){
        scrollView.contentSize = CGSize(width: valueX, height: valueY)
        self.selfView.frame = CGRect(x: 0, y: 0, width: valueX, height: valueY)
        print("finished")
        size = 1
        color.0 = 255
        color.1 = 0
        color.2 = 0
        mode = .writing
        print(mode)
        //
        photoButton.frame.origin = CGPoint(x: 20, y: 20)
        photoButton.setTitle("photo", for: .normal)
        photoButton.setTitleColor(UIColor.black, for: .normal)
        photoButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        photoButton.sizeToFit()
//        self.controlView.addSubview(photoButton)
        self.selfView.addSubview(photoButton)
        photoButton.addTarget(self, action: #selector(photoButtonPressed(sender:)), for: .touchUpInside)
        //
        //
    }
    
    var size: Int!
    let photoButton = UIButton()
    var color: (Int, Int, Int) = (0, 0, 0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .writing{
            scrollView.isScrollEnabled = false
            let touch = touches.first!
            let colorCode: String = "r"+String(color.0)+"g"+String(color.1)+"b"+String(color.2)
            let imageview = UIImageView()
            let locationX = touch.location(in: self.selfView).x
            let locationY = touch.location(in: self.selfView).y
            imageview.frame = CGRect(x: Int(locationX), y: Int(locationY), width: 1, height: 1)
            //
//            imageview.layer.position = CGPoint(x: CGFloat(Int(locationX)), y: CGFloat(Int(locationY)))
            //
            
//            let locationX = CGFloat(Int(touch.location(in: self.selfView).x * 10)) / CGFloat(10)
//            let locationY = CGFloat(Int(touch.location(in: self.selfView).y * 10)) / CGFloat(10)
//            imageview.frame = CGRect(x: locationX, y: locationY, width: CGFloat(0.1), height: CGFloat(0.1))
            imageview.image = UIImage(named: colorCode)
            self.selfView.addSubview(imageview)
            pastLoc.x = Float(locationX)
            pastLoc.y = Float(locationY)
        }
    }
    let q1 = DispatchQueue(label: "l1", attributes: .concurrent)
    var pastLoc: (x: Float, y: Float) = (x: 0, y: 0)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode != .writing{
            return
        }
        scrollView.isScrollEnabled = false
        let touch = touches.first!
        let colorCode: String = "r"+String(color.0)+"g"+String(color.1)+"b"+String(color.2)
        let imageview = UIImageView()
        let locationX = touch.location(in: self.selfView).x
        let locationY = touch.location(in: self.selfView).y
        imageview.frame = CGRect(x: Int(locationX), y: Int(locationY), width: 1, height: 1)
        //
//        imageview.layer.position = CGPoint(x: CGFloat(Int(locationX)), y: CGFloat(Int(locationY)))
        //
        imageview.image = UIImage(named: colorCode)
        self.selfView.addSubview(imageview)
//        q1.async {
            if Int(locationY) - Int(self.pastLoc.y) != 0 && Int(locationX) - Int(self.pastLoc.x) != 0{
                self.line(self.pastLoc.x, self.pastLoc.y, Float(locationX), Float(locationY), colorCode)
            }
//        }
        print("paintMoved")
        pastLoc.x = Float(locationX)
        pastLoc.y = Float(locationY)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    func line(_ pastLocX: Float, _ pastLocY: Float, _ nowLocX: Float, _ nowLocY: Float, _ colorCode: String){
        /*
         y = ax + b
         PY = aPX + b
         NY = aNX + b
         y - PY = (NY - PY)/(NX - PX)(x - PX)
         
         y = 100 - 30 / 50 - 10 * x - 10 + 30
           = x + 20
         */
        
        if Int(pastLocX) == Int(nowLocX){
            if Int(nowLocY) > Int(pastLocY){
                for y in Int(pastLocY)...Int(nowLocY){
                    DispatchQueue.main.async {
                        let imageview = UIImageView()
                        imageview.frame = CGRect(x: Int(nowLocX), y: y, width: 1, height: 1)
                        imageview.image = UIImage(named: colorCode)
                        self.selfView.addSubview(imageview)
                    }
                }
            } else if Int(pastLocY) > Int(nowLocY){
                for y in Int(nowLocY)...Int(pastLocY){
                    DispatchQueue.main.async {
                        let imageview = UIImageView()
                        imageview.frame = CGRect(x: Int(nowLocX), y: y, width: 1, height: 1)
                        imageview.image = UIImage(named: colorCode)
                        self.selfView.addSubview(imageview)
                    }
                }
            }
        } else if Int(pastLocY) == Int(nowLocY){
            if Int(nowLocX) > Int(pastLocX){
                for x in Int(pastLocX)...Int(nowLocX){
                    DispatchQueue.main.async {let imageview = UIImageView()
                        imageview.frame = CGRect(x: x, y: Int(nowLocY), width: 1, height: 1)
                        imageview.image = UIImage(named: colorCode)
                        self.selfView.addSubview(imageview)
                    }
                }
            } else if Int(pastLocX) > Int(nowLocX){
                for x in Int(nowLocX)...Int(pastLocX){
                    DispatchQueue.main.async {
                        let imageview = UIImageView()
                        imageview.frame = CGRect(x: x, y: Int(nowLocY), width: 1, height: 1)
                        imageview.image = UIImage(named: colorCode)
                        self.selfView.addSubview(imageview)
                    }
                }
            }
        } else if Int(nowLocX) > Int(pastLocX){
            for x in Int(pastLocX)...Int(nowLocX){
                let y = (nowLocY - pastLocY) / (nowLocX - pastLocX) * (Float(x) - pastLocX) + pastLocY
                DispatchQueue.main.async {
                    let imageview = UIImageView()
                    imageview.frame = CGRect(x: x, y: Int(y), width: 1, height: 1)
//                    imageview.layer.position = CGPoint(x: x, y: Int(y))
                    imageview.image = UIImage(named: colorCode)
                    self.selfView.addSubview(imageview)
                }
            }
            if Int(nowLocY) > Int(pastLocY){
                for y in Int(pastLocY)...Int(nowLocY){
                    let x = (nowLocX - pastLocX) / (nowLocY - pastLocY) * (Float(y) - pastLocY) + pastLocX
                    DispatchQueue.main.async {
                        let imageview = UIImageView()
                        imageview.frame = CGRect(x: Int(x), y: y, width: 1, height: 1)
                        imageview.image = UIImage(named: colorCode)
                        self.selfView.addSubview(imageview)
                    }
                }
            } else if Int(pastLocY) > Int(nowLocY){
                for y in Int(nowLocY)...Int(pastLocY){
                    let x = (nowLocX - pastLocX) / (nowLocY - pastLocY) * (Float(y) - pastLocY) + pastLocX
                    DispatchQueue.main.async {
                        let imageview = UIImageView()
                        imageview.frame = CGRect(x: Int(x), y: y, width: 1, height: 1)
                        imageview.image = UIImage(named: colorCode)
                        self.selfView.addSubview(imageview)
                    }
                }
            }
        } else if Int(pastLocX) > Int(nowLocX){
            for x in Int(nowLocX)...Int(pastLocX){
                let y = (nowLocY - pastLocY) / (nowLocX - pastLocX) * (Float(x) - pastLocX) + pastLocY
                DispatchQueue.main.async {
                    let imageview = UIImageView()
                    imageview.frame = CGRect(x: x, y: Int(y), width: 1, height: 1)
//                    imageview.layer.position = CGPoint(x: x, y: Int(y))
                    imageview.image = UIImage(named: colorCode)
                    self.selfView.addSubview(imageview)
                }
            }
            if Int(nowLocY) > Int(pastLocY){
                for y in Int(pastLocY)...Int(nowLocY){
                    let x = (nowLocX - pastLocX) / (nowLocY - pastLocY) * (Float(y) - pastLocY) + pastLocX
                    DispatchQueue.main.async {
                        let imageview = UIImageView()
                        imageview.frame = CGRect(x: Int(x), y: y, width: 1, height: 1)
                        imageview.image = UIImage(named: colorCode)
                        self.selfView.addSubview(imageview)
                    }
                }
            } else if Int(pastLocY) > Int(nowLocY){
                for y in Int(nowLocY)...Int(pastLocY){
                    let x = (nowLocX - pastLocX) / (nowLocY - pastLocY) * (Float(y) - pastLocY) + pastLocX
                    DispatchQueue.main.async {
                        let imageview = UIImageView()
                        imageview.frame = CGRect(x: Int(x), y: y, width: 1, height: 1)
                        imageview.image = UIImage(named: colorCode)
                        self.selfView.addSubview(imageview)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIScrollView{
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
    }
}
