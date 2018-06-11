//
//  ViewController.swift
//  SliderDemo
//
//  Created by Evgeniy Mikholap on 6/5/18.
//  Copyright © 2018 Evgeniy Mikholap. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var slider: SliderControl!
    @IBOutlet weak var slider1: SliderControl!
    @IBOutlet weak var slider3: SliderControl!
    @IBOutlet weak var slider4: SliderControl!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    var toggleLabel: UILabel = {
        let toggleLabel = UILabel()
        toggleLabel.textAlignment = .center
        toggleLabel.font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: UIFont.systemFont(ofSize: 15, weight: .medium))
        toggleLabel.textColor = #colorLiteral(red: 0.7176470588, green: 0.7137254902, blue: 0.7333333333, alpha: 1)
        toggleLabel.minimumScaleFactor = 0.5
        toggleLabel.adjustsFontForContentSizeCategory = true
        toggleLabel.adjustsFontSizeToFitWidth = true
        toggleLabel.numberOfLines = 0
        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        return toggleLabel
    }()

    var textToggle = SliderToggleView()
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        return activityIndicator
    }()

    var toggle1 = UIImageView(image: #imageLiteral(resourceName: "start"))

    override func viewDidLoad() {
        super.viewDidLoad()

        toggleLabel.text = NSLocalizedString("slider.main.text.start", comment: "").localizedUppercase
        textToggle.addSubview(toggleLabel)
        textToggle.addSubview(activityIndicator)

        toggleLabel.leadingAnchor.constraint(equalTo: textToggle.leadingAnchor).isActive = true
        toggleLabel.trailingAnchor.constraint(equalTo: textToggle.trailingAnchor).isActive = true
        toggleLabel.topAnchor.constraint(equalTo: textToggle.topAnchor).isActive = true
        toggleLabel.bottomAnchor.constraint(equalTo: textToggle.bottomAnchor).isActive = true

        activityIndicator.centerXAnchor.constraint(equalTo: textToggle.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: textToggle.centerYAnchor).isActive = true

        slider.leftSideTitle = NSLocalizedString("slider.label.text.requesting", comment: "")
        slider.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-start", comment: "")
        slider.customToggleView = textToggle

        slider1.leftSideTitle = NSLocalizedString("slider.label.text.requesting", comment: "")
        slider1.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-start", comment: "")
        slider1.customToggleView = toggle1
        toggle1.contentMode = .center

        slider3.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-unlock", comment: "")
        slider3.leftSideTitle = NSLocalizedString("slider.left-label.text.slide-to-lock", comment: "")
        slider3.isEnabled = false

        slider4.change(position: .right, animated: false)
        slider4.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-unlock", comment: "")
        slider4.leftSideTitle = NSLocalizedString("slider.left-label.text.slide-to-lock", comment: "")
        slider4.isEnabled = false
    }

    @IBAction func sliderValueChanged(_ sender: SliderControl) {
        toggleLabel.isHidden = true
        activityIndicator.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.toggleLabel.isHidden = false
            self?.toggleLabel.text = sender.position == .left ? NSLocalizedString("slider.main.text.start", comment: "").localizedUppercase : NSLocalizedString("slider.main.text.stop", comment: "").localizedUppercase
            sender.rightSideTitle =  NSLocalizedString(sender.position == .left ? "slider.right-label.text.slide-to-start" : "slider.label.text.requesting", comment: "")
            sender.leftSideTitle =  NSLocalizedString(sender.position == .left ? "slider.label.text.requesting" : "slider.label.text.done", comment: "")
        }
    }

    @IBAction func slider1ValueChanged(_ sender: SliderControl) {
        toggle1.image = sender.position == .left ? #imageLiteral(resourceName: "start") : #imageLiteral(resourceName: "stop")
    }

    @IBAction func didTouchButton(_ sender: UIButton) {
        heightConstraint.constant = heightConstraint.constant == 70 ? 20 : 70
    }
}

