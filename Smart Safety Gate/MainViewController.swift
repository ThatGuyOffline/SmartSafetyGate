//
//  MainViewController.swift
//  Smart Safety Gate
//
//  Created by Joseph Shonle on 10/14/19.
//  Copyright © 2019 Joseph Shonle. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var inchesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var defaultHeight = UserDefaults.standard.integer(forKey: "autoHeight")
        defaultHeight = defaultHeight == 0 ? 36 : defaultHeight
        inchesLabel.text = "\(defaultHeight)\""
        heightSlider.value = Float(defaultHeight)        
    }
    

    @IBAction func buttonTouched(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.2,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(.down), animated: true)
        inchesLabel.text = "\(Int(sender.value))\""
        UserDefaults.standard.set(Int(sender.value), forKey: "autoHeight")
    }
}
