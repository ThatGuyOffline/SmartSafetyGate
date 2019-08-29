//
//  ViewController.swift
//  Smart Safety Gate
//
//  Created by Joseph Shonle on 8/28/19.
//  Copyright © 2019 Joseph Shonle. All rights reserved.
//

import UIKit
import CocoaMQTT
import SwiftSocket

class ViewController: UIViewController {
    
    let url = "http://172.28.39.96"
    var mqttClient: CocoaMQTT = CocoaMQTT(clientID: "iOS Device", host: "172.28.39.96", port: 1884)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
    }
    

    @IBAction func connect(_ sender: Any) {
        let bool = mqttClient.connect()
        print(bool)

    }
    
    @IBAction func disconnect(_ sender: Any) {
        mqttClient.disconnect()
    }
    
    @IBAction func gpioSW40(_ sender: UISwitch) {
        if sender.isOn {
            mqttClient.publish("rpi/gpio", withString: "On")
            
        }
        else {
            mqttClient.publish("rpi/gpio", withString: "off")
        }
    }
}

