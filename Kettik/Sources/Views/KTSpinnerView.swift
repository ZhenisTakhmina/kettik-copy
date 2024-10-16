//
//  KTSpinnerView.swift
//  Kettik
//
//  Created by Tami on 03.04.2024.
//

import UIKit

final class KTSpinnerView : KTView {
    
    private let poses: [Pose] = [
        .init(0.0, 0.000, 0.7),
        .init(0.5, 0.500, 0.5),
        .init(0.4, 1.000, 0.3),
        .init(0.5, 1.500, 0.1),
        .init(0.6, 1.875, 0.1),
        .init(0.3, 2.250, 0.3),
        .init(0.2, 2.625, 0.5),
        .init(0.5, 3.000, 0.7)
    ]
    
    private let backgroundLayer: CAShapeLayer = .init()
    private let spinnerLayer: CAShapeLayer = .init()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        backgroundLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: spinnerLayer.lineWidth / 2, dy: spinnerLayer.lineWidth / 2)).cgPath
        
        spinnerLayer.frame = bounds
        spinnerLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: spinnerLayer.lineWidth / 2, dy: spinnerLayer.lineWidth / 2)).cgPath
    }
    
    override public func didMoveToWindow() {
        animate()
    }
    
    init(
        color: UIColor = KTColors.Brand.accent.color,
        backgroundColor: UIColor = KTColors.Surface.secondary.color
    ) {
        super.init()
        backgroundLayer.strokeColor = backgroundColor.cgColor
        spinnerLayer.strokeColor = color.cgColor
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundLayer.frame = bounds
        backgroundLayer.fillColor = nil
        
        backgroundLayer.lineWidth = 10
        
        spinnerLayer.frame = bounds
        spinnerLayer.lineCap = .round
        spinnerLayer.fillColor = nil
        
        spinnerLayer.lineWidth = 10
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(spinnerLayer)
    }
}

private extension KTSpinnerView {
    
    func animate() {
        var time: CFTimeInterval = 0
        var times: [CFTimeInterval] = []
        var start: CGFloat = 0
        var rotations: [CGFloat] = []
        var strokeEnds: [CGFloat] = []
        
        let poses = self.poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(keyPath: #keyPath(CAShapeLayer.strokeEnd), duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
    }
    
    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        
        spinnerLayer.add(animation, forKey: animation.keyPath)
    }
}

private extension KTSpinnerView {
    
    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }
}

