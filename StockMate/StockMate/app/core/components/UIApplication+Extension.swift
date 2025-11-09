//
//  UIApplication+Extension.swift
//  StockMate
//
//  Created by Admin on 11/9/25.
//

import SwiftUI

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
