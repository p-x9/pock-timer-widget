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
