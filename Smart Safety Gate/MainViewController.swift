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
    
    //@IBOutlet weak var heightSlider: UISlider!
    //@IBOutlet weak var inchesLabel: UILabel!
    
    var mqttClient: CocoaMQTT = CocoaMQTT(clientID: "iOS Device", host: "192.168.43.18", port: 1883)
    
    var lightIsOff = false
    let loadingHud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var defaultHeight = UserDefaults.standard.integer(forKey: "autoHeight")
        defaultHeight = defaultHeight == 0 ? 100 : defaultHeight
        //inchesLabel.text = "\(defaultHeight)\""
        //heightSlider.value = Float(defaultHeight)
        mqttClient.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(mqttClient.connect(timeout: 10))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mqttClient.disconnect()
    }
    
    @IBAction func lockButtonTouched(_ sender: Any) {
        mqttClient.publish("iosToRpi", withString: "Lock")
    }
    
    @IBAction func lightButtonTouched(_ sender: Any) {
        mqttClient.publish("iosToRpi", withString: "LED")
    }
    
    
    @IBAction func updateDataButton(_ sender: Any) {
        self.loadingHud.textLabel.text = "Updating Settings"
        if (mqttClient.connState == .disconnected || mqttClient.connState == .initial) {
            print(mqttClient.connect())
        }
        loadingHud.show(in: (self.navigationController?.view!)!)
        mqttClient.subscribe("rpiToIos")
        mqttClient.publish("iosToRpi", withString: "SetSensorHeight\(UserDefaults.standard.integer(forKey: "autoHeight"))")
        mqttClient.publish("iosToRpi", withString: "RequestAutoLock.txt")
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
//    @IBAction func sliderValueChanged(_ sender: UISlider) {
//        sender.setValue(sender.value.rounded(.down), animated: true)
//        inchesLabel.text = "\(Int(sender.value)) cm"
//        UserDefaults.standard.set(Int(sender.value), forKey: "autoHeight")
//    }
    
    func autoLockAlert(recommendation: String) {
        let df = DateFormatter()
        let split = recommendation.split(separator: " ")
        let day = df.weekdaySymbols[(Int(split[0])! + 13) % 12]
        let hour = String(Int(split[1])! % 12)
        let ampm = (Int(split[1])! >= 12) ? "PM" : "AM"
        let minute = String(split[2])
        let recString = "\(day) at \(hour):\(minute) \(ampm)"
        let actionSheet = UIAlertController(title: "Automatic Locking Recommendation", message: "Do you want to set automatic locking for \(recString)?", preferredStyle: .alert)
        let yes: UIAlertAction = UIAlertAction(title: "Yes", style: .default)
        { action -> Void in
            self.mqttClient.publish("iosToRpi", withString: "Yes")
        }
        let no: UIAlertAction = UIAlertAction(title: "No", style: .default) { action -> Void in }
        actionSheet.addAction(yes)
        actionSheet.addAction(no)
        self.present(actionSheet, animated: true)
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
            if (topic == "rpiToIos") {
                self.autoLockAlert(recommendation: pl ?? "")
                
            }
            
            
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
            print(err?.localizedDescription)
            print("fail")
        }
    
}
