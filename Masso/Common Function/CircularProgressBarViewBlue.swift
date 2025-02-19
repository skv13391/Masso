//
//  CircularProgressBarView.swift
//  CircularBar
//
//  Created by Sunil on 28/03/23.
//

import Foundation
import UIKit


class CircularProgressBarViewBlue: UIView
{
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    override init(frame: CGRect) {
            super.init(frame: frame)
            self.createCircularPath()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.createCircularPath()
        }
    
    
    func createCircularPath() {
            // created circularPath for circleLayer and progressLayer
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 80, startAngle: startPoint, endAngle: endPoint, clockwise: true)
            // circleLayer path defined to circularPath
            circleLayer.path = circularPath.cgPath
            // ui edits
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.lineCap = .square
            circleLayer.lineWidth = 25.0
            circleLayer.strokeEnd = 1.0
            circleLayer.strokeColor = UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0).cgColor
            // added circleLayer to layer
            layer.addSublayer(circleLayer)
            // progressLayer path defined to circularPath
            progressLayer.path = circularPath.cgPath
            // ui edits
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.lineCap = .square
            progressLayer.lineWidth = 25.0
            progressLayer.strokeEnd = 0
            progressLayer.strokeColor = UIColor.init(red: 1.0/255.0, green: 133.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
            // added progressLayer to layer
            layer.addSublayer(progressLayer)
        }
    
    func progressAnimation(duration: TimeInterval,toValue : CGFloat) {
            // created circularProgressAnimation with keyPath
            let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
            // set the end time
            circularProgressAnimation.duration = duration
            circularProgressAnimation.fromValue = 0
            circularProgressAnimation.toValue = toValue

            circularProgressAnimation.fillMode = .forwards
            circularProgressAnimation.isRemovedOnCompletion = false
            progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        }
}

