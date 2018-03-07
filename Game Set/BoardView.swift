//
//  BoardView.swift
//  Game Set
//
//  Created by Cesar Gutierrez Carrero on 14/2/18.
//  Copyright © 2018 Cesar Gutierrez Carrero. All rights reserved.
//

import Foundation
import UIKit

protocol LayoutViews: class {
    func updateViewFromModel()
}

class BoardView: UIView {
        
    weak var delegate: LayoutViews?

    override func layoutSubviews() {
        super.layoutSubviews()
        delegate?.updateViewFromModel()
    }
    
}
