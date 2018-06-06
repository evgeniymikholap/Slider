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

        slider.leftSideTitle = "requesting…"
        slider.rightSideTitle = "slide to start"
        slider.sliderTitle = "START"

        let slider2 = SliderControl(sliderTitle: "Check-in", leftSideTitle: "check-in…", rightSideTitle: "slide to check-in")
        slider2.frame = CGRect(x: 50.0, y: 20.0, width: view.bounds.width - 100.0, height: 100.0)
        slider2.autoresizingMask = [.flexibleWidth]
        view.addSubview(slider2)

        slider3.rightSideTitle = "slide to unlock"
        slider3.sliderTitle = "START"
        slider3.leftSideTitle = "slide to lock"
        slider3.isEnabled = false

        slider4.selectedIndex = 1
        slider4.rightSideTitle = "slide to unlock"
        slider4.sliderTitle = "STOP"
        slider4.leftSideTitle = "slide to lock"
        slider4.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderValueChanged(_ sender: SliderControl) {
//        if sender.controlState != .error {
//            sender.showActivityIndicator()
//            sender.sliderTitle = sender.selectedIndex == 0 ? "START" : "STOP"
//            sender.isEnabled = false
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                sender.isEnabled = true
//                sender.hideActivityIndicator()
//
//                let isError = Bool(truncating: arc4random() % 2 as NSNumber);
//
//                if isError {
//                    sender.leftSideTitle = sender.selectedIndex == 0 ? "requesting…" : "error"
//                    sender.rightSideTitle = sender.selectedIndex == 0 ? "error" : "slide to start"
//                    sender.controlState = .error
//                    sender.setSelectedIndex(1 - sender.selectedIndex, animated: true, animationDelay: 2)
//                } else {
//                    sender.rightSideTitle = sender.selectedIndex == 0 ? "slide to start" : "requesting…"
//                    sender.leftSideTitle = sender.selectedIndex == 0 ? "requesting…" : "done"
//                }
//            }
//        } else {
//            sender.controlState = .normal
//            sender.leftSideTitle = sender.selectedIndex == 0 ? "requesting…" : "done"
//            sender.rightSideTitle = sender.selectedIndex == 0 ? "slide to start" : "done"
//        }
//    }

            sender.showActivityIndicator()
            sender.sliderTitle = sender.selectedIndex == 0 ? "START" : "STOP"

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                sender.hideActivityIndicator()

                sender.rightSideTitle = sender.selectedIndex == 0 ? "slide to start" : "requesting…"
                sender.leftSideTitle = sender.selectedIndex == 0 ? "requesting…" : "done"
            }
    }
}

