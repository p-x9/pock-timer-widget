//
//  TimerWidget.swift
//  pock-timer-widget
//
//  Created by p-x9 on 2021/03/07.
//

import Foundation
import PockKit

class TimerWidget: PKWidget {
    var identifier: NSTouchBarItem.Identifier = NSTouchBarItem.Identifier(rawValue: "TimerWidget")
    var customizationLabel: String = "Timer"
    var view: NSView!

    private var timerView = TimerView()

    required init() {
        view = timerView
    }

}

extension TimerWidget: PKScreenEdgeMouseDelegate {
    private func shouldHighlight(for location: NSPoint, in view: NSView) -> Bool {
        timerView.convert(timerView.bounds, to: view).contains(location)
    }

    func screenEdgeController(_ controller: PKScreenEdgeController, mouseEnteredAtLocation location: NSPoint, in view: NSView) {
        timerView.isHighlighted = shouldHighlight(for: location, in: view)
    }

    func screenEdgeController(_ controller: PKScreenEdgeController, mouseMovedAtLocation location: NSPoint, in view: NSView) {
        timerView.isHighlighted = shouldHighlight(for: location, in: view)
    }

    func screenEdgeController(_ controller: PKScreenEdgeController, mouseClickAtLocation location: NSPoint, in view: NSView) {
        timerView.isHighlighted = shouldHighlight(for: location, in: view)
        if timerView.isHighlighted {
            timerView.state == .stopping ? timerView.start(): timerView.stop()
        }
    }

    func screenEdgeController(_ controller: PKScreenEdgeController, mouseExitedAtLocation location: NSPoint, in view: NSView) {
        timerView.isHighlighted = false
    }
}
