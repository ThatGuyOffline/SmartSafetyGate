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

class ViewController: UIViewController, UITextFieldDelegate {
    
    var mqttClient: CocoaMQTT = CocoaMQTT(clientID: "iOS Device", host: "fart", port: 1884)

    @IBOutlet weak var IPTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        IPTextField.delegate = self
        
    }
    
    @IBAction func setIPAddress(_ sender: Any) {
        mqttClient.host = IPTextField.text ?? ""
    }
    

    @IBAction func connect(_ sender: Any) {
        let bool = mqttClient.connect()
        print(bool)

    }
    
    @IBAction func disconnect(_ sender: Any) {
        mqttClient.disconnect()
    }
    
    @IBAction func gpioSW40(_ sender: UISwitch) {
        let json = "{\"state\": \(sender.isOn)}"
        mqttClient.publish("rpi/gpio", withString: json)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

