//
//  ObservableExtensions.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

extension UILabel: Bindable {
    func boundValueChanged(_ value: String?) {
        self.text = value
        self.accessibilityValue = value
    }
}
extension UIImageView: Bindable { func boundValueChanged(_ value: UIImage?) { self.image = value } }


