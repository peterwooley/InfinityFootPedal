//
//  AppDelegate.swift
//  SwiftUIMenuBar
//
//  Created by Peter Wooley on 1/21/21.
//  Copyright © 2021 Peter Wooley. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var pedal:Pedal!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        checkAccess();
    
        self.pedal = Pedal()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
            .environmentObject(pedal)

        // Create the popover
        let popover = NSPopover()
        popover.animates = false
        popover.contentSize = NSSize(width: 200, height: 150)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.squareLength))

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            
            let statusBarMenu = NSMenu(title: "Infinity Foot Pedal Menu")
            button.menu = statusBarMenu;
            button.menu?.addItem(withTitle: "Infinity Foot Pedal " + appVersion!, action: nil, keyEquivalent: "")
            button.menu?.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
            
        }
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func togglePopover(_ sender: NSStatusBarButton) {
        if let button = self.statusBarItem.button {
            let event = NSApp.currentEvent!
            
            if self.popover.isShown {
                self.popover.performClose(sender)
            }
            
            if event.type == NSEvent.EventType.rightMouseUp {
                button.menu?.popUp(positioning: nil, at: NSPoint(x: 0, y: self.statusBarItem.statusBar!.thickness+7), in: button)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.becomeKey()
            }
        
           
        }
    }
    
    func checkAccess() {
        //get the value for accesibility
        let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        //set the options: false means it wont ask
        //true means it will popup and ask
        let options = [checkOptPrompt: true]
        //translate into boolean value
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary?)

        if accessEnabled == true {
            //NSLog("Accessibility access granted")
        } else {
            NSLog("Accessibility access not allowed")
        }
    }
}

