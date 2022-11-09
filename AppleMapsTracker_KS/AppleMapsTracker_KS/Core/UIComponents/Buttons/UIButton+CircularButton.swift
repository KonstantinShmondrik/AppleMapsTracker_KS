//
//  CircularButton.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 07.11.2022.
//

import UIKit

class CircularButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = self.frame.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white.withAlphaComponent(0.85)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.cornerRadius = self.frame.width / 2
    }
}
