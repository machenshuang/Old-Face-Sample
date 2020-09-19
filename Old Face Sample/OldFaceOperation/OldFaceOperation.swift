//
//  OldFaceOperation.swift
//  Old Face Sample
//
//  Created by 马陈爽 on 2020/9/19.
//  Copyright © 2020 马陈爽. All rights reserved.
//

import Foundation
import GPUImage
import UIKit

class OldFaceOperation: BasicOperation {
    
    
    
    
    private func getControlPoints() -> [CGPoint] {
        var controlPoints: [CGPoint] = []
        
        //RIGHT_EYEBROW_TOP
        controlPoints.append(CGPoint(x: 645, y: 316))
        controlPoints.append(CGPoint(x: 624, y: 288))
        controlPoints.append(CGPoint(x: 588, y: 271))
        controlPoints.append(CGPoint(x: 532, y: 268))
        controlPoints.append(CGPoint(x: 469, y: 287))
        //RIGHT_EYEBROW_BUTTOM
        controlPoints.append(CGPoint(x: 632, y: 328))
        controlPoints.append(CGPoint(x: 611, y: 305))
        controlPoints.append(CGPoint(x: 578, y: 292))
        controlPoints.append(CGPoint(x: 526, y: 290))
        controlPoints.append(CGPoint(x: 464, y: 324))
        //LEFT_EYEBROW_TOP
        controlPoints.append(CGPoint(x: 146, y: 320))
        controlPoints.append(CGPoint(x: 176, y: 293))
        controlPoints.append(CGPoint(x: 219, y: 278))
        controlPoints.append(CGPoint(x: 274, y: 278))
        controlPoints.append(CGPoint(x: 336, y: 285))
        //LEFT_EYEBROW_BUTTOM
        controlPoints.append(CGPoint(x: 163, y: 331))
        controlPoints.append(CGPoint(x: 191, y: 311))
        controlPoints.append(CGPoint(x: 229, y: 300))
        controlPoints.append(CGPoint(x: 279, y: 301))
        controlPoints.append(CGPoint(x: 333, y: 322))
        //RIGHT_EYE
        controlPoints.append(CGPoint(x: 479, y: 396))
        controlPoints.append(CGPoint(x: 487, y: 390))
        controlPoints.append(CGPoint(x: 499, y: 381))
        controlPoints.append(CGPoint(x: 516, y: 372))
        controlPoints.append(CGPoint(x: 536, y: 370))
        controlPoints.append(CGPoint(x: 553, y: 372))
        controlPoints.append(CGPoint(x: 567, y: 376))
        controlPoints.append(CGPoint(x: 575, y: 381))
        controlPoints.append(CGPoint(x: 584, y: 387))
        controlPoints.append(CGPoint(x: 575, y: 393))
        controlPoints.append(CGPoint(x: 565, y: 398))
        controlPoints.append(CGPoint(x: 552, y: 401))
        controlPoints.append(CGPoint(x: 532, y: 402))
        controlPoints.append(CGPoint(x: 511, y: 401))
        controlPoints.append(CGPoint(x: 496, y: 399))
        controlPoints.append(CGPoint(x: 485, y: 398))
        //LEFT_EYE
        controlPoints.append(CGPoint(x: 212, y: 392))
        controlPoints.append(CGPoint(x: 219, y: 385))
        controlPoints.append(CGPoint(x: 230, y: 378))
        controlPoints.append(CGPoint(x: 244, y: 371))
        controlPoints.append(CGPoint(x: 262, y: 368))
        controlPoints.append(CGPoint(x: 283, y: 371))
        controlPoints.append(CGPoint(x: 298, y: 381))
        controlPoints.append(CGPoint(x: 312, y: 390))
        controlPoints.append(CGPoint(x: 318, y: 398))
        controlPoints.append(CGPoint(x: 313, y: 399))
        controlPoints.append(CGPoint(x: 301, y: 400))
        controlPoints.append(CGPoint(x: 282, y: 403))
        controlPoints.append(CGPoint(x: 262, y: 404))
        controlPoints.append(CGPoint(x: 247, y: 402))
        controlPoints.append(CGPoint(x: 232, y: 400))
        controlPoints.append(CGPoint(x: 220, y: 397))
        
        //NOSE_BRIDGE
        controlPoints.append(CGPoint(x: 406, y: 358))
        controlPoints.append(CGPoint(x: 406, y: 546))
        
        //NOSE_BOTTOM
        controlPoints.append(CGPoint(x: 330, y: 559))
        controlPoints.append(CGPoint(x: 405, y: 381))
        controlPoints.append(CGPoint(x: 478, y: 562))
        
        //UPPER_LIP_TOP
        controlPoints.append(CGPoint(x: 272, y: 652))
        controlPoints.append(CGPoint(x: 281, y: 646))
        controlPoints.append(CGPoint(x: 302, y: 644))
        controlPoints.append(CGPoint(x: 330, y: 642))
        controlPoints.append(CGPoint(x: 363, y: 640))
        controlPoints.append(CGPoint(x: 399, y: 648))
        controlPoints.append(CGPoint(x: 435, y: 642))
        controlPoints.append(CGPoint(x: 472, y: 647))
        controlPoints.append(CGPoint(x: 493, y: 652))
        controlPoints.append(CGPoint(x: 510, y: 656))
        controlPoints.append(CGPoint(x: 517, y: 659))
        
        //UPPER_LIP_BOTTOM
        controlPoints.append(CGPoint(x: 279, y: 655))
        controlPoints.append(CGPoint(x: 318, y: 664))
        controlPoints.append(CGPoint(x: 343, y: 666))
        controlPoints.append(CGPoint(x: 368, y: 669))
        controlPoints.append(CGPoint(x: 397, y: 675))
        controlPoints.append(CGPoint(x: 430, y: 672))
        controlPoints.append(CGPoint(x: 459, y: 670))
        controlPoints.append(CGPoint(x: 487, y: 670))
        controlPoints.append(CGPoint(x: 512, y: 661))
        
        //LOWER_LIP_TOP
        controlPoints.append(CGPoint(x: 506, y: 664))
        controlPoints.append(CGPoint(x: 486, y: 671))
        controlPoints.append(CGPoint(x: 458, y: 672))
        controlPoints.append(CGPoint(x: 430, y: 673))
        controlPoints.append(CGPoint(x: 397, y: 676))
        controlPoints.append(CGPoint(x: 368, y: 671))
        controlPoints.append(CGPoint(x: 343, y: 668))
        controlPoints.append(CGPoint(x: 319, y: 666))
        controlPoints.append(CGPoint(x: 287, y: 657))
        
        //LOWER_LIP_BOTTOM
        controlPoints.append(CGPoint(x: 509, y: 676))
        controlPoints.append(CGPoint(x: 493, y: 690))
        controlPoints.append(CGPoint(x: 464, y: 703))
        controlPoints.append(CGPoint(x: 436, y: 712))
        controlPoints.append(CGPoint(x: 398, y: 715))
        controlPoints.append(CGPoint(x: 361, y: 711))
        controlPoints.append(CGPoint(x: 336, y: 701))
        controlPoints.append(CGPoint(x: 312, y: 690))
        controlPoints.append(CGPoint(x: 285, y: 670))
        
        //FACE_OVAL
        controlPoints.append(CGPoint(x: 410, y: 154))
        controlPoints.append(CGPoint(x: 466, y: 155))
        controlPoints.append(CGPoint(x: 554, y: 179))
        controlPoints.append(CGPoint(x: 609, y: 219))
        controlPoints.append(CGPoint(x: 649, y: 257))
        controlPoints.append(CGPoint(x: 668, y: 307))
        controlPoints.append(CGPoint(x: 680, y: 357))
        controlPoints.append(CGPoint(x: 686, y: 418))
        controlPoints.append(CGPoint(x: 682, y: 477))
        controlPoints.append(CGPoint(x: 673, y: 536))
        controlPoints.append(CGPoint(x: 664, y: 601))
        controlPoints.append(CGPoint(x: 644, y: 668))
        controlPoints.append(CGPoint(x: 628, y: 718))
        controlPoints.append(CGPoint(x: 600, y: 770))
        controlPoints.append(CGPoint(x: 564, y: 802))
        controlPoints.append(CGPoint(x: 525, y: 862))
        controlPoints.append(CGPoint(x: 486, y: 849))
        controlPoints.append(CGPoint(x: 439, y: 863))
        controlPoints.append(CGPoint(x: 398, y: 866))
        controlPoints.append(CGPoint(x: 353, y: 863))
        controlPoints.append(CGPoint(x: 304, y: 844))
        controlPoints.append(CGPoint(x: 269, y: 823))
        controlPoints.append(CGPoint(x: 222, y: 798))
        controlPoints.append(CGPoint(x: 177, y: 768))
        controlPoints.append(CGPoint(x: 141, y: 715))
        controlPoints.append(CGPoint(x: 128, y: 655))
        controlPoints.append(CGPoint(x: 114, y: 589))
        controlPoints.append(CGPoint(x: 102, y: 524))
        controlPoints.append(CGPoint(x: 91, y: 462))
        controlPoints.append(CGPoint(x: 91, y: 403))
        controlPoints.append(CGPoint(x: 98, y: 343))
        controlPoints.append(CGPoint(x: 111, y: 290))
        controlPoints.append(CGPoint(x: 152, y: 239))
        controlPoints.append(CGPoint(x: 202, y: 199))
        controlPoints.append(CGPoint(x: 272, y: 170))
        controlPoints.append(CGPoint(x: 352, y: 153))
        
        return controlPoints
    }
}
