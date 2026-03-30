//
//  Double.swift
//  Crypto
//
//  Created by Nafea Elkassas on 22/03/2026.
//

import Foundation
extension Double {
    
    // regarding making the number formatted as a 6 digits number
    // first making the formatter that has properties we need for the desired number
    // بيخلي اقل رقم بعد الكسر ٢ واقصى رقم ٦ وده كله في حالة انه بعد الكسر
    private var currencyFormatter6: NumberFormatter {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
        
    }
    
    private var currencyFormatter2: NumberFormatter {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
        
    }
    
       //MARK: - Behaviour
    
    func asCurrencyWithDecimals(num: Int) -> String {
        let number = NSNumber(value: self)
        if num == 6 {
            return currencyFormatter6.string(from: number) ?? "$0.00"
        } else {
            return currencyFormatter2.string(from: number) ?? "$0.00"
        }
    }
    

    
    func asNumberString() -> String {
     return String(format: "%.2f", self)
    }
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    
}
