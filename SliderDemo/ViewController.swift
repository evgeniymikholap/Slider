//
//  ViewController.swift
//  SliderDemo
//
//  Created by Evgeniy Mikholap on 6/5/18.
//  Copyright © 2018 Evgeniy Mikholap. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var firstSliderControl: SliderControl!
    @IBOutlet weak var secondSliderControl: SliderControl!
    @IBOutlet weak var smallSlidersStackView: UIStackView!
    @IBOutlet weak var thirdSliderControl: SliderControl!
    @IBOutlet weak var fourthSliderControl: SliderControl!
    @IBOutlet weak var fifthSliderControl: SliderControl!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var disabledSlidersStackView: UIStackView!
    @IBOutlet weak var sixthSliderControl: SliderControl!
    @IBOutlet weak var seventhSliderControl: SliderControl!

    var firstToggleLabel: UILabel = {
        let firstToggleLabel = UILabel()
        firstToggleLabel.textAlignment = .center
        firstToggleLabel.font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: UIFont.systemFont(ofSize: 15, weight: .medium))
        firstToggleLabel.textColor = #colorLiteral(red: 0.7176470588, green: 0.7137254902, blue: 0.7333333333, alpha: 1)
        firstToggleLabel.minimumScaleFactor = 0.5
        firstToggleLabel.adjustsFontForContentSizeCategory = true
        firstToggleLabel.adjustsFontSizeToFitWidth = true
        firstToggleLabel.numberOfLines = 0
        firstToggleLabel.translatesAutoresizingMaskIntoConstraints = false
        return firstToggleLabel
    }()
    var firstToggleView = SliderToggleView()
    let firstToggleActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        return activityIndicator
    }()

    var secondToggleView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "start"))
        imageView.contentMode = .center
        return imageView
    }()

    var fifthToggleViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.setTitle("→", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureFirstSliderControl()
        configureSecondSliderControl()
        configureThirdSliderControl()
        configureFourthSliderControl()
        configureFifthSliderControl()
        configureSixthSliderControl()
        configureSeventhSliderControl()
    }

    /// Uncoment for test Slider Control customization
    @IBAction func didTouchTestButton() {
//        firstSliderControl.customToggleView = {
//            let imageView = UIImageView(image: #imageLiteral(resourceName: "stop"))
//            imageView.contentMode = .center
//            return imageView
//        }()

//        firstSliderControl.leftSideTitle = NSLocalizedString("slider.test.text", comment: "")
//        firstSliderControl.rightSideTitle = NSLocalizedString("slider.test.text", comment: "")

//        firstSliderControl.change(position: firstSliderControl.position == .left ? .right : .left, animated: true)
//        firstSliderControl.change(position: firstSliderControl.position == .left ? .right : .left, animated: false)

//        firstSliderControl.contentInset = 10
//        firstSliderControl.contentInset = 0
//        firstSliderControl.contentInset = -10

//        firstSliderControl.isEnabled = !firstSliderControl.isEnabled
//        firstSliderControl.isSliderEnabled = !firstSliderControl.isSliderEnabled

//        firstSliderControl.leftLabelTitleFont = UIFont.italicSystemFont(ofSize: 10)
//        firstSliderControl.rightLabelTitleFont = UIFont.boldSystemFont(ofSize: 25)

//        firstSliderControl.leftSideBackgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//        firstSliderControl.rightSideBackgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)

//        firstSliderControl.leftLabelTextColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
//        firstSliderControl.rightLabelTextColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

//        firstSliderControl.isToggleShadow = !firstSliderControl.isToggleShadow
//        firstSliderControl.toggleShadowColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//        firstSliderControl.toggleShadowOffset = CGSize(width: 3, height: 3)
//        firstSliderControl.toggleShadowOpacity = 0.9
//        firstSliderControl.toggleShadowRadius = 10
    }

    // MARK: - Sliders Configurators

    func configureFirstSliderControl() {
        firstToggleLabel.text = NSLocalizedString("slider.main.text.start", comment: "").localizedUppercase

        firstToggleView.addSubview(firstToggleLabel)
        firstToggleView.addSubview(firstToggleActivityIndicator)

        firstToggleLabel.leadingAnchor.constraint(equalTo: firstToggleView.leadingAnchor).isActive = true
        firstToggleLabel.trailingAnchor.constraint(equalTo: firstToggleView.trailingAnchor).isActive = true
        firstToggleLabel.topAnchor.constraint(equalTo: firstToggleView.topAnchor).isActive = true
        firstToggleLabel.bottomAnchor.constraint(equalTo: firstToggleView.bottomAnchor).isActive = true

        firstToggleActivityIndicator.centerXAnchor.constraint(equalTo: firstToggleView.centerXAnchor).isActive = true
        firstToggleActivityIndicator.centerYAnchor.constraint(equalTo: firstToggleView.centerYAnchor).isActive = true

        firstSliderControl.leftSideTitle = NSLocalizedString("slider.label.text.requesting", comment: "")
        firstSliderControl.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-start", comment: "")
        firstSliderControl.customToggleView = firstToggleView
    }

    func configureSecondSliderControl() {
        secondSliderControl.customToggleView = secondToggleView
        secondSliderControl.leftSideTitle = NSLocalizedString("slider.left-label.text.stop", comment: "")
        secondSliderControl.rightSideTitle = NSLocalizedString("slider.right-label.text.start", comment: "")
        secondSliderControl.leftSideBackgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        secondSliderControl.rightSideBackgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        secondSliderControl.leftLabelTextColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        secondSliderControl.rightLabelTextColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
    }

    func configureThirdSliderControl() {
        let toggleView = SliderToggleView()
        toggleView.topColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        toggleView.bottomColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        thirdSliderControl.customToggleView = toggleView
        thirdSliderControl.leftSideBackgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        thirdSliderControl.rightSideBackgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        thirdSliderControl.toggleShadowColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        thirdSliderControl.toggleShadowOpacity = 0.3
        thirdSliderControl.toggleShadowRadius = 5
    }

    func configureFourthSliderControl() {
        let toggleView = UIView()
        toggleView.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)

        fourthSliderControl.customToggleView = toggleView
        fourthSliderControl.leftSideBackgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        fourthSliderControl.rightSideBackgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }

    func configureFifthSliderControl() {
        fifthSliderControl.customToggleView = fifthToggleViewButton
        fifthSliderControl.leftSideBackgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        fifthSliderControl.rightSideBackgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        fifthSliderControl.leftLabelTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        fifthSliderControl.rightLabelTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        fifthSliderControl.leftSideTitle = NSLocalizedString("slider.left-label.text.off", comment: "")
        fifthSliderControl.rightSideTitle = NSLocalizedString("slider.right-label.text.on", comment: "")
        fifthSliderControl.leftLabelTitleFont = UIFont.systemFont(ofSize: 18, weight: .light)
        fifthSliderControl.rightLabelTitleFont = fifthSliderControl.leftLabelTitleFont
        fifthSliderControl.change(position: .right, animated: false)
    }

    func configureSixthSliderControl() {
        seventhSliderControl.leftSideTitle = NSLocalizedString("slider.left-label.text.slide-to-lock", comment: "")
        seventhSliderControl.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-unlock", comment: "")
    }

    func configureSeventhSliderControl() {
        seventhSliderControl.change(position: .right, animated: false)
        seventhSliderControl.leftSideTitle = NSLocalizedString("slider.left-label.text.slide-to-lock", comment: "")
        seventhSliderControl.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-unlock", comment: "")
    }


    // MARK: - Actions

    @IBAction func firstSliderControlValueChanged(_ sender: SliderControl) {
        firstToggleLabel.isHidden = true
        firstToggleActivityIndicator.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.firstToggleActivityIndicator.stopAnimating()
            self?.firstToggleLabel.isHidden = false
            self?.firstToggleLabel.text = sender.position == .left ? NSLocalizedString("slider.main.text.start", comment: "").localizedUppercase : NSLocalizedString("slider.main.text.stop", comment: "").localizedUppercase
            sender.rightSideTitle =  NSLocalizedString(sender.position == .left ? "slider.right-label.text.slide-to-start" : "slider.label.text.requesting", comment: "")
            sender.leftSideTitle =  NSLocalizedString(sender.position == .left ? "slider.label.text.requesting" : "slider.label.text.done", comment: "")
        }
    }
    
    @IBAction func secondSliderControlValueChanged(_ sender: SliderControl) {
        secondToggleView.image = sender.position == .left ? #imageLiteral(resourceName: "start") : #imageLiteral(resourceName: "stop")
    }

    @IBAction func fifthSliderControlValueChanged(_ sender: SliderControl) {
        fifthToggleViewButton.setTitle(sender.position == .left ? "→" : "←" , for: .normal)
    }

}

