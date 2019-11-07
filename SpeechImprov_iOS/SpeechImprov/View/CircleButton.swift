//
//  CircleButton.swift
//  SpeechImprov
//
//  Created by Simone Karani on 11/3/19.
//  Copyright © 2019 SpeechAnalyzer. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet {
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
    }
}
