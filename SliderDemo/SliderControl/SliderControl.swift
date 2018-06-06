//
//  SliderControl.swift
//  SliderDemo
//
//  Created by Evgeniy Mikholap on 6/5/18.
//  Copyright © 2018 Evgeniy Mikholap. All rights reserved.
//

import UIKit


/// Slider Control constants
private struct SliderConstants {

    static let minHeight: CGFloat              = 44
    static let minWidth: CGFloat               = 100
    static let maxHeight: CGFloat              = 100
    static let numberOfLabels                  = 2
    static let defaultSliderViewInset: CGFloat = 4
    static let defaultSliderLabelFont          = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let defaultLabelFont                = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let animationDuration               = 0.3
    static let sliderViewShadowOpacity: Float  = 0.2
    static let sliderViewShadowRadius: CGFloat = 2
    static let sliderViewShadowOffset          = CGSize(width: 0, height: 0)

}


/// Slider Control color
private struct SliderDefaultColors {

    static let leftSideBackgroundColor     = #colorLiteral(red: 0, green: 0.7307787538, blue: 0.6325929761, alpha: 1)
    static let rightSideBackgroundColor    = #colorLiteral(red: 0.5369121432, green: 0.5369251966, blue: 0.5369181633, alpha: 1)
    static let sliderFirstBackgroundColor  = #colorLiteral(red: 0.9921568627, green: 0.9882352941, blue: 0.9803921569, alpha: 1)
    static let sliderSecondBackgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8705882353, alpha: 1)
    static let sliderTextColor             = #colorLiteral(red: 0.7176470588, green: 0.7137254902, blue: 0.7333333333, alpha: 1)
    static let leftLabelTextColor          = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let rightLabelTextColor         = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)

}


/// Slider Control states
public enum SliderState {
    case normal
    case error
    case disabled
}


/// Public interface for the Slider Control
public protocol SliderControlProtocol {
    /// Left label title
    var leftSideTitle: String { get set }

    /// Right label title
    var rightSideTitle: String { get set }

    /// Slider label title
    var sliderTitle: String { get set }

    /// Selected Index: 0 — left slider position, 1 — right slider position. Default: 0
    var selectedIndex: Int { get set }

    /// Slider Control state. Default: .normal
    var controlState: SliderState { get set }

    /// Slider View inset. Default: SliderConstants.defaultSliderViewInset
    var sliderLabelInset: CGFloat { get set }

    /// Enable/Disable flag
    var isEnabled: Bool { get set }

    /// Slider label font
    var sliderTitleFont: UIFont { get set }

    /// Left label font
    var leftLabelTitleFont: UIFont { get set }

    /// Right label font
    var rightLabelTitleFont: UIFont { get set }

    /// Left side view background color. IBInspectable. Default: SliderColors.leftSideBackgroundColor
    var leftSideBackgroundColor: UIColor { get set }

    /// Right side view background color. IBInspectable. Default: SliderColors.rightSideBackgroundColor
    var rightSideBackgroundColor: UIColor { get set }

    /// Top color of Slider view gradient. IBInspectable. Default: SliderColors.sliderFirstBackgroundColor
    var sliderFirstBackgroundColor: UIColor { get set }

    /// Bottom color of Slider view gradient. IBInspectable. Default: SliderColors.sliderSecondBackgroundColor
    var sliderSecondBackgroundColor: UIColor { get set }

    /// Slider label text color. Default: SliderColors.sliderTextColor
    var sliderTextColor: UIColor { get set }

    /// Left label text color. Default: SliderColors.leftLabelTextColor
    var leftLabelTextColor: UIColor { get set }

    /// Right label text color. Default: SliderColors.rightLabelTextColor
    var rightLabelTextColor: UIColor { get set }

    /// Shows system activity indicator
    func showActivityIndicator()

    /// Hides system activity indicator
    func hideActivityIndicator()

    /**
        Initializes a new Slider Control

        - Parameter sliderTitle: slider label title

        - Returns: A new Slider Control
     */
    init(sliderTitle: String, leftSideTitle: String, rightSideTitle: String)
}


/// Slider Control class
@IBDesignable public class SliderControl: UIControl, SliderControlProtocol {

    // MARK: Public interface. SliderControlProtocol

