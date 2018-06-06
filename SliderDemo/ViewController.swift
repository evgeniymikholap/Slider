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

    override func viewDidLoad() {
        super.viewDidLoad()

        slider.leftSideTitle = "requesting…"
        slider.rightSideTitle = "slide to start"
        slider.sliderTitle = "START"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderValueChanged(_ sender: SliderControl) {
        sender.showActivityIndicator()
        slider.sliderTitle = sender.selectedIndex == 0 ? "START" : "STOP"

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.hideActivityIndicator()
            sender.rightSideTitle = sender.selectedIndex == 0 ? "slide to start" : "requesting…"
            sender.leftSideTitle = sender.selectedIndex == 0 ? "requesting…" : "done"
        }
    }

}

