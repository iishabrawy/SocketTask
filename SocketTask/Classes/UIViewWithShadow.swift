//
//  UIViewWithShadow.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 23/12/2020.
//

import Foundation
import UIKit

class UIViewWithShadow: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        
//        self.backgroundColor = UIColor(named: "whiteColor")
        self.layer.masksToBounds = false
    }
}