    public var leftSideTitle: String {
        get {
            return leftLabel.text!
        }
        set {
            leftLabel.text = newValue
            leftLabel.textAlignment = .left
            leftLabel.font = leftLabelTitleFont
            leftLabel.textColor = leftLabelTextColor
            leftLabel.minimumScaleFactor = 0.5
            leftLabel.adjustsFontSizeToFitWidth = true
            leftLabel.numberOfLines = 0
        }
    }
    public var rightSideTitle: String {
        get {
            return rightLabel.text!
        }
        set {
            rightLabel.text = newValue
            rightLabel.textAlignment = .right
            rightLabel.font = rightLabelTitleFont
            rightLabel.textColor = rightLabelTextColor
            rightLabel.minimumScaleFactor = 0.5
            rightLabel.adjustsFontSizeToFitWidth = true
            rightLabel.numberOfLines = 0
        }
    }
    public var sliderTitle: String {
        get {
            return sliderViewLabel.text!
        }
        set {
            sliderViewLabel.text = newValue
            sliderViewLabel.textAlignment = .center
            sliderViewLabel.font = sliderTitleFont
            sliderViewLabel.textColor = sliderTextColor
            sliderViewLabel.minimumScaleFactor = 0.5
            sliderViewLabel.adjustsFontSizeToFitWidth = true
            sliderViewLabel.numberOfLines = 0
        }
    }
    public var selectedIndex = 0
    public var controlState: SliderState = .normal
    public var sliderLabelInset: CGFloat = SliderConstants.defaultSliderViewInset {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    public override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                controlState = .disabled
                alpha = alpha / 2
            } else {
                controlState = .normal
                alpha = 1
            }
        }
    }
    public var sliderTitleFont = SliderConstants.defaultSliderLabelFont {
        didSet {
            sliderViewLabel.font = sliderTitleFont
        }
    }
    public var leftLabelTitleFont = SliderConstants.defaultLabelFont {
        didSet {
            leftLabel.font = leftLabelTitleFont
        }
    }
    public var rightLabelTitleFont = SliderConstants.defaultLabelFont {
        didSet {
            rightLabel.font = rightLabelTitleFont
        }
    }
    @IBInspectable public var leftSideBackgroundColor: UIColor = SliderDefaultColors.leftSideBackgroundColor {
        didSet {
            leftBackgroundView.backgroundColor = leftSideBackgroundColor
        }
    }
    @IBInspectable public var rightSideBackgroundColor: UIColor = SliderDefaultColors.rightSideBackgroundColor {
        didSet {
            rightBackgroundView.backgroundColor = rightSideBackgroundColor
        }
    }
    @IBInspectable public var sliderFirstBackgroundColor: UIColor = SliderDefaultColors.sliderFirstBackgroundColor {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable public var sliderSecondBackgroundColor: UIColor = SliderDefaultColors.sliderSecondBackgroundColor {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable public var sliderTextColor: UIColor = SliderDefaultColors.sliderTextColor {
        didSet {
            sliderViewLabel.textColor = sliderTextColor
        }
    }
    @IBInspectable public var leftLabelTextColor: UIColor = SliderDefaultColors.leftLabelTextColor {
        didSet {
            leftLabel.textColor = leftLabelTextColor
        }
    }
    @IBInspectable public var rightLabelTextColor: UIColor = SliderDefaultColors.rightLabelTextColor {
        didSet {
            rightLabel.textColor = rightLabelTextColor
        }
    }

    public func showActivityIndicator() {
        activityIndicator.startAnimating()
        sliderViewLabel.isHidden = true
    }

    public func hideActivityIndicator() {
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
    fileprivate let sliderViewShadowLayer = CAShapeLayer()
    fileprivate let sliderViewGradientLayer = CAGradientLayer()
    fileprivate var initialSliderLabelFrame: CGRect?


    // MARK: Initializers

    required public init(sliderTitle: String, leftSideTitle: String, rightSideTitle: String) {
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
            leftBackgroundView.alpha = frame.origin.x / bounds.width
            rightBackgroundView.alpha = 1 - frame.origin.x / bounds.width
            break
        case .ended, .failed, .cancelled:
            let index = Int(sliderView.center.x / (bounds.width / CGFloat(SliderConstants.numberOfLabels)))
            setSelectedIndex(index, animated: true)
            break

        case .possible:
            break
        }
    }

    open func setSelectedIndex(_ selectedIndex: Int, animated: Bool, animationDelay: TimeInterval = 0) {
        let catchHalfSwitch = self.selectedIndex == selectedIndex

        self.selectedIndex = selectedIndex

        if animated {
            if !catchHalfSwitch && controlState != .error {
                self.sendActions(for: .valueChanged)
            }

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SliderConstants.animationDuration, delay: animationDelay, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                self.layoutSubviews()
            }, completion: { _ in
                if self.controlState == .error {
                    self.sendActions(for: .valueChanged)
                }
            })
        } else {
            layoutSubviews()
            sendActions(for: .valueChanged)
        }
    }


    // MARK: - Layout

    override open func layoutSubviews() {
        super.layoutSubviews()
         setNeedsDisplay()

        let sliderSideSize = bounds.height - sliderLabelInset * 2
        sliderView.frame = CGRect(x: fabs(CGFloat(selectedIndex) * (bounds.width - sliderSideSize) - sliderLabelInset), y: sliderLabelInset, width:  sliderSideSize, height: sliderSideSize)

        sliderViewLabel.frame = sliderView.bounds
        sliderViewLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let halfHeight = bounds.height / 2
        leftLabel.frame = CGRect(x: halfHeight, y: 0, width: bounds.width - halfHeight - sliderSideSize - sliderLabelInset * 2, height: bounds.height)
        rightLabel.frame = CGRect(x: bounds.height, y: 0, width: bounds.width - halfHeight - bounds.height, height: bounds.height)
        leftBackgroundView.frame = bounds
        rightBackgroundView.frame = bounds

        leftBackgroundView.alpha = selectedIndex == 0 ? 0 : 1
        rightBackgroundView.alpha = selectedIndex == 1 ? 0 : 1

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
