//
//  Validators.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
}

func isValidPassword(_ pw: String) -> Bool {
    guard pw.count >= 8 else { return false }
    return pw.range(of: "[A-Za-z]", options: .regularExpression) != nil &&
    pw.range(of: "[0-9]", options: .regularExpression) != nil
}

func isValidBizNo(_ no: String) -> Bool {
    let regex = "^\\d{3}-\\d{2}-\\d{5}$"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: no)
}
