//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {

    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    //var bmiValue : Float = 0.0;
    var calculatorBrain = CalculatorBrain();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func heightControler(_ sender: UISlider) {
        heightLabel.text = "\(String(format: "%.2f", sender.value))m"
        print(String(format: "%.2f", sender.value));
        //print(round(sender.value * 100) / 100.0);
    }
    
    
    @IBAction func weightController(_ sender: UISlider) {
        print(Int(sender.value));
        weightLabel.text = "\(Int(sender.value))kg"
        //print(String(format: "%.2f", sender.value));
        //print(round(sender.value * 100) / 100.0);
    }
    
    
    @IBAction func calculateBMI(_ sender: UIButton) {
//        bmiValue = weightSlider.value / pow(heightSlider.value, 2);
//        print(bmiValue);
        calculatorBrain.calculateBMIValue(height: heightSlider.value,weight: weightSlider.value);
        self.performSegue(withIdentifier: "goToResult", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToResult") {
            let destinationVC = segue.destination as! ResultViewController;
            let bmiValue = calculatorBrain.getBMIValue();
            let bmiString = calculatorBrain.getAdvise();
            let bmiColor = calculatorBrain.getColor();
            destinationVC.bmiValue = String(format: "%.2f", bmiValue);
            destinationVC.adviceString = bmiString;
            destinationVC.color = bmiColor;
        }
    }

}

