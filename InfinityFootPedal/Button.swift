//
//  Button.swift
//  SwiftUIMenuBar
//
//  Created by Peter Wooley on 1/21/21.
//  Copyright © 2021 Peter Wooley. All rights reserved.
//

import Foundation

class Button: NSObject {
    var state:Bool = false
    let name:String
    let mask:UInt8
    let key:CGKeyCode
    
    required init(name:String, mask:UInt8, key:CGKeyCode) {
        self.name = name;
        self.mask = mask;
        self.key = key;
      }

    func update(data:UInt8) {
        let newState = (data & self.mask) == self.mask;
        if(newState != self.state) {
          if(newState) {
            self.pressed();
          } else {
            self.released();
          }

          self.state = newState;
        }
    }
    
    func pressed() {
        //NSLog("Pressed " + self.name)
        send(self.key, keyDown: true)
    }
    
    func released() {
        //NSLog("Release " + self.name)
        send(self.key, keyDown: false)
    }
    
    func send(_ keyCode: CGKeyCode, keyDown: Bool) {
        let keyEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown)
        keyEvent?.flags = [.maskCommand, .maskAlternate, .maskShift, .maskControl]
        keyEvent?.post(tap: .cghidEventTap)
    }
}
