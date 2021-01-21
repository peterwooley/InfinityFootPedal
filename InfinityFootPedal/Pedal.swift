//
//  Pedal.swift
//  SwiftUIMenuBar
//
//  Created by Peter Wooley on 1/21/21.
//  Copyright © 2021 Peter Wooley. All rights reserved.
//

import Foundation
import USBDeviceSwift

class Pedal: ObservableObject {
    //make sure that rfDeviceMonitor always exist
    let rfDeviceMonitor = HIDDeviceMonitor([
        HIDMonitorData(vendorId: 0x05f3, productId: 0x00ff)
        ], reportSize: 64)
    
    let buttons:[Button]!
    @Published var leftState:Bool = false
    @Published var middleState:Bool = false
    @Published var rightState:Bool = false
    @Published var connected:Bool = false
    
    required init() {
        self.buttons = [
            Button(name:"Left", mask: 1, key:33),
            Button(name:"Middle", mask: 2, key:30),
            Button(name:"Right", mask: 4, key:42)
        ]
        
        let rfDeviceDaemon = Thread(target: self.rfDeviceMonitor, selector:#selector(self.rfDeviceMonitor.start), object: nil)
        rfDeviceDaemon.start()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.usbConnected), name: .HIDDeviceConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.usbDisconnected), name: .HIDDeviceDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidReadData), name: .HIDDeviceDataReceived, object: nil)
    }
    
    func update(data:UInt8) {
        for button in self.buttons {
            button.update(data: data)
        }
        leftState = buttons[0].state
        middleState = buttons[1].state
        rightState = buttons[2].state
    }
    
    @objc func usbConnected(notification: NSNotification) {
        NSLog("Infinity Foot Pedal Connected")
        
        DispatchQueue.main.async {
            self.connected = true;
        }
    }

    @objc func usbDisconnected(notification: NSNotification) {
        NSLog("Infinity Foot Pedal Disconnected")
        
        DispatchQueue.main.async {
            self.connected = false;
        }
    }
       
    @objc func hidReadData(notification: Notification) {
        let obj = notification.object as! NSDictionary
        let data = obj["data"] as! Data
        
        DispatchQueue.main.async {
            self.update(data: data[0])
        }
    }
}
