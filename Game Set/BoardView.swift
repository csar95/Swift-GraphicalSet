//
//  BoardView.swift
//  Game Set
//
//  Created by Cesar Gutierrez Carrero on 14/2/18.
//  Copyright © 2018 Cesar Gutierrez Carrero. All rights reserved.
//

import Foundation
import UIKit

class BoardView: UIView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        var grid = Grid(layout: .aspectRatio(0.75), frame: bounds)
        grid.cellCount = 12
        
        for index in 0..<grid.cellCount {
            drawCard(with: index, in: grid)
        }
    }
    
    func drawCard(with index: Int, in grid: Grid) {
        let roundedRect = UIBezierPath(roundedRect: grid[index]!, cornerRadius: grid.cellSize.height * 0.1)
        UIColor.white.setFill()
        roundedRect.fill()
    }
}
