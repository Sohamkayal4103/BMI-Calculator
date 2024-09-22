//
//  ResultViewController.swift
//  BMI Calculator
//
//  Created by Soham Kayal on 22/05/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    var bmiValue : String = "0.0";
    var adviceString : String?
    var color : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bmiLabel.text = bmiValue;
        let bmiDoubleVal = Double(bmiValue);
        adviceLabel.text = adviceString ?? "Default Advise";
        view.backgroundColor = color ?? UIColor.blue;
//        if(bmiDoubleVal! <= 22.00){
//            adviceLabel.text = "Eat more Snacks!";
//        }
//        else if(bmiDoubleVal! > 22.00 && bmiDoubleVal! <= 25.00){
//            adviceLabel.text = "Maintain This BMI Level!";
//        }
//        else{
//            adviceLabel.text = "Eat Less Snacks!";
//        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
