//
//  ViewController.swift
//  Old Face Sample
//
//  Created by 马陈爽 on 2020/9/18.
//  Copyright © 2020 马陈爽. All rights reserved.
//

import UIKit
import GPUImage
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var renderView: RenderView!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var transferBtn: UIButton!
    private var imageInput: PictureInput!
    private var samplerImage: UIImage!
    
    private var effectOperation: BrightnessAdjustment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let image = UIImage(named: "jjysample.jpeg")!
        let maxLength = max(image.size.width, image.size.height)
        if maxLength > 2048 {
            self.samplerImage = image.resizeImageTo(target: 2048)
        } else {
            self.samplerImage = image.decompressImage()!
        }
    
        self.imageInput = PictureInput(image: self.samplerImage)
        self.effectOperation = BrightnessAdjustment()
        self.imageInput --> self.effectOperation --> self.renderView
        self.imageInput.processImage()
    }

    @IBAction func sliderValueChange(_ sender: UISlider) {
        self.effectOperation.brightness = sender.value;
        self.imageInput.processImage()
    }
    
    @IBAction func transferBtnClick(_ sender: UIButton) {
        FBFaceDetectManager.default.detectLandmarks(by: self.samplerImage) { (faceLandmarks, error) in
            if let error = error {
                debugPrint("\(error)")
            }
            guard let faceLandmarks = faceLandmarks else {
                return
            }
            debugPrint(faceLandmarks)
        }
    }
}


extension UIImage {
    func resizeImageTo(target: CGFloat) -> UIImage? {
        //prepare constants
        guard let cgImage = self.cgImage else {
            return self
        }
        
        let width = self.size.width
        let height = self.size.height
        let scale = width/height
        
        var sizeChange = CGSize()
        
        if width <= target && height <= target{ //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            return self
        }else if width > target || height > target {//b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
            
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = target
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if scale >= 0.5 && scale <= 1 {
                
                let changedheight:CGFloat = target
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if width > target && height > target {//宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
                
                if scale > 2 {//高的值比较小
                    
                    let changedheight:CGFloat = target
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }else if scale < 0.5{//宽的值比较小
                    
                    let changedWidth:CGFloat = target
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }
            }else {//d, 宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
                return self
            }
        }
        let w = Int(sizeChange.width)
        let h = Int(sizeChange.height)
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.orderDefault.rawValue
        let newContext = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * bytesPerPixel, space: colorSpaceRef, bitmapInfo: bitmapInfo)
        let renderFrame = CGRect(x: 0.0, y: 0.0, width: sizeChange.width, height: sizeChange.height)
        newContext?.draw(cgImage, in: renderFrame)
        
        if let newCGImage = newContext?.makeImage() {
            return UIImage(cgImage: newCGImage)
        }
        
        return self
        
    }
    
    func decompressImage() -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        let width = cgImage.width
        let height = cgImage.height
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.orderDefault.rawValue
        let newContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * bytesPerPixel, space: colorSpaceRef, bitmapInfo: bitmapInfo)
        let renderFrame = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
        newContext?.draw(cgImage, in: renderFrame)
        
        if let newCGImage = newContext?.makeImage() {
            return UIImage(cgImage: newCGImage)
        }
        return nil
    }
}
