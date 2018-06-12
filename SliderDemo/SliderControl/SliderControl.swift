//
//  SliderControl.swift
//  SliderDemo
//
//  Created by Evgeniy Mikholap on 6/5/18.
//  Copyright © 2018 Evgeniy Mikholap. All rights reserved.
//

import UIKit


// MARK: - Slider Control constants

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
    static let toggleViewShadowOpacity: Float  = 0.2
    static let toggleViewShadowRadius: CGFloat = 2
    static let toggleViewShadowOffset          = CGSize(width: 0, height: 0)
    static let fontMinimumScaleFactor: CGFloat = 0.5

}


// MARK: - Slider Control color

private struct SliderDefaultColors {

    static let leftSideBackgroundColor     = #colorLiteral(red: 0, green: 0.7307787538, blue: 0.6325929761, alpha: 1)
    static let rightSideBackgroundColor    = #colorLiteral(red: 0.5369121432, green: 0.5369251966, blue: 0.5369181633, alpha: 1)
    static let sliderFirstBackgroundColor  = #colorLiteral(red: 0.9921568627, green: 0.9882352941, blue: 0.9803921569, alpha: 1)
    static let sliderSecondBackgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8705882353, alpha: 1)
    static let sliderTextColor             = #colorLiteral(red: 0.7176470588, green: 0.7137254902, blue: 0.7333333333, alpha: 1)
    static let leftLabelTextColor          = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let rightLabelTextColor         = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    static let toggleShadowColor           = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

}


// MARK: - Slider View position

public enum SliderPosition: Int {
    case left = 0
    case right
}


// MARK: - Public interface for the Slider Control

public protocol SliderControlProtocol {
    /// Custom Toggle View. Default: `SliderToggleView()`
    var customToggleView: UIView { get set }

    /// Left label title
    var leftSideTitle: String? { get }

    /// Right label title
    var rightSideTitle: String? { get }

    /// Slider View position. Read-only. Default: `.left`
    var position: SliderPosition { get }

    /// Slider View inset. Default: `SliderConstants.defaultSliderViewInset`
    var contentInset: CGFloat { get set }

    /// A Boolean value that determines whether the Slider Control is enabled. Default: `true`
    var isSliderEnabled: Bool { get set }

    /// Left label font
    var leftLabelTitleFont: UIFont { get set }

    /// Right label font
    var rightLabelTitleFont: UIFont { get set }

    /// Left side view background color. IBInspectable. Default: `SliderColors.leftSideBackgroundColor`
    var leftSideBackgroundColor: UIColor { get set }

    /// Right side view background color. IBInspectable. Default: `SliderColors.rightSideBackgroundColor`
    var rightSideBackgroundColor: UIColor { get set }

    /// Left label text color. Default: `SliderColors.leftLabelTextColor`
    var leftLabelTextColor: UIColor { get set }

    /// Right label text color. Default: `SliderColors.rightLabelTextColor`
    var rightLabelTextColor: UIColor { get set }

    /// A Boolean value that determines whether the Toggle Shadow is shown. Default: `true`
    var isToggleShadow: Bool { get set }

    /// The color of the Toggle’s shadow. Default: `SliderDefaultColors.toggleShadowColor`
    var toggleShadowColor: UIColor { get set }

    /// The offset (in points) of the Toggle’s shadow. Default: `SliderConstants.toggleViewShadowOffset`
    var toggleShadowOffset: CGSize { get set }

    /// The opacity of the Toggle’s shadow. Default: `SliderConstants.toggleViewShadowOpacity`
    var toggleShadowOpacity: Float { get set }

    /// The blur radius (in points) used to render the Toggle’s shadow. Default: `SliderConstants.toggleViewShadowRadius`
    var toggleShadowRadius: CGFloat { get set }

    /**
     Changes Slider View position

     - Parameter position: `.right` or `.left` Slider View position
     - Parameter animated: if `true`, Slider view is being updated using an animation
     */
    func change(position: SliderPosition, animated: Bool)
}


// MARK: - Slider Control class

@IBDesignable public class SliderControl: UIControl, SliderControlProtocol {

    // MARK: Public interface. SliderControlProtocol

