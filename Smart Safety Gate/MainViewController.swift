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

class MainViewController: UIViewController, CocoaMQTTDelegate {
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var inchesLabel: UILabel!
    
    var mqttClient: CocoaMQTT = CocoaMQTT(clientID: "iOS Device", host: "192.168.43.18", port: 1883)
    
    var lightIsOff = false
    let loadingHud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(mqttClient.connect())
        var defaultHeight = UserDefaults.standard.integer(forKey: "autoHeight")
        defaultHeight = defaultHeight == 0 ? 36 : defaultHeight
        inchesLabel.text = "\(defaultHeight)\""
        heightSlider.value = Float(defaultHeight)
        mqttClient.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(mqttClient.connect())
        mqttClient.subscribe("recommendation")
        mqttClient.publish("iosToRpi", withString: "recommendation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mqttClient.disconnect()
    }
    
    @IBAction func lockButtonTouched(_ sender: Any) {
        mqttClient.publish("iosToRpi", withString: "Unlock")
    }
    
    @IBAction func lightButtonTouched(_ sender: Any) {
        //if switch == on, publishes to tell light to turn on
        if lightIsOff {
            mqttClient.publish("iosToRpi", withString: "LEDOn")
            lightIsOff = false
        }
        //if switch == off, publishes to tell light to turn off
        else {
            mqttClient.publish("iosToRpi", withString: "LEDOff")
            lightIsOff = true
        }
    }
    
    
    @IBAction func updateDataButton(_ sender: Any) {
        self.loadingHud.textLabel.text = "Updating Settings"

        loadingHud.show(in: (self.navigationController?.view!)!)
        mqttClient.publish("iosToRpi", withString: "SetSensorHeight\(UserDefaults.standard.integer(forKey: "autoHeight"))")
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
        inchesLabel.text = "\(Int(sender.value)) cm"
        UserDefaults.standard.set(Int(sender.value), forKey: "autoHeight")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
            //TRACE("ack: \(ack)")
            print("success")
            if ack == .accept {
                
            }
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
            //TRACE("new state: \(state)")'
            print("state to:  " + state.description)
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
            //TRACE("message: \(message.string.description), id: \(id)")
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
            //TRACE("id: \(id)")
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
            
            let topic = message.topic
            let pl = String(bytes: message.payload, encoding: .utf8)
            print("\(topic): \(pl ?? "failed conversion")")
            
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
            //TRACE("topics: \(topics)")
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
            //TRACE("topic: \(topics)")
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
            //print(something)
        }
        
        func mqttDidPing(_ mqtt: CocoaMQTT) {
            //TRACE()
        }
        
        func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
            //TRACE()
        }

        func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
            //TRACE("\(err.description)")
            print("fail")
        }
    
}
