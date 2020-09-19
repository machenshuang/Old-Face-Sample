//
//  FBFaceDetectManager.swift
//  Old Face Sample
//
//  Created by 马陈爽 on 2020/9/19.
//  Copyright © 2020 马陈爽. All rights reserved.
//

import Foundation
import Firebase

typealias FaceLandmarksClosure = (_ landmarks: [CGPoint]?, _ error: Error?) -> Void

class FBFaceDetectManager {
    
    static let `default` = FBFaceDetectManager()
    
    private var faceDetector: VisionFaceDetector!
    private var detectQueue: DispatchQueue!
    
    func register() {
        let option = VisionFaceDetectorOptions()
        option.landmarkMode = .none
        option.contourMode = .all
        option.classificationMode = .none
        option.performanceMode = .fast
        let vision = Vision.vision()
        self.faceDetector = vision.faceDetector(options: option)
        self.detectQueue = DispatchQueue(label: "com.machenshuang.sample.FaceDetect")
    }
    
    func detectLandmarks(by image: UIImage, completeHandler: @escaping FaceLandmarksClosure) {
        self.detectQueue.async { [weak self] in
            guard let `self` = self else { return }
            do {
                let visionImage = VisionImage(image: image)
                let faces = try self.faceDetector.results(in: visionImage)
                guard faces.count > 0 else {
                    debugPrint("无人脸")
                    completeHandler(nil, nil)
                    return
                }
                
                let faceLandmarks = self.getLandmarks(forFace: faces[0])
                completeHandler(faceLandmarks, nil)
            } catch  {
                completeHandler(nil, error)
            }
        }
        
    }
    
    private func getLandmarks(forFace face: VisionFace) -> [CGPoint] {
        var landmarks = [CGPoint]()
        if let topRightEyebrowContour = face.contour(ofType: .rightEyebrowTop) {
            let points = topRightEyebrowContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let bottomRightEyebrowContour = face.contour(ofType: .rightEyebrowBottom) {
            let points = bottomRightEyebrowContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let topLeftEyebrowContour = face.contour(ofType: .leftEyebrowTop) {
            let points = topLeftEyebrowContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let bottomLeftEyebrowContour = face.contour(ofType: .leftEyebrowBottom) {
            let points = bottomLeftEyebrowContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let rightEyeContour = face.contour(ofType: .rightEye) {
            let points = rightEyeContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let leftEyeContour = face.contour(ofType: .leftEye) {
            let points = leftEyeContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let noseBridgeContour = face.contour(ofType: .noseBridge) {
            let points = noseBridgeContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let noseBottomContour = face.contour(ofType: .noseBottom) {
            let points = noseBottomContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let topUpperLipContour = face.contour(ofType: .upperLipTop) {
            let points = topUpperLipContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let upperLipBottomContour = face.contour(ofType: .upperLipBottom) {
            let points = upperLipBottomContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let lowerLipTopContour = face.contour(ofType: .lowerLipTop) {
            let points = lowerLipTopContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let lowerLipBottomContour = face.contour(ofType: .lowerLipBottom) {
            let points = lowerLipBottomContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        if let faceContour = face.contour(ofType: .face) {
            let points = faceContour.points
            for point in points {
                landmarks.append(point.toCGPoint())
            }
        }
        return landmarks
    }
    
}

extension VisionPoint {
    func toCGPoint() -> CGPoint {
        return CGPoint(x: Int(self.x.intValue), y: Int(self.y.intValue))
    }
}




