//
//  ContentView.swift
//  time-slice
//
//  Created by Halil Can on 18.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showTooltip = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("heyyy!")
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    withAnimation {
                        showTooltip.toggle()
                    }
                }) {
                    Image(systemName: "info.circle")
                }
                .popover(isPresented: $showTooltip, arrowEdge: .top) {
                    Text("Dummy tooltip içeriği")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
