//
//  DetailsTableViewController.swift
//  Smart Safety Gate
//
//  Created by Joseph Shonle on 11/5/19.
//  Copyright © 2019 Joseph Shonle. All rights reserved.
//

import Foundation
import UIKit
import CocoaMQTT
import JGProgressHUD

class DetailsTableViewController: UITableViewController, CocoaMQTTDelegate {
    
    var mqttClient: CocoaMQTT = CocoaMQTT(clientID: "iOS Device", host: "localhost", port: 1884)
    let loadingHud = JGProgressHUD(style: .dark)
    
    var details: String = "test"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mqttClient.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell")!
        cell.textLabel?.text = "Detail Title"
        cell.detailTextLabel?.text = self.details
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
