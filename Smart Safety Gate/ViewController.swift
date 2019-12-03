//
//  ViewController.swift
//  Smart Safety Gate
//
//  Created by Joseph Shonle on 8/28/19.
//  Copyright © 2019 Joseph Shonle. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController, UITextFieldDelegate, CocoaMQTTDelegate {
    
    
    var mqttClient: CocoaMQTT = CocoaMQTT(clientID: "iOS Device", host: "172.20.10.4", port: 1884)

    @IBOutlet weak var IPTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        IPTextField?.delegate = self
        mqttClient.delegate = self
        mqttClient.subscribe("rpi/history")
        
    }
    
    @IBAction func setIPAddress(_ sender: Any) {
        mqttClient.host = IPTextField?.text ?? ""
    }
    
    

    @IBAction func connect(_ sender: Any) {
        print("status: \(mqttClient.connState)")
        let bool = mqttClient.connect(timeout: 5)
        print(bool)
        print("status: \(mqttClient.connState)")

    }
    
    @IBAction func disconnect(_ sender: Any) {
        mqttClient.disconnect()
    }
    
    @IBAction func gpioSW40(_ sender: UISwitch) {
        let json = "{\"state\": \(sender.isOn)}"
        mqttClient.publish("rpi/light", withString: json)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        //TRACE("ack: \(ack)")
        print("success")
        if ack == .accept {
            //mqtt.subscribe("chat/room/animals/client/+", qos: CocoaMQTTQoS.qos1)
//
//            let chatViewController = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
//            chatViewController?.mqtt = mqtt
//            navigationController!.pushViewController(chatViewController!, animated: true)
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
        //TRACE("message: \(message.string.description), id: \(id)")

        //let name = NSNotification.Name(rawValue: "MQTTMessageNotification" + animal!)
        //NotificationCenter.default.post(name: name, object: self, userInfo: ["message": message.string!, "topic": message.topic])
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

