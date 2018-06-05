//
//  SliderControl.swift
//  SliderDemo
//
//  Created by Evgeniy Mikholap on 6/5/18.
//  Copyright © 2018 Evgeniy Mikholap. All rights reserved.
//

import Foundation
import UIKit


private struct SliderConstants {

    static let minHeight = 44.0
    static let minWidth = 100.0
    static let numberOfLabels = 2
    static let animationDuration = 0.3
    static let sliderViewShadowOpacity: Float = 0.1
    static let sliderViewShadowRadius: CGFloat = 2
    static let sliderViewShadowOffset = CGSize(width: 0, height: 0)

}


@IBDesignable
open class SliderControl: UIControl {

    // MARK: Public variables

    var leftSideTitle: String {
        get {
            return leftLabel.text!
        }
        set {
            leftLabel.text = newValue
        }
    }
    var rightSideTitle: String {
        get {
            return rightLabel.text!
        }
        set {
            rightLabel.text = newValue
        }
    }
    var sliderTitle: String?
//    {
//        get {
//            return sliderLabel.text!
//        }
//        set {
//            sliderLabel.text = newValue
//        }
//    }
    var isOn = true
    fileprivate(set) open var selectedIndex = 0 {
        didSet {
            backgroundColor = selectedIndex == 0 ? rightSideBackgroundColor : leftSideBackgroundColor
        }
    }

    var sliderLabelInset: CGFloat = 4 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var leftSideBackgroundColor: UIColor! {
        didSet {
            if selectedIndex == 1 {
                backgroundColor = leftSideBackgroundColor
            }
        }
    }
    @IBInspectable
    var rightSideBackgroundColor: UIColor! {
        didSet {
            if selectedIndex == 0 {
                backgroundColor = rightSideBackgroundColor
            }
        }
    }
    @IBInspectable
    var sliderFirstBackgroundColor: UIColor!

    @IBInspectable
    var sliderSecondBackgroundColor: UIColor!




    // MARK: Private variables

    fileprivate var titleLabelsStackView = UIStackView()
    fileprivate var leftLabel = UILabel()
    fileprivate var rightLabel = UILabel()
    fileprivate var sliderView = UIView()

    fileprivate var tapGesture: UITapGestureRecognizer!
    fileprivate var panGesture: UIPanGestureRecognizer!

    // MARK: Initializers

    public init(sliderTitle: String, leftSideTitle: String, rightSideTitle: String) {
        super.init(frame: CGRect.zero)

        self.sliderTitle = sliderTitle
        self.leftSideTitle = leftSideTitle
        self.rightSideTitle = rightSideTitle

        commonInit()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        titleLabelsStackView.axis = .horizontal
        titleLabelsStackView.addArrangedSubview(leftLabel)
        titleLabelsStackView.addArrangedSubview(rightLabel)

        addSubview(titleLabelsStackView)
        addSubview(sliderView)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGesture)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true

        let sliderViewShadowLayer = CAShapeLayer()
        sliderViewShadowLayer.path = UIBezierPath(roundedRect: sliderView.bounds, cornerRadius: sliderView.bounds.height / 2).cgPath
        sliderViewShadowLayer.fillColor = UIColor.clear.cgColor
        sliderViewShadowLayer.shadowColor = UIColor.black.cgColor
        sliderViewShadowLayer.shadowPath = sliderViewShadowLayer.path
        sliderViewShadowLayer.shadowOffset = SliderConstants.sliderViewShadowOffset
        sliderViewShadowLayer.shadowOpacity = SliderConstants.sliderViewShadowOpacity
        sliderViewShadowLayer.shadowRadius = SliderConstants.sliderViewShadowRadius
        sliderView.layer.addSublayer(sliderViewShadowLayer)

//        let sliderViewLayer = CALayer()
//        sliderViewLayer.frame = sliderView.bounds
//        sliderViewLayer.cornerRadius = sliderView.bounds.height / 2
//        sliderViewLayer.masksToBounds = true
//        sliderViewLayer.backgroundColor = sliderBackgroundColor.cgColor
//        sliderView.layer.addSublayer(sliderViewLayer)

        let sliderViewGradientLayer = CAGradientLayer()
        sliderViewGradientLayer.colors = [sliderFirstBackgroundColor, sliderSecondBackgroundColor].map { $0.cgColor }
        sliderViewGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        sliderViewGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        sliderViewGradientLayer.frame = sliderView.bounds
        sliderViewGradientLayer.cornerRadius = sliderView.bounds.height / 2
        sliderViewGradientLayer.masksToBounds = true
        sliderView.layer.addSublayer(sliderViewGradientLayer)
    }

    // MARK: Gestures

    @objc func tap(_ gesture: UITapGestureRecognizer!) {
        let location = gesture.location(in: self)
        let index = Int(location.x / (bounds.width / CGFloat(SliderConstants.numberOfLabels)))
        setSelectedIndex(index, animated: true)
    }

    var initialSliderLabelFrame: CGRect?
    @objc func pan(_ gesture: UIPanGestureRecognizer!) {
        switch gesture.state {
        case .began:
            initialSliderLabelFrame = sliderView.frame
            break
        case .changed:
            var frame = initialSliderLabelFrame!
            frame.origin.x += gesture.translation(in: self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - sliderLabelInset - frame.width), sliderLabelInset)
            sliderView.frame = frame
            break
        case .ended, .failed, .cancelled:
            let index = Int(sliderView.center.x / (bounds.width / CGFloat(SliderConstants.numberOfLabels)))
            setSelectedIndex(index, animated: true)
            break

        case .possible:
            break
        }
    }

    open func setSelectedIndex(_ selectedIndex: Int, animated: Bool) {
        // Reset switch on half pan gestures
        var catchHalfSwitch = false
        if self.selectedIndex == selectedIndex {
            catchHalfSwitch = true
        }

        self.selectedIndex = selectedIndex
        if animated {
            if (!catchHalfSwitch) {
                self.sendActions(for: .valueChanged)
            }

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SliderConstants.animationDuration, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                self.layoutSubviews()
            }, completion: nil)
        } else {
            layoutSubviews()
            sendActions(for: .valueChanged)
        }
    }

    // MARK: - Layout

    override open func layoutSubviews() {
        super.layoutSubviews()

        titleLabelsStackView.frame = bounds
        titleLabelsStackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        titleLabelsStackView.distribution = .fillEqually
        titleLabelsStackView.spacing = 10

        let sliderSideSize = bounds.height - sliderLabelInset * 2
        sliderView.frame = CGRect(x: fabs(CGFloat(selectedIndex) * (bounds.width - sliderSideSize) - sliderLabelInset), y: sliderLabelInset, width:  sliderSideSize, height: sliderSideSize)

        rightLabel.alpha = selectedIndex == 1 ? 0 : 1
        leftLabel.alpha = selectedIndex == 0 ? 0 : 1
    }

}


// MARK: - UIGestureRecognizerDelegate

extension SliderControl: UIGestureRecognizerDelegate {

    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
