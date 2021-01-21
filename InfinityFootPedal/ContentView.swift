//
//  ContentView.swift
//  SwiftUIMenuBar
//
//  Created by Peter Wooley on 1/21/21.
//  Copyright © 2021 Peter Wooley. All rights reserved.
//

import SwiftUI
import LaunchAtLogin

struct ContentView: View {
    @EnvironmentObject var pedal: Pedal
    
    var body: some View {
        VStack {
            Spacer()
                Text("IN-USB-2 Connected").show(self.$pedal.connected)
                Text("No IN-USB-2 Connected").hide(self.$pedal.connected)
            Divider()
            HStack(alignment: .center, spacing: 10) {
                VStack {
                    Text("Left")
                    Text("⬇").show(self.$pedal.leftState)
                }
                Divider()
                VStack {
                    Text("Middle")
                    Text("⬇").show(self.$pedal.middleState)
                }
                Divider()
                VStack {
                    Text("Right")
                    Text("⬇").show(self.$pedal.rightState)
                }
            }
            .toggleStyle(SwitchToggleStyle())
            Divider()
            LaunchAtLogin.Toggle()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Show: ViewModifier {
    @Binding var isVisible: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if isVisible {
            content
        } else {
            //content.hidden()
        }
    }
}

struct Hide: ViewModifier {
    @Binding var isHidden: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if isHidden {
            //content.hidden()
        } else {
            content
        }
    }
}

extension View {
    func show(_ isVisible: Binding<Bool>) -> some View {
        ModifiedContent(content: self, modifier: Show(isVisible: isVisible))
    }
    func hide(_ isHidden: Binding<Bool>) -> some View {
        ModifiedContent(content: self, modifier: Hide(isHidden: isHidden))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
