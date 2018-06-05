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

        slider.leftSideTitle = "Downloading…"
        slider.rightSideTitle = "Slide to download"
        slider.sliderTitle = "Start"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderValueChanged(_ sender: SliderControl) {
        slider.sliderTitle = sender.selectedIndex == 0 ? "Start" : "Stop"
    }

}

