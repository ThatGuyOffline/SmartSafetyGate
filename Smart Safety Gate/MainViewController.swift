//
//  MainViewController.swift
//  Smart Safety Gate
//
//  Created by Joseph Shonle on 10/14/19.
//  Copyright © 2019 Joseph Shonle. All rights reserved.
//

import Foundation
import UIKit
import CocoaMQTT
import JGProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var inchesLabel: UILabel!
    
    var mqttClient: CocoaMQTT = CocoaMQTT(clientID: "iOS Device", host: "172.20.10.4", port: 1884)
    let loadingHud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(mqttClient.connect())
        var defaultHeight = UserDefaults.standard.integer(forKey: "autoHeight")
        defaultHeight = defaultHeight == 0 ? 36 : defaultHeight
        inchesLabel.text = "\(defaultHeight)\""
        heightSlider.value = Float(defaultHeight)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(mqttClient.connect())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mqttClient.disconnect()
    }
    
    @IBAction func lockButtonTouched(_ sender: Any) {
        mqttClient.publish("rpi/lock", withString: "0")
    }
    
    @IBAction func lightButtonTouched(_ sender: Any) {
        mqttClient.publish("rpi/light", withString: "0")
    }
    
    
    @IBAction func updateDataButton(_ sender: Any) {
        self.loadingHud.textLabel.text = "Updating Settings"

        loadingHud.show(in: (self.navigationController?.view!)!)
        mqttClient.publish("rpi/heightValue", withString: "\(UserDefaults.standard.integer(forKey: "autoHeight"))")
        loadingHud.dismiss()
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
