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

    static let minHeight: CGFloat = 44
    static let minWidth: CGFloat = 100
    static let maxHeight: CGFloat = 100
    static let numberOfLabels = 2
    static let animationDuration = 0.3
    static let sliderViewShadowOpacity: Float = 0.2
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
            leftLabel.textAlignment = .left
            leftLabel.font = leftLabelTitleFont
            leftLabel.textColor = leftLabelTextColor
            leftLabel.numberOfLines = 0
        }
    }
    var rightSideTitle: String {
        get {
            return rightLabel.text!
        }
        set {
            rightLabel.text = newValue
            rightLabel.textAlignment = .right
            rightLabel.font = rightLabelTitleFont
            rightLabel.textColor = rightLabelTextColor
            rightLabel.numberOfLines = 0
        }
    }
    var sliderTitle: String {
        get {
            return sliderViewLabel.text!
        }
        set {
            sliderViewLabel.text = newValue
            sliderViewLabel.textAlignment = .center
            sliderViewLabel.font = sliderTitleFont
            sliderViewLabel.textColor = sliderTextColor
            sliderViewLabel.numberOfLines = 0
        }
    }

    var isOn = true
    fileprivate(set) open var selectedIndex = 0

    var sliderLabelInset: CGFloat = 4 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }

    var sliderTitleFont = UIFont.systemFont(ofSize: 15, weight: .medium) {
        didSet {
            sliderViewLabel.font = sliderTitleFont
        }
    }
    var leftLabelTitleFont = UIFont.systemFont(ofSize: 16, weight: .medium) {
        didSet {
            leftLabel.font = leftLabelTitleFont
        }
    }
    var rightLabelTitleFont = UIFont.systemFont(ofSize: 16, weight: .medium) {
        didSet {
            rightLabel.font = rightLabelTitleFont
        }
    }

    @IBInspectable
    var leftSideBackgroundColor: UIColor = #colorLiteral(red: 0, green: 0.7307787538, blue: 0.6325929761, alpha: 1) {
        didSet {
            leftBackgroundView.backgroundColor = leftSideBackgroundColor
        }
    }
    @IBInspectable
    var rightSideBackgroundColor: UIColor = #colorLiteral(red: 0.5369121432, green: 0.5369251966, blue: 0.5369181633, alpha: 1) {
        didSet {
            rightBackgroundView.backgroundColor = rightSideBackgroundColor
        }
    }
    @IBInspectable
    var sliderFirstBackgroundColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.9882352941, blue: 0.9803921569, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var sliderSecondBackgroundColor: UIColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8705882353, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var sliderTextColor: UIColor = #colorLiteral(red: 0.7176470588, green: 0.7137254902, blue: 0.7333333333, alpha: 1) {
        didSet {
            sliderViewLabel.textColor = sliderTextColor
        }
    }

    @IBInspectable
    var leftLabelTextColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            leftLabel.textColor = leftLabelTextColor
        }
    }

    @IBInspectable
    var rightLabelTextColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1) {
        didSet {
            rightLabel.textColor = rightLabelTextColor
        }
    }

    func showActivityIndicator() {
        activityIndicator.startAnimating()
        sliderViewLabel.isHidden = true
    }

    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        sliderViewLabel.isHidden = false
    }


    // MARK: Private variables

    fileprivate var leftBackgroundView = UIView()
    fileprivate var rightBackgroundView = UIView()
    fileprivate var leftLabel = UILabel()
    fileprivate var rightLabel = UILabel()
    fileprivate var sliderView = UIView()
    fileprivate var sliderViewLabel = UILabel()
    fileprivate var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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
        sizeToFit()

        addSubview(leftBackgroundView)
        addSubview(rightBackgroundView)
        leftBackgroundView.addSubview(leftLabel)
        rightBackgroundView.addSubview(rightLabel)
        sliderView.addSubview(sliderViewLabel)
        sliderView.addSubview(activityIndicator)
        addSubview(sliderView)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGesture)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }

    fileprivate let sliderViewShadowLayer = CAShapeLayer()
    fileprivate let sliderViewGradientLayer = CAGradientLayer()

    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        leftBackgroundView.backgroundColor = leftSideBackgroundColor
        rightBackgroundView.backgroundColor = rightSideBackgroundColor

        [sliderViewShadowLayer, sliderViewGradientLayer].forEach { $0.removeFromSuperlayer() }

        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true

        sliderViewShadowLayer.path = UIBezierPath(roundedRect: sliderView.bounds, cornerRadius: sliderView.bounds.height / 2).cgPath
        sliderViewShadowLayer.fillColor = UIColor.clear.cgColor
        sliderViewShadowLayer.shadowColor = UIColor.black.cgColor
        sliderViewShadowLayer.shadowPath = sliderViewShadowLayer.path
        sliderViewShadowLayer.shadowOffset = SliderConstants.sliderViewShadowOffset
        sliderViewShadowLayer.shadowOpacity = SliderConstants.sliderViewShadowOpacity
        sliderViewShadowLayer.shadowRadius = SliderConstants.sliderViewShadowRadius
        sliderView.layer.insertSublayer(sliderViewShadowLayer, below: sliderViewLabel.layer)

        sliderViewGradientLayer.colors = [sliderFirstBackgroundColor, sliderSecondBackgroundColor].map { $0.cgColor }
        sliderViewGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        sliderViewGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        sliderViewGradientLayer.frame = sliderView.bounds
        sliderViewGradientLayer.cornerRadius = sliderView.bounds.height / 2
        sliderViewGradientLayer.masksToBounds = true
        sliderView.layer.insertSublayer(sliderViewGradientLayer, below: sliderViewLabel.layer)
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

        let sliderSideSize = bounds.height - sliderLabelInset * 2
        sliderView.frame = CGRect(x: fabs(CGFloat(selectedIndex) * (bounds.width - sliderSideSize) - sliderLabelInset), y: sliderLabelInset, width:  sliderSideSize, height: sliderSideSize)

        sliderViewLabel.frame = sliderView.bounds
        sliderViewLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let halfHeight = bounds.height / 2
        leftLabel.frame = CGRect(x: halfHeight, y: 0, width: bounds.width - halfHeight - sliderSideSize - sliderLabelInset * 2, height: bounds.height)
        rightLabel.frame = CGRect(x: bounds.height, y: 0, width: bounds.width - halfHeight - bounds.height, height: bounds.height)
        leftBackgroundView.frame = bounds
        rightBackgroundView.frame = bounds

        leftBackgroundView.isHidden = selectedIndex == 0
        rightBackgroundView.isHidden = selectedIndex == 1

        activityIndicator.center = CGPoint(x: sliderSideSize / 2, y: sliderSideSize / 2)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var fittingSize = size
        if size.height < SliderConstants.minHeight {
            fittingSize.height = SliderConstants.minHeight
        } else if size.height > SliderConstants.maxHeight {
            fittingSize.height = SliderConstants.maxHeight
        }

        if size.width < SliderConstants.minWidth {
            fittingSize.width = SliderConstants.minWidth
        }

        return fittingSize
    }

}


// MARK: - UIGestureRecognizerDelegate

extension SliderControl: UIGestureRecognizerDelegate {

    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            return sliderView.frame.contains(gestureRecognizer.location(in: self))
        }

        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

}
