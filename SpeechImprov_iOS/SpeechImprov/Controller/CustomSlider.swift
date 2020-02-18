//
//  CustomSlider.swift
//  SpeechImprov
//
//  Created by Simone Karani on 2/17/20.
//  Copyright © 2020 SpeechAnalyzer. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    
    var sliderIdentifier: Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        sliderIdentifier = 0
    }
    
}
