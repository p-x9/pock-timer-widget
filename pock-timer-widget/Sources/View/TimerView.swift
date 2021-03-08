//
//  TimerView.swift
//  pock-timer-widget
//
//  Created by p-x9 on 2021/03/08.
//

import Cocoa
import SnapKit
import PockKit

// public typealias TimerTextField = NSTextField

public class TimerView: NSView {

    public var didTap: (() -> Void)?
    public var didLongPress: (() -> Void)?

    public let imageView: NSImageView = {
        let imageView = NSImageView(frame: .zero)
        imageView.wantsLayer = true
        imageView.layer?.backgroundColor = .clear
        imageView.imageScaling = .scaleProportionallyDown
        return imageView
    }()

    public let titleView: TimerTextLabel = {
        let titleView = TimerTextLabel(frame: .zero)
        titleView.font = NSFont.systemFont(ofSize: 14)
        return titleView
    }()

    public var state: TimerState = .stopping

    private var timer: Timer?

    /*public let subtitleView: NSTextField = {
     let subtitleView = NSTextField(frame: .zero)
     subtitleView.backgroundColor = .clear
     subtitleView.font = NSFont.systemFont(ofSize: 7)
     subtitleView.textColor = NSColor(calibratedRed: 124 / 255, green: 131 / 255, blue: 127 / 255, alpha: 1)
     subtitleView.isEditable = false
     subtitleView.isSelectable = false
     subtitleView.isBezeled = false
     subtitleView.alignment = .center
     return subtitleView
     }()*/

    public var iconImage: NSImage? {
        didSet {
            self.imageView.image = iconImage
        }
    }

    public required init() {
        super.init(frame: .zero)

        self.wantsLayer = true
        self.layer?.cornerRadius = 5
        self.layer?.backgroundColor = NSColor.controlColor.cgColor

        addSubview(imageView)
        addSubview(titleView)
        // addSubview(subtitleView)
        imageView.image = NSImage(systemSymbolName: "stopwatch", accessibilityDescription: nil)

        imageView.snp.makeConstraints {maker in
            maker.width.equalTo(20)
            maker.top.bottom.equalTo(self)
            maker.left.equalTo(self)
        }
        titleView.snp.makeConstraints {maker in
            maker.left.equalTo(imageView.snp.right)
            maker.top.bottom.right.equalTo(self)
            maker.height.equalTo(30)
        }
        //        subtitleView.snp.makeConstraints {maker in
        //            maker.left.equalTo(titleView)
        //            maker.top.equalTo(titleView.snp.bottom)
        //            maker.right.equalTo(titleView)
        //            maker.bottom.greaterThanOrEqualTo(self)
        //        }
        snp.makeConstraints {maker in
            maker.width.equalTo(68)
        }

        let tapGesture = NSClickGestureRecognizer()
        tapGesture.target = self
        tapGesture.action = #selector(tap)
        tapGesture.allowedTouchTypes = .direct
        self.addGestureRecognizer(tapGesture)

        let longPressGesture = NSPressGestureRecognizer()
        longPressGesture.target = self
        longPressGesture.action = #selector(longPress)
        longPressGesture.allowedTouchTypes = .direct
        self.addGestureRecognizer(longPressGesture)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

    override public func touchesBegan(with event: NSEvent) {
        super.touchesBegan(with: event)

        self.layer?.backgroundColor = NSColor.controlColor.highlight(withLevel: 0.25)?.cgColor
    }
    override public func touchesEnded(with event: NSEvent) {
        super.touchesEnded(with: event)

        self.layer?.backgroundColor = NSColor.controlColor.cgColor
    }

    func start() {
        self.titleView.start()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in

        }
        self.state = .running
    }
    func stop() {
        self.titleView.stop()
        self.state = .stopping
    }
    func reset() {
        self.titleView.reset()
    }

    @objc
    func tap(_ sender: NSGestureRecognizer?) {
        NSLog("tapped")
        if self.state == .running {
            self.stop()
        } else {
            self.start()
        }
        self.layer?.backgroundColor = NSColor.controlColor.cgColor

        guard let didTap = didTap else {
            return
        }
        didTap()
    }

    @objc
    func longPress(_ sender: NSGestureRecognizer?) {
        NSLog("longPressed")
        if self.state == .stopping {
            self.reset()
        }
        self.layer?.backgroundColor = NSColor.controlColor.cgColor

        guard let didLongPress = didLongPress else {
            return
        }
        didLongPress()
    }
}
