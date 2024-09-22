//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Soham Kayal on 03/06/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import Foundation
import UIKit

struct CalculatorBrain{
    var bmiValue : BMI?
    
    
    mutating func calculateBMIValue(height: Float,weight: Float) {
        let bmiVal = weight / pow(height, 2);
        print(bmiVal);
        let adviseString : String?;
        if(bmiVal < 18.5){
            bmiValue = BMI(value: bmiVal, advise: "Underweight", color: UIColor.blue);
        }
        else if(bmiVal < 24.9){
            bmiValue = BMI(value: bmiVal, advise: "Ideal Weight", color: UIColor.green);
        }
        else{
            bmiValue = BMI(value: bmiVal, advise: "Overweight", color: UIColor.systemPink);
        }
        
    }
    
    func getBMIValue() -> Float {
        return bmiValue?.value ?? 0.0;
    }
    
    func getAdvise() -> String {
        return bmiValue?.advise ?? "Default Advise";
    }
    
    func getColor() -> UIColor {
        return bmiValue?.color ?? UIColor.black;
    }
}
