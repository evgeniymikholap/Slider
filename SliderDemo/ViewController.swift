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
    @IBOutlet weak var slider3: SliderControl!
    @IBOutlet weak var slider4: SliderControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        slider.leftSideTitle = NSLocalizedString("slider.label.text.requesting", comment: "")
        slider.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-start", comment: "")
        slider.sliderTitle = NSLocalizedString("slider.main.text.start", comment: "").localizedUppercase

        let slider2 = SliderControl()
        slider2.sliderTitle = NSLocalizedString("slider.main.text.checkin", comment: "").localizedCapitalized
        slider2.leftSideTitle = NSLocalizedString("slider.left-label.text.checkin", comment: "")
        slider2.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-checkin", comment: "")
        slider2.frame = CGRect(x: 50.0, y: 20.0, width: view.bounds.width - 100.0, height: 100.0)
        slider2.autoresizingMask = [.flexibleWidth]
        view.addSubview(slider2)

        slider3.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-unlock", comment: "")
        slider3.sliderTitle = NSLocalizedString("slider.main.text.start", comment: "").localizedUppercase
        slider3.leftSideTitle = NSLocalizedString("slider.left-label.text.slide-to-lock", comment: "")
        slider3.isEnabled = false

        slider4.change(position: .right, animated: false)
        slider4.rightSideTitle = NSLocalizedString("slider.right-label.text.slide-to-unlock", comment: "")
        slider4.sliderTitle = NSLocalizedString("slider.main.text.stop", comment: "").localizedUppercase
        slider4.leftSideTitle = NSLocalizedString("slider.left-label.text.slide-to-lock", comment: "")
        slider4.isEnabled = false
    }

    @IBAction func sliderValueChanged(_ sender: SliderControl) {
        sender.showActivityIndicator()
        sender.sliderTitle = NSLocalizedString(sender.position == .left ? "slider.main.text.start" : "slider.main.text.stop", comment: "").localizedUppercase

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.hideActivityIndicator()

            sender.rightSideTitle =  NSLocalizedString(sender.position == .left ? "slider.right-label.text.slide-to-start" : "slider.label.text.requesting", comment: "")
            sender.leftSideTitle =  NSLocalizedString(sender.position == .left ? "slider.label.text.requesting" : "slider.label.text.done", comment: "")
        }
    }
}

