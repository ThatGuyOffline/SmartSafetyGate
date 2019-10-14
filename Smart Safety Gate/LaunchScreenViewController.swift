//
//  LaunchScreenViewController.swift
//  Smart Safety Gate
//
//  Created by Joseph Shonle on 10/14/19.
//  Copyright © 2019 Joseph Shonle. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    var mask: CALayer?
    var storyboardIdentifier = "Main"
    var controllerIdentifier = "LoginViewController"
    var start = NSDate()
    var attempCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateLogo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func animateLogo(){
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 1.2
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 0.3
        
        let initalBounds = NSValue(cgRect: iconImageView.bounds)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 130, height: 130))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        
        keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.7, 1.3]
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
        keyFrameAnimation.fillMode = CAMediaTimingFillMode.forwards
        keyFrameAnimation.isRemovedOnCompletion = false
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.beginTime = CACurrentMediaTime() + 2
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.duration = keyFrameAnimation.duration-1
        fadeOutAnimation.isAdditive = false
        fadeOutAnimation.fillMode = CAMediaTimingFillMode.forwards
        fadeOutAnimation.isRemovedOnCompletion = false
        
        self.iconImageView.layer.add(keyFrameAnimation, forKey: "bounds")
        self.iconImageView.layer.add(fadeOutAnimation, forKey: "opacity")
        
        Timer.scheduledTimer(withTimeInterval: 1.3, repeats: false, block: {_ in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainNavigationController")
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(vc, animated: true, completion: nil)
        })
    }
    
}