    public var customToggleView: UIView = SliderToggleView() {
        didSet {
            toggleContainerView.addContentView(customToggleView)
        }
    }
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
    private(set) public var position: SliderPosition = .left
    public var contentInset: CGFloat = SliderConstants.defaultSliderViewInset {
        didSet {
            toggleContainerViewLeadingLayoutConstraint.constant = contentInset
            toggleContainerViewTrailingLayoutConstraint.constant = -contentInset
            toggleContainerViewTopLayoutConstraint.constant = contentInset
            toggleContainerViewBottomLayoutConstraint.constant = -contentInset
        }
    }
    @IBInspectable public var isSliderEnabled: Bool = true {
        didSet {
            isEnabled = isSliderEnabled
            alpha = isSliderEnabled ? 1 : alpha / 2
        }
    }
    public override var isEnabled: Bool {
        didSet {
            if isEnabled != isSliderEnabled {
                isSliderEnabled = isEnabled
            }
        }
    }
    public var leftLabelTitleFont = SliderConstants.defaultLabelFont {
        didSet {
            leftLabel.font = SliderConstants.fontMetrics.scaledFont(for: leftLabelTitleFont)
        }
    }
    public var rightLabelTitleFont = SliderConstants.defaultLabelFont {
        didSet {
            rightLabel.font = SliderConstants.fontMetrics.scaledFont(for: rightLabelTitleFont)
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
    @IBInspectable public var isToggleShadow: Bool = true {
        didSet {
            toggleContainerView.isShadow = isToggleShadow
        }
    }
    @IBInspectable public var toggleShadowColor: UIColor = SliderDefaultColors.toggleShadowColor {
        didSet {
            toggleContainerView.shadowColor = toggleShadowColor
        }
    }
    @IBInspectable public var toggleShadowOffset: CGSize = SliderConstants.toggleViewShadowOffset {
        didSet {
            toggleContainerView.shadowOffset = toggleShadowOffset
        }
    }
    @IBInspectable public var toggleShadowOpacity: Float = SliderConstants.toggleViewShadowOpacity {
        didSet {
            toggleContainerView.shadowOpacity = toggleShadowOpacity
        }
    }
    @IBInspectable public var toggleShadowRadius: CGFloat = SliderConstants.toggleViewShadowRadius {
        didSet {
            toggleContainerView.shadowRadius = toggleShadowRadius
        }
    }

    public func change(position: SliderPosition, animated: Bool) {
        let catchHalfSwitch = self.position == position
        self.position = position

        let toggleInset = bounds.width - self.contentInset - toggleContainerView.bounds.width
        self.toggleContainerViewLeadingLayoutConstraint.constant = position == .left ? self.contentInset : toggleInset
        self.toggleContainerViewTrailingLayoutConstraint.constant = position == .right ? -self.contentInset : -toggleInset

        if animated {
            if !catchHalfSwitch {
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
                self.toggleContainerViewTrailingLayoutConstraint.isActive = position == .right
                self.toggleContainerViewLeadingLayoutConstraint.isActive = position == .left
            })
        } else {
            self.leftBackgroundView.alpha = CGFloat(position.rawValue)
            self.rightBackgroundView.alpha = CGFloat(1 - position.rawValue)
            self.toggleContainerViewTrailingLayoutConstraint.isActive = position == .right
            self.toggleContainerViewLeadingLayoutConstraint.isActive = position == .left
            layoutIfNeeded()
            sendActions(for: .valueChanged)
        }
    }


    // MARK: Private variables

    private lazy var leftBackgroundView: UIView = {
        let leftBackgroundView = UIView()
        leftBackgroundView.backgroundColor = leftSideBackgroundColor
        leftBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return leftBackgroundView
    }()
    private lazy var rightBackgroundView: UIView = {
        let rightBackgroundView = UIView()
        rightBackgroundView.backgroundColor = rightSideBackgroundColor
        rightBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return rightBackgroundView
    }()
    private lazy var leftLabel: UILabel = createEmptyLabel(textAlignment: .left, font: leftLabelTitleFont, textColor: leftLabelTextColor)
    private lazy var rightLabel: UILabel = createEmptyLabel(textAlignment: .right, font: rightLabelTitleFont, textColor: rightLabelTextColor)
    private lazy var toggleContainerView: SliderToggleContainerView = {
        let toggleContainerView = SliderToggleContainerView()
        toggleContainerView.translatesAutoresizingMaskIntoConstraints = false
        toggleContainerView.addContentView(customToggleView)
        return toggleContainerView
    }()
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
    private lazy var leftLabelLeadingLayoutConstraint = leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
    private lazy var leftLabelTrailingLayoutConstraint = leftLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    private lazy var rightLabelLeadingLayoutConstraint = rightLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
    private lazy var rightLabelTrailingLayoutConstraint = rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    private lazy var toggleContainerViewLeadingLayoutConstraint = toggleContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInset)
    private lazy var toggleContainerViewTopLayoutConstraint = toggleContainerView.topAnchor.constraint(equalTo: topAnchor, constant: contentInset)
    private lazy var toggleContainerViewTrailingLayoutConstraint = toggleContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInset)
    private lazy var toggleContainerViewBottomLayoutConstraint = toggleContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInset)
    private var initialToggleContainerViewConstant: CGFloat?


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

     private func commonInit() {
        addSubview(leftBackgroundView)
        addSubview(rightBackgroundView)

        leftBackgroundView.addSubview(leftLabel)
        rightBackgroundView.addSubview(rightLabel)

        addSubview(toggleContainerView)

        addGestureRecognizer(tapGesture)
        addGestureRecognizer(panGesture)
        panGesture.delegate = self

        setupConstraints()

        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    private func setupConstraints() {
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
        constraints.append(contentsOf: [toggleContainerViewLeadingLayoutConstraint,
                                        toggleContainerViewTopLayoutConstraint,
                                        toggleContainerView.widthAnchor.constraint(equalTo: toggleContainerView.heightAnchor, multiplier: 1),
                                        toggleContainerViewBottomLayoutConstraint])

        NSLayoutConstraint.activate(constraints)
    }

    public override func updateConstraints() {
        leftLabelLeadingLayoutConstraint.constant = bounds.height / 2
        leftLabelTrailingLayoutConstraint.constant = -toggleContainerView.bounds.width - contentInset * 2

        rightLabelLeadingLayoutConstraint.constant = toggleContainerView.bounds.width + contentInset * 2
        rightLabelTrailingLayoutConstraint.constant = -bounds.height / 2

        super.updateConstraints()
    }


    // MARK: Gestures

    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        change(position: position == .left ? .right : .left , animated: true)
    }

    @objc private func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .possible, .began:
            initialToggleContainerViewConstant = position == .left ? toggleContainerViewLeadingLayoutConstraint.constant : toggleContainerViewTrailingLayoutConstraint.constant
            break
        case .changed:
            guard var layoutConstant = initialToggleContainerViewConstant else { return }
            let translation = gesture.translation(in: self)
            let freeDistance = bounds.width - toggleContainerView.bounds.width - contentInset
            layoutConstant += translation.x

            if position == .left {
                layoutConstant = max(min(layoutConstant, freeDistance), contentInset)
                toggleContainerViewLeadingLayoutConstraint.constant = layoutConstant
                leftBackgroundView.alpha = layoutConstant / bounds.width
                rightBackgroundView.alpha = 1 - layoutConstant / bounds.width
            } else {
                layoutConstant = min(max(layoutConstant, -freeDistance), -contentInset)
                toggleContainerViewTrailingLayoutConstraint.constant = layoutConstant
                leftBackgroundView.alpha = 1 - fabs(layoutConstant) / bounds.width
                rightBackgroundView.alpha = fabs(layoutConstant) / bounds.width
            }

            break
        case .ended, .failed, .cancelled:
            guard initialToggleContainerViewConstant != nil else { return }
            let halfADistance = bounds.width / 2 - toggleContainerView.bounds.width / 2 - contentInset * 2
            var newPosition: SliderPosition

            if position == .left {
                newPosition = toggleContainerViewLeadingLayoutConstraint.constant < halfADistance ? .left : .right
            } else {
                newPosition = toggleContainerViewTrailingLayoutConstraint.constant > -halfADistance ? .right : .left
            }

            change(position: newPosition, animated: true)
            initialToggleContainerViewConstant = nil
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


    // MARK: Private

    private func createEmptyLabel(textAlignment: NSTextAlignment, font: UIFont, textColor: UIColor) -> UILabel {
        let emptyLabel = UILabel()
        emptyLabel.textAlignment = textAlignment
        emptyLabel.font = SliderConstants.fontMetrics.scaledFont(for: font)
        emptyLabel.textColor = textColor
        emptyLabel.minimumScaleFactor = SliderConstants.fontMinimumScaleFactor
        emptyLabel.adjustsFontForContentSizeCategory = true
        emptyLabel.adjustsFontSizeToFitWidth = true
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        return emptyLabel
    }

}


