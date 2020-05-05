//
//  GMStepper.swift
//  GMStepper
//
//  Created by Woramet Prompen on 2019-07-22.
//  Copyright © 2019 Woramet Prompen. All rights reserved.
//

import UIKit

@IBDesignable public class GMStepper: UIControl {

    @objc @IBInspectable public var value: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))

            let isInteger = floor(value) == value
            
         
            if isInteger && stepValue == 1.0 && items.count > 0 {
                label.text = items[Int(value)]
            }
            else if showIntegerIfDoubleIsInteger && isInteger {
                label.text = String(Int(value))
            } else {
                label.text = String(Int(value))
            }

            if oldValue != value {
                sendActions(for: .valueChanged)
            }
        }
    }

    @objc @IBInspectable public var minimumValue: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }

    @objc @IBInspectable public var maximumValue: Double = 100 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }

    @objc @IBInspectable public var stepValue: Double = 1

    @objc @IBInspectable public var autorepeat: Bool = true

    @objc @IBInspectable public var showIntegerIfDoubleIsInteger: Bool = true

    @objc @IBInspectable public var leftButtonText: String = "−" {
        didSet {
            leftButton.setTitle(leftButtonText, for: .normal)
        }
    }

    @objc @IBInspectable public var rightButtonText: String = "+" {
        didSet {
            rightButton.setTitle(rightButtonText, for: .normal)
        }
    }

    @objc @IBInspectable public var buttonsTextColor: UIColor = UIColor.white {
        didSet {
            for button in [leftButton, rightButton] {
                button.setTitleColor(buttonsTextColor, for: .normal)
            }
        }
    }

    @objc @IBInspectable public var buttonsBackgroundColor: UIColor = UIColor(red:0.21, green:0.5, blue:0.74, alpha:1) {
        didSet {
            for button in [leftButton, rightButton] {
                button.backgroundColor = buttonsBackgroundColor
            }
            backgroundColor = buttonsBackgroundColor
        }
    }

    @objc public var buttonsFont = UIFont(name: "AvenirNext-Bold", size: 20.0)! {
        didSet {
            for button in [leftButton, rightButton] {
                button.titleLabel?.font = buttonsFont
            }
        }
    }

    @objc @IBInspectable public var labelTextColor: UIColor = UIColor.white {
        didSet {
            label.textColor = labelTextColor
        }
    }

    @objc @IBInspectable public var labelBackgroundColor: UIColor = UIColor(red:0.26, green:0.6, blue:0.87, alpha:1) {
        didSet {
            label.backgroundColor = labelBackgroundColor
        }
    }

    @objc public var labelFont = UIFont(name: "AvenirNext-Bold", size: 25.0)! {
        didSet {
            label.font = labelFont
        }
    }
    @objc @IBInspectable public var labelCornerRadius: CGFloat = 0 {
        didSet {
            label.layer.cornerRadius = labelCornerRadius
        
            }
    }

    @objc @IBInspectable public var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    @objc @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            label.layer.borderWidth = borderWidth
        }
    }
    
    @objc @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            label.layer.borderColor = borderColor.cgColor
        }
    }

   
    @objc @IBInspectable public var labelWidthWeight: CGFloat = 0.5 {
        didSet {
            labelWidthWeight = min(1, max(0, labelWidthWeight))
            setNeedsLayout()
        }
    }

    @objc @IBInspectable public var limitHitAnimationColor: UIColor = UIColor(red:0.26, green:0.6, blue:0.87, alpha:1)

    
    let labelSlideLength: CGFloat = 5

    let labelSlideDuration = TimeInterval(0.1)

    let limitHitAnimationDuration = TimeInterval(0.1)

    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.leftButtonText, for: .normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.addTarget(self, action: #selector(GMStepper.leftButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpInside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpOutside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchCancel)
        return button
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.rightButtonText, for: .normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.addTarget(self, action: #selector(GMStepper.rightButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpInside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchUpOutside)
        button.addTarget(self, action: #selector(GMStepper.buttonTouchUp), for: .touchCancel)
        return button
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if self.showIntegerIfDoubleIsInteger && floor(self.value) == self.value {
            label.text = String(Int(self.value))
        };         label.textColor = self.labelTextColor
        label.backgroundColor = self.labelBackgroundColor
        label.font = self.labelFont
        label.layer.cornerRadius = self.labelCornerRadius
        label.layer.masksToBounds = true
        label.isUserInteractionEnabled = true
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GMStepper.handlePan))
        panRecognizer.maximumNumberOfTouches = 1
        label.addGestureRecognizer(panRecognizer)
        return label
    }()

    var labelOriginalCenter: CGPoint!
    var labelMaximumCenterX: CGFloat!
    var labelMinimumCenterX: CGFloat!

    enum LabelPanState {
        case Stable, HitRightEdge, HitLeftEdge
    }
    var panState = LabelPanState.Stable

    enum StepperState {
        case Stable, ShouldIncrease, ShouldDecrease
    }
    var stepperState = StepperState.Stable {
        didSet {
            if stepperState != .Stable {
                updateValue()
                if autorepeat {
                    scheduleTimer()
                }
            }
        }
    }
    
    
    @objc public var items : [String] = [] {
        didSet {
            let isInteger = floor(value) == value
            
          
            if isInteger && stepValue == 1.0 && items.count > 0 {
                
                var value = Int(self.value)
                
                if value >= items.count {
                    value = items.count - 1
                    self.value = Double(value)
                }
                else {
                    label.text = items[value]
                }
            }
        }
    }

    var timer: Timer?

   
    let timerInterval = TimeInterval(0.05)

   
    var timerFireCount = 0
    var timerFireCountModulo: Int {
        if timerFireCount > 80 {
            return 1 // 0.05 sec * 1 = 0.05 sec
        } else if timerFireCount > 50 {
            return 2 // 0.05 sec * 2 = 0.1 sec
        } else {
            return 10 // 0.05 sec * 10 = 0.5 sec
        }
    }

    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(label)

        backgroundColor = buttonsBackgroundColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        labelOriginalCenter = label.center

        NotificationCenter.default.addObserver(self, selector: #selector(GMStepper.reset), name: UIApplication.willResignActiveNotification, object: nil)
    }

    public override func layoutSubviews() {
        let buttonWidth = bounds.size.width * ((1 - labelWidthWeight) / 2)
        let labelWidth = bounds.size.width * labelWidthWeight

        leftButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: bounds.size.height)
        label.frame = CGRect(x: buttonWidth, y: 0, width: labelWidth, height: bounds.size.height)
        rightButton.frame = CGRect(x: labelWidth + buttonWidth, y: 0, width: buttonWidth, height: bounds.size.height)

        labelMaximumCenterX = label.center.x + labelSlideLength
        labelMinimumCenterX = label.center.x - labelSlideLength
        labelOriginalCenter = label.center
    }

    func updateValue() {
        if stepperState == .ShouldIncrease {
            value += stepValue
        } else if stepperState == .ShouldDecrease {
            value -= stepValue
        }   
    }

    deinit {
        resetTimer()
        NotificationCenter.default.removeObserver(self)
    }

}

