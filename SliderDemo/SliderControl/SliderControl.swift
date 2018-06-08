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
    static let animationDelay: TimeInterval    = 0
    static let sliderViewShadowOpacity: Float  = 0.2
    static let sliderViewShadowRadius: CGFloat = 2
    static let sliderViewShadowOffset          = CGSize(width: 0, height: 0)
    static let fontMinimumScaleFactor: CGFloat = 0.5

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


/// Slider View position
public enum SliderPosition: Int {
    case left = 0
    case right
}


/// Public interface for the Slider Control
public protocol SliderControlProtocol {
    /// Left label title
    var leftSideTitle: String? { get }

    /// Right label title
    var rightSideTitle: String? { get }

    /// Slider label title
    var sliderTitle: String? { get }

    /// Slider View position. Read-only. Default: `.left`
    var position: SliderPosition { get }

    /// Slider Control state. Default: `.normal`
    var controlState: SliderState { get set }

    /// Slider View inset. Default: `SliderConstants.defaultSliderViewInset`
    var sliderLabelInset: CGFloat { get set }

    /// Enable/Disable flag
    var isEnabled: Bool { get set }

    /// Slider label font
    var sliderTitleFont: UIFont { get set }

    /// Left label font
    var leftLabelTitleFont: UIFont { get set }

    /// Right label font
    var rightLabelTitleFont: UIFont { get set }

    /// Left side view background color. IBInspectable. Default: `SliderColors.leftSideBackgroundColor`
    var leftSideBackgroundColor: UIColor { get set }

    /// Right side view background color. IBInspectable. Default: `SliderColors.rightSideBackgroundColor`
    var rightSideBackgroundColor: UIColor { get set }

    /// Top color of Slider view gradient. IBInspectable. Default: `SliderColors.sliderFirstBackgroundColor`
    var sliderFirstBackgroundColor: UIColor { get set }

    /// Bottom color of Slider view gradient. IBInspectable. Default: `SliderColors.sliderSecondBackgroundColor`
    var sliderSecondBackgroundColor: UIColor { get set }

    /// Slider label text color. Default: `SliderColors.sliderTextColor`
    var sliderTextColor: UIColor { get set }

    /// Left label text color. Default: `SliderColors.leftLabelTextColor`
    var leftLabelTextColor: UIColor { get set }

    /// Right label text color. Default: `SliderColors.rightLabelTextColor`
    var rightLabelTextColor: UIColor { get set }

    /// Shows system activity indicator
    func showActivityIndicator()

    /// Hides system activity indicator
    func hideActivityIndicator()

    /**
     Changes Slider View position

     - Parameter position: `.right` or `.left` Slider View position
     - Parameter animated: if `true`, Slider view is being updated using an animation
     */
    func change(position: SliderPosition, animated: Bool)
}


/// Slider Control class
@IBDesignable public class SliderControl: UIControl, SliderControlProtocol {

    // MARK: Public interface. SliderControlProtocol

