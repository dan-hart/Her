//
//  UIApplication+endEditing.swift
//
//  Created by Dan Hart on 4/8/22.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