// MARK: - Default Slider View

public class SliderToggleView: UIView {

    public var topColor: UIColor = SliderDefaultColors.sliderFirstBackgroundColor {
        didSet {
            gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        }
    }
    public var bottomColor: UIColor = SliderDefaultColors.sliderSecondBackgroundColor {
        didSet {
            gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        }
    }

    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    override public class var layerClass : AnyClass {
        return CAGradientLayer.self
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
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


// MARK: - Toggle Container View

private class SliderToggleContainerView: UIView {

    private let shadowLayer = CAShapeLayer()
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.clear
        return containerView
    }()
    public var isShadow: Bool = true {
        didSet {
            shadowLayer.isHidden = !isShadow
        }
    }
    public var shadowColor: UIColor = SliderDefaultColors.toggleShadowColor {
        didSet {
            shadowLayer.shadowColor = shadowColor.cgColor
        }
    }
    public var shadowOffset: CGSize = SliderConstants.toggleViewShadowOffset {
        didSet {
            shadowLayer.shadowOffset = shadowOffset
        }
    }
    public var shadowOpacity: Float = SliderConstants.toggleViewShadowOpacity {
        didSet {
            shadowLayer.shadowOpacity = shadowOpacity
        }
    }
    public var shadowRadius: CGFloat = SliderConstants.toggleViewShadowRadius {
        didSet {
            shadowLayer.shadowRadius = shadowRadius
        }
    }

    public func addContentView(_ view: UIView) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        addSubview(containerView)

        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.removeFromSuperlayer()

        if isShadow {
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = shadowOffset
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            layer.insertSublayer(shadowLayer, below: containerView.layer)
        }

        containerView.layer.cornerRadius = bounds.height / 2
    }

    private func setupConstraints() {
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}


// MARK: - UIGestureRecognizerDelegate

extension SliderControl: UIGestureRecognizerDelegate {

    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            return toggleContainerView.frame.contains(gestureRecognizer.location(in: self))
        }

        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

}