    public var leftSideTitle: String? {
        didSet {
            leftLabel.text = leftSideTitle
        }
    }
    public var rightSideTitle: String? {
        didSet {
            rightLabel.text = rightSideTitle
        }
    }
    public var sliderTitle: String? {
        didSet {
            sliderViewLabel.text = sliderTitle
        }
    }
    private(set) public var position: SliderPosition = .left
    public var controlState: SliderState = .normal
    public var sliderLabelInset: CGFloat = SliderConstants.defaultSliderViewInset {
        didSet {
            setNeedsLayout()
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
            sliderViewGradientLayer.colors = [sliderFirstBackgroundColor, sliderSecondBackgroundColor].map { $0.cgColor }
        }
    }
    @IBInspectable public var sliderSecondBackgroundColor: UIColor = SliderDefaultColors.sliderSecondBackgroundColor {
        didSet {
            sliderViewGradientLayer.colors = [sliderFirstBackgroundColor, sliderSecondBackgroundColor].map { $0.cgColor }
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

    public func change(position: SliderPosition, animated: Bool) {
        let catchHalfSwitch = self.position == position
        self.position = position

        if animated {
            if !catchHalfSwitch && controlState != .error {
                self.sendActions(for: .valueChanged)
            }

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SliderConstants.animationDuration,
                                                           delay: SliderConstants.animationDelay,
                                                           options: [.beginFromCurrentState, .curveEaseOut],
                                                           animations: {
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


    // MARK: Private variables

    fileprivate lazy var leftBackgroundView: UIView = {
        let leftBackgroundView = UIView()
        leftBackgroundView.backgroundColor = leftSideBackgroundColor
        return leftBackgroundView
    }()
    fileprivate lazy var rightBackgroundView: UIView = {
        let rightBackgroundView = UIView()
        rightBackgroundView.backgroundColor = rightSideBackgroundColor
        return rightBackgroundView
    }()
    fileprivate lazy var leftLabel: UILabel = createEmptyLabel(textAlignment: .left, font: leftLabelTitleFont, textColor: leftLabelTextColor)
    fileprivate lazy var rightLabel: UILabel = createEmptyLabel(textAlignment: .right, font: rightLabelTitleFont, textColor: rightLabelTextColor)
    fileprivate lazy var sliderViewLabel: UILabel = createEmptyLabel(textAlignment: .center, font: sliderTitleFont, textColor: sliderTextColor)
    fileprivate let sliderView = UIView()
    fileprivate let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
    fileprivate lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
    fileprivate let sliderViewShadowLayer = CAShapeLayer()
    fileprivate let sliderViewGradientLayer = CAGradientLayer()
    fileprivate var initialSliderViewFrame: CGRect?


    // MARK: Initializers

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public convenience init(position: SliderPosition) {
        self.init(frame: .zero)

        self.position = position

        commonInit()
    }

    fileprivate func commonInit() {
        sizeToFit()
//        translatesAutoresizingMaskIntoConstraints = false

        addSubview(leftBackgroundView)
        addSubview(rightBackgroundView)
        leftBackgroundView.addSubview(leftLabel)
        rightBackgroundView.addSubview(rightLabel)

        sliderView.addSubview(sliderViewLabel)
        sliderView.addSubview(activityIndicator)
        addSubview(sliderView)

        addGestureRecognizer(tapGesture)
        addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }


    // MARK: Gestures

    @objc func tap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let index = Int(location.x / (bounds.width / CGFloat(SliderConstants.numberOfLabels)))
        change(position: index == 0 ? .left : .right , animated: true)
    }

    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .possible, .began:
            initialSliderViewFrame = sliderView.frame
            break
        case .changed:
            guard var frame = initialSliderViewFrame else { return }
            frame.origin.x += gesture.translation(in: self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - sliderLabelInset - frame.width), sliderLabelInset)
            sliderView.frame = frame
            leftBackgroundView.alpha = frame.maxX / bounds.width
            rightBackgroundView.alpha = 1 - frame.maxX / bounds.width
            break
        case .ended, .failed, .cancelled:
            guard initialSliderViewFrame != nil else { return }
            let index = Int(sliderView.center.x / (bounds.width / CGFloat(SliderConstants.numberOfLabels)))
            change(position: index == 0 ? .left : .right , animated: true)
            initialSliderViewFrame = nil
            break
        }
    }


    // MARK: Layout

//    override public class var requiresConstraintBasedLayout: Bool {
//        return true
//    }

//    public override var intrinsicContentSize: CGSize {
//        return CGSize(width: SliderConstants.minWidth, height: SliderConstants.minHeight)
//    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        let sliderSideSize = bounds.height - sliderLabelInset * 2
        sliderView.frame = CGRect(x: fabs(CGFloat(position.rawValue) * (bounds.width - sliderSideSize) - sliderLabelInset), y: sliderLabelInset, width:  sliderSideSize, height: sliderSideSize)

        sliderViewLabel.frame = sliderView.bounds
        sliderViewLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let halfHeight = bounds.height / 2
        leftLabel.frame = CGRect(x: halfHeight, y: 0, width: bounds.width - halfHeight - sliderSideSize - sliderLabelInset * 2, height: bounds.height)
        rightLabel.frame = CGRect(x: bounds.height, y: 0, width: bounds.width - halfHeight - bounds.height, height: bounds.height)
        leftBackgroundView.frame = bounds
        rightBackgroundView.frame = bounds

        leftBackgroundView.alpha = CGFloat(position.rawValue)
        rightBackgroundView.alpha = CGFloat(1 - position.rawValue)

        activityIndicator.center = CGPoint(x: sliderSideSize / 2, y: sliderSideSize / 2)

        createSliderViewLayers()
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
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

    override public class var layerClass : AnyClass {
        return SliderMainLayer.self
    }

    fileprivate func createEmptyLabel(textAlignment: NSTextAlignment, font: UIFont, textColor: UIColor) -> UILabel {
        let emptyLabel = UILabel()
        emptyLabel.textAlignment = textAlignment
        emptyLabel.font = font
        emptyLabel.textColor = textColor
        emptyLabel.minimumScaleFactor = SliderConstants.fontMinimumScaleFactor
        emptyLabel.adjustsFontSizeToFitWidth = true
        emptyLabel.numberOfLines = 0
        return emptyLabel
    }

    fileprivate func createSliderViewLayers() {
        [sliderViewShadowLayer, sliderViewGradientLayer].forEach { $0.removeFromSuperlayer() }

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

}


// MARK: - Custom main layer for Slider Control

fileprivate class SliderMainLayer: CALayer {

    override var bounds: CGRect {
        didSet {
            cornerRadius = bounds.height / 2
            masksToBounds = true
        }
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
