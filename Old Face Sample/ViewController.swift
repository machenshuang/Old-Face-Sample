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
    @IBOutlet weak var imagePickerBtn: UIButton!

    private let imagePickerController = UIImagePickerController()
    
    private var imageInput: PictureInput!
    private var imageInput2: PictureInput?
    private var samplerImage: UIImage!
    private var imageOutput: PictureOutput!
    
    private var alphaBlend: AlphaBlend!
    
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
        self.alphaBlend = AlphaBlend()
        self.imageInput = PictureInput(image: self.samplerImage)
        self.imageInput --> self.renderView
        self.imageInput.processImage()
        
        self.imagePickerController.delegate = self
    }

    @IBAction func imagePickerBtnClick(_ sender: UIButton) {
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        //self.imageInput.processImage()
        let value = sender.value
        self.alphaBlend.mix = value
        DispatchQueue.global().async { [weak self] in
            autoreleasepool{
                guard let `self` = self else { return }
                guard let imageInput2 = self.imageInput2 else { return }
                imageInput2.processImage()
            }
        }
        
    }
    
    @IBAction func transferBtnClick(_ sender: UIButton) {
        FBFaceDetectManager.default.detectLandmarks(by: self.samplerImage) { [weak self](faceLandmarks, error) in
            guard let `self` = self else { return }
            if let error = error {
                debugPrint("\(error)")
            }
            guard let faceLandmarks = faceLandmarks else {
                return
            }
            
//            UIGraphicsBeginImageContext(self.samplerImage.size)
//            self.samplerImage.draw(at: .zero)
//            let context = UIGraphicsGetCurrentContext()
//            UIColor.red.set()
//            for (_, item) in faceLandmarks.enumerated() {
//                let rect = CGRect(x: item.x, y: item.y, width: 10, height: 10)
//                UIRectFill(rect)
//            }
//            let image = UIImage(cgImage: context!.makeImage()!)
//            UIGraphicsEndImageContext()
            self.imageInput.removeAllTargets()
            
            let oldFaceOperation = OldFaceOperation()
            oldFaceOperation.setupData(landmarks: faceLandmarks, inputSize: self.samplerImage.size)
            
            let overlayBlend = OverlayBlend()
            
            self.imageOutput = PictureOutput()
            self.imageOutput.imageAvailableCallback = { [weak self](image) in
                guard let `self` = self else { return }
                self.alphaBlend.mix = 0.5
                self.imageInput.removeAllTargets()
                self.alphaBlend.removeAllTargets()
                self.imageInput2 = PictureInput(image: image)
                self.imageInput --> self.alphaBlend --> self.renderView
                self.imageInput2! --> self.alphaBlend
                self.imageInput.processImage()
                self.imageInput2!.processImage()
                DispatchQueue.main.async {
                    self.sliderView.value = 0.5
                }
            }
            
            self.imageInput --> overlayBlend --> self.imageOutput
            self.imageInput --> oldFaceOperation --> overlayBlend
            self.imageInput.processImage()
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let maxLength = max(editedImage.size.width, editedImage.size.height)
            if maxLength > 2048 {
                self.samplerImage = editedImage.resizeImageTo(target: 2048)
            } else {
                self.samplerImage = editedImage.decompressImage()!
            }
        }
        self.imageInput.removeAllTargets()
        self.alphaBlend.removeAllTargets()
        self.imageInput = PictureInput(image: self.samplerImage)
        self.imageInput2?.removeAllTargets()
        self.imageInput2 = nil
        self.imageInput --> self.renderView
        self.imageInput.processImage()
        self.imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickerController.dismiss(animated: true, completion: nil)
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
