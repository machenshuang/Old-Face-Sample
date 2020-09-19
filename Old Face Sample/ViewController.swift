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
    
    private var camera: Camera!
    private var effectOperation: BrightnessAdjustment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.effectOperation = BrightnessAdjustment()
        do {
            self.camera = try Camera(sessionPreset: .photo)
            self.camera.runBenchmark = true
            self.camera --> self.effectOperation --> self.renderView
            self.camera.startCapture()
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
        
        
    }

    @IBAction func sliderValueChange(_ sender: UISlider) {
        self.effectOperation.brightness = sender.value;
    }
    
    
}

extension ViewController: CameraDelegate {
    func didCaptureBuffer(_ sampleBuffer: CMSampleBuffer) {
        
    }
}

