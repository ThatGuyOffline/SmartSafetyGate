//
//  ViewController.swift
//  Smart Safety Gate
//
//  Created by Joseph Shonle on 8/28/19.
//  Copyright © 2019 Joseph Shonle. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {
    
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "192.168.0.X", port: 1883)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func connect(_ sender: Any) {
        mqttClient.connect()
    }
    
    @IBAction func disconnect(_ sender: Any) {
        mqttClient.disconnect()
    }
    
    @IBAction func gpioSW40(_ sender: UISwitch) {

    }
}

