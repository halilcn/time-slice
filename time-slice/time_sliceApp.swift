//
//  time_sliceApp.swift
//  time-slice
//
//  Created by Halil Can on 18.05.2025.
//

import SwiftUI
import AppKit

@main
struct time_sliceApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        // Ana pencereyi kaldırıyoruz, menü bar app olacak
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Dock'ta görünmemesi için
        NSApplication.shared.setActivationPolicy(.accessory)
        
        // Menü bar iconu oluştur
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "gauge", accessibilityDescription: "Progress")
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        // Popover oluştur
        popover = NSPopover()
        popover.contentSize = NSSize(width: 220, height: 100)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PopoverContent())
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                // Her seferinde yeni bir PopoverContent oluştur
                popover.contentViewController = NSHostingController(rootView: PopoverContent())
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                // Popover'ın window'unu key yap
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
}

struct PopoverContent: View {
    // Haftanın, ayın ve yılın yüzde kaçının geçtiğini hesaplayan yardımcı fonksiyonlar
    private var weekProgress: Double {
        let calendar = Calendar.current
        let now = Date()
        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now)!
        let elapsed = now.timeIntervalSince(weekInterval.start)
        let total = weekInterval.duration
        return min(max(elapsed / total, 0), 1)
    }
    private var monthProgress: Double {
        let calendar = Calendar.current
        let now = Date()
        let monthInterval = calendar.dateInterval(of: .month, for: now)!
        let elapsed = now.timeIntervalSince(monthInterval.start)
        let total = monthInterval.duration
        return min(max(elapsed / total, 0), 1)
    }
    private var yearProgress: Double {
        let calendar = Calendar.current
        let now = Date()
        let yearInterval = calendar.dateInterval(of: .year, for: now)!
        let elapsed = now.timeIntervalSince(yearInterval.start)
        let total = yearInterval.duration
        return min(max(elapsed / total, 0), 1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ProgressItem(title: "Week", percent: weekProgress)
            ProgressItem(title: "Month", percent: monthProgress)
            ProgressItem(title: "Year", percent: yearProgress)
            Spacer(minLength: 0)
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Text("Quit")
                        .font(.system(size: 12, weight: .bold))
                }
            }
        }
        .padding(16)
        .frame(width: 220)
    }
}

struct ProgressItem: View {
    let title: String
    let percent: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray))
                    .frame(height: 16)
                Capsule()
                    .fill(Color.blue)
                    .frame(width: CGFloat(percent) * 188, height: 18)
                Text(String(format: "%0.1f%%", percent * 100))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.leading, 8)
            }
            .frame(width: 188, height: 18)
        }
    }
}
