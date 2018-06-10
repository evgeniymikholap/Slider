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
    static let numberOfLabels: CGFloat         = 2
    static let defaultSliderViewInset: CGFloat = 4
    static let defaultSliderLabelFont          = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let defaultLabelFont                = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let fontMetrics                     = UIFontMetrics(forTextStyle: .title2)
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
    /// Toggle View
    var toggleView: UIView { get set }

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

    public lazy var toggleView: UIView = {
        let view = SliderToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
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

        let toggleInset = bounds.width - self.sliderLabelInset - toggleView.bounds.width
        self.toggleViewLeadingLayoutConstraint.constant = position == .left ? self.sliderLabelInset : toggleInset
        self.toggleViewTrailingLayoutConstraint.constant = position == .right ? -self.sliderLabelInset : -toggleInset

        if animated {
            if !catchHalfSwitch && controlState != .error {
                self.sendActions(for: .valueChanged)
            }

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SliderConstants.animationDuration,
                                                           delay: SliderConstants.animationDelay,
                                                           options: [.beginFromCurrentState, .curveEaseOut],
                                                           animations: {
                self.leftBackgroundView.alpha = CGFloat(position.rawValue)
                self.rightBackgroundView.alpha = CGFloat(1 - position.rawValue)
                self.layoutIfNeeded()
            }, completion: { _ in
                if self.controlState == .error {
                    self.sendActions(for: .valueChanged)
                }

                self.toggleViewTrailingLayoutConstraint.isActive = position == .right
                self.toggleViewLeadingLayoutConstraint.isActive = position == .left
            })
        } else {
            layoutIfNeeded()
            sendActions(for: .valueChanged)
        }
    }


    // MARK: Private variables

    fileprivate lazy var leftBackgroundView: UIView = {
        let leftBackgroundView = UIView()
        leftBackgroundView.backgroundColor = leftSideBackgroundColor
        leftBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return leftBackgroundView
    }()
    fileprivate lazy var rightBackgroundView: UIView = {
        let rightBackgroundView = UIView()
        rightBackgroundView.backgroundColor = rightSideBackgroundColor
        rightBackgroundView.translatesAutoresizingMaskIntoConstraints = false
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
    private var initialToggleViewConstant: CGFloat?
    private lazy var leftLabelLeadingLayoutConstraint: NSLayoutConstraint = leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
    private lazy var leftLabelTrailingLayoutConstraint: NSLayoutConstraint = leftLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    private lazy var rightLabelLeadingLayoutConstraint: NSLayoutConstraint = rightLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
    private lazy var rightLabelTrailingLayoutConstraint: NSLayoutConstraint = rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    private lazy var toggleViewLeadingLayoutConstraint: NSLayoutConstraint = toggleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sliderLabelInset)
    private lazy var toggleViewTrailingLayoutConstraint: NSLayoutConstraint = toggleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sliderLabelInset)
    private lazy var toggleViewWidthLayoutConstraint: NSLayoutConstraint = toggleView.widthAnchor.constraint(equalTo: toggleView.heightAnchor, multiplier: 1)


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
        addSubview(leftBackgroundView)
        addSubview(rightBackgroundView)

        leftBackgroundView.addSubview(leftLabel)
        rightBackgroundView.addSubview(rightLabel)

        addSubview(toggleView)

        addGestureRecognizer(tapGesture)
        addGestureRecognizer(panGesture)
        panGesture.delegate = self

        setupConstraints()
    }

    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [leftBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                        leftBackgroundView.topAnchor.constraint(equalTo: topAnchor),
                                        leftBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                        leftBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        constraints.append(contentsOf: [rightBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                        rightBackgroundView.topAnchor.constraint(equalTo: topAnchor),
                                        rightBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                        rightBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        constraints.append(contentsOf: [leftLabelLeadingLayoutConstraint,
                                        leftLabel.topAnchor.constraint(equalTo: topAnchor),
                                        leftLabelTrailingLayoutConstraint,
                                        leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
        constraints.append(contentsOf: [rightLabelLeadingLayoutConstraint,
                                        rightLabel.topAnchor.constraint(equalTo: topAnchor),
                                        rightLabelTrailingLayoutConstraint,
                                        rightLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
        constraints.append(contentsOf: [toggleViewLeadingLayoutConstraint,
                                        toggleView.topAnchor.constraint(equalTo: topAnchor, constant: sliderLabelInset),
                                        toggleViewWidthLayoutConstraint,
                                        toggleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -sliderLabelInset)])

        NSLayoutConstraint.activate(constraints)
    }

    public override func updateConstraints() {
        leftLabelLeadingLayoutConstraint.constant = bounds.height / 2
        leftLabelTrailingLayoutConstraint.constant = -toggleView.bounds.width - sliderLabelInset * 2
        rightLabelLeadingLayoutConstraint.constant = toggleView.bounds.width + sliderLabelInset * 2
        rightLabelTrailingLayoutConstraint.constant = -bounds.height / 2

        super.updateConstraints()
    }


    // MARK: Gestures

    @objc func tap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        change(position: location.x < bounds.width / SliderConstants.numberOfLabels ? .left : .right , animated: true)
    }

    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .possible, .began:
            initialToggleViewConstant = fabs(position == .left ? toggleViewLeadingLayoutConstraint.constant : toggleViewTrailingLayoutConstraint.constant)
            break
        case .changed:
            guard var layoutConstraint = initialToggleViewConstant else { return }
            layoutConstraint += fabs(gesture.translation(in: self).x)
            layoutConstraint = max(min(layoutConstraint, bounds.width - sliderLabelInset - toggleView.bounds.width), sliderLabelInset)

            if position == .left {
                toggleViewLeadingLayoutConstraint.constant = layoutConstraint
            } else {
                toggleViewTrailingLayoutConstraint.constant = -layoutConstraint
            }

            let alpha = (layoutConstraint + toggleView.bounds.width) / bounds.width
            leftBackgroundView.alpha = alpha
            rightBackgroundView.alpha = 1 - alpha
            break
        case .ended, .failed, .cancelled:
            guard initialToggleViewConstant != nil else { return }

            let halfToggleView = toggleView.bounds.width / 2
            let halfSliderControl = bounds.width / SliderConstants.numberOfLabels
            let newPosition: SliderPosition

            if position == .left {
                newPosition = toggleViewLeadingLayoutConstraint.constant + halfToggleView < halfSliderControl ? .left : .right
            } else {
                newPosition = fabs(toggleViewTrailingLayoutConstraint.constant) + halfToggleView < halfSliderControl ? .right : .left
            }

            change(position: newPosition, animated: true)
            initialToggleViewConstant = nil
            break
        }
    }


    // MARK: Layout

    override public class var requiresConstraintBasedLayout: Bool {
        return true
    }

    public override var intrinsicContentSize: CGSize {

        return CGSize(width: SliderConstants.minWidth, height: SliderConstants.minHeight)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        setNeedsUpdateConstraints()
    }

    override public class var layerClass : AnyClass {
        return SliderMainLayer.self
    }

    fileprivate func createEmptyLabel(textAlignment: NSTextAlignment, font: UIFont, textColor: UIColor) -> UILabel {
        let emptyLabel = UILabel()
        emptyLabel.textAlignment = textAlignment
        emptyLabel.font = SliderConstants.fontMetrics.scaledFont(for: font)
        emptyLabel.textColor = textColor
        emptyLabel.minimumScaleFactor = SliderConstants.fontMinimumScaleFactor
        emptyLabel.adjustsFontForContentSizeCategory = true
        emptyLabel.adjustsFontSizeToFitWidth = true
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
//        emptyLabel.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
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


// MARK: - Default Slider View

public class SliderToggleView: UIView {
    public override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
    }
}


// MARK: - Custom main layer for Slider Control

private class SliderMainLayer: CALayer {

    override func layoutSublayers() {
        super.layoutSublayers()
        cornerRadius = bounds.height / 2
        masksToBounds = true
    }

}


// MARK: - UIGestureRecognizerDelegate

extension SliderControl: UIGestureRecognizerDelegate {

    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            return toggleView.frame.contains(gestureRecognizer.location(in: self))
        }

        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

}