extension GMStepper {
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            leftButton.isEnabled = false
            rightButton.isEnabled = false
        case .changed:
            let translation = gesture.translation(in: label)
            gesture.setTranslation(CGPoint.zero, in: label)

            let slidingRight = gesture.velocity(in: label).x > 0
            let slidingLeft = gesture.velocity(in: label).x < 0

            if slidingRight {
                label.center.x = min(labelMaximumCenterX, label.center.x + translation.x)
            } else if slidingLeft {
                label.center.x = max(labelMinimumCenterX, label.center.x + translation.x)
            }

            
            if label.center.x == labelMaximumCenterX {
                
                if panState != .HitRightEdge {
                    stepperState = .ShouldIncrease
                    panState = .HitRightEdge
                }
                
                animateLimitHitIfNeeded()
            } else if label.center.x == labelMinimumCenterX {
                if panState != .HitLeftEdge {
                    stepperState = .ShouldDecrease
                    panState = .HitLeftEdge
                }

                animateLimitHitIfNeeded()
            } else {
                panState = .Stable
                stepperState = .Stable
                resetTimer()

                self.rightButton.backgroundColor = self.buttonsBackgroundColor
                self.leftButton.backgroundColor = self.buttonsBackgroundColor
            }
        case .ended, .cancelled, .failed:
            reset()
        default:
            break
        }
    }

    @objc func reset() {
        panState = .Stable
        stepperState = .Stable
        resetTimer()

        leftButton.isEnabled = true
        rightButton.isEnabled = true
        label.isUserInteractionEnabled = true

        UIView.animate(withDuration: self.labelSlideDuration, animations: {
            self.label.center = self.labelOriginalCenter
            self.rightButton.backgroundColor = self.buttonsBackgroundColor
            self.leftButton.backgroundColor = self.buttonsBackgroundColor
        })
    }
}

extension GMStepper {
    @objc func leftButtonTouchDown(button: UIButton) {
        rightButton.isEnabled = false
        label.isUserInteractionEnabled = false
        resetTimer()

        if value == minimumValue {
            animateLimitHitIfNeeded()
        } else {
            stepperState = .ShouldDecrease
            animateSlideLeft()
        }

    }

    @objc func rightButtonTouchDown(button: UIButton) {
        leftButton.isEnabled = false
        label.isUserInteractionEnabled = false
        resetTimer()

        if value == maximumValue {
            animateLimitHitIfNeeded()
        } else {
            stepperState = .ShouldIncrease
            animateSlideRight()
        }
    }

    @objc func buttonTouchUp(button: UIButton) {
        reset()
    }
}

extension GMStepper {

    func animateSlideLeft() {
        UIView.animate(withDuration: labelSlideDuration) {
            self.label.center.x -= self.labelSlideLength
        }
    }

    func animateSlideRight() {
        UIView.animate(withDuration: labelSlideDuration) {
            self.label.center.x += self.labelSlideLength
        }
    }

    func animateToOriginalPosition() {
        if self.label.center != self.labelOriginalCenter {
            UIView.animate(withDuration: labelSlideDuration) {
                self.label.center = self.labelOriginalCenter
            }
        }
    }

    func animateLimitHitIfNeeded() {
        if value == minimumValue {
            animateLimitHitForButton(button: leftButton)
        } else if value == maximumValue {
            animateLimitHitForButton(button: rightButton)
        }
    }

    func animateLimitHitForButton(button: UIButton){
        UIView.animate(withDuration: limitHitAnimationDuration) {
            button.backgroundColor = self.limitHitAnimationColor
        }
    }
}

extension GMStepper {
    @objc func handleTimerFire(timer: Timer) {
        timerFireCount += 1

        if timerFireCount % timerFireCountModulo == 0 {
            updateValue()
        }
    }

    func scheduleTimer() {
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(GMStepper.handleTimerFire), userInfo: nil, repeats: true)
    }

    func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
            timerFireCount = 0
        }
    }


}
