//
//  TestTextField.swift
//  pock-timer-widget
//
//  Created by p-x9 on 2021/03/08.
//

import Cocoa

public class TimerTextLabel: NSView {

    public enum TextState {
        case on, off
    }

    private var timer: Timer?
    public var interval: TimeInterval = 1.0

    public var textState: TextState = .on
    public var state: TimerState = .stopping

    var time: TimeInterval = 0.0

    public var stringValue: String? {
        didSet {
            setNeedsDisplay(NSRect(x: 0, y: 0, width: frame.width, height: frame.height))
        }
    }
    public var textColor: NSColor = .headerTextColor
    public var font: NSFont?
    public private(set) lazy var textFontAttributes: [NSAttributedString.Key: Any] = {
        [
            NSAttributedString.Key.font: font ?? NSFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: textColor
        ]
    }()
    public var padding: CGFloat = 4 {
        didSet {
            setNeedsDisplay(NSRect(x: 0, y: 0, width: frame.width, height: frame.height))
        }
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.wantsLayer = true
        self.stringValue = "00:00"
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func formatString(time: TimeInterval, state: TextState = .on) -> String {
        if time < 60 * 60 {
            switch state {
            case .on:
                return String(format: "%02d:%02d", Int(time / 60), Int(time) % 60)
            case .off:
                return String(format: "%02d %02d", Int(time / 60), Int(time) % 60)
            }
        } else {
            let h = Int(time) / 3600
            let m = Int(time) % 3600 / 60
            let s = Int(time) % 3600 % 60
            switch state {
            case .on:
                return String(format: "%02d:%02d:%02d", h, m, s)
            case .off:
                return String(format: "%02d %02d %02d", h, m, s)
            }
        }
    }

    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let string = self.stringValue as NSString? else {
            return
        }
        var textFontAttributes = self.textFontAttributes
        var stringSize = string.size(withAttributes: textFontAttributes)

        if self.frame.width - padding < stringSize.width {
            let scale = (self.frame.width - padding) / stringSize.width
            let font = textFontAttributes[NSAttributedString.Key.font] as! NSFont
            let fontSize = font.fontDescriptor.fontAttributes[.size] as! CGFloat
            textFontAttributes[NSAttributedString.Key.font] = NSFont(descriptor: font.fontDescriptor, size: fontSize * scale)
            stringSize = string.size(withAttributes: textFontAttributes)
        }

        let x: CGFloat = self.frame.width / 2 - stringSize.width / 2
        let y: CGFloat = self.frame.height / 2 - stringSize.height / 2

        let point = NSPoint(x: x, y: y)

        string.draw(at: point, withAttributes: textFontAttributes)
    }

    public func start() {
        clearTimer()
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(update(_:)), userInfo: nil, repeats: true)
        guard let timer = timer else {
            return
        }
        RunLoop.main.add(timer, forMode: .common)
        self.state = .running
    }

    public func stop() {
        clearTimer()
        self.stringValue = TimerTextLabel.formatString(time: time, state: self.textState)
        self.state = .stopping
    }

    public func reset() {
        self.time = 0.0
        clearTimer()
        self.stringValue = TimerTextLabel.formatString(time: time, state: self.textState)
        self.state = .stopping
    }

    public func clearTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc
    func update(_ sender: Timer) {
        time += 1
        let string = TimerTextLabel.formatString(time: time, state: self.textState)

        DispatchQueue.main.async {
            self.stringValue = string
        }

        self.textState = self.textState == .on ? .off : .on
    }

}
