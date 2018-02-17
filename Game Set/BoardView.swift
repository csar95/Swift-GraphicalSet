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
        let roundedRect = UIBezierPath(roundedRect: grid[index]!, cornerRadius: grid.cellSize.height * cornerRadiusCoefficient)
        UIColor.white.setFill()
        roundedRect.fill()
        drawShapes(for: index, in: grid, repeat: Numbers.two, shape: Shapes.squiggle, with: Colors.purple)
    }
    
    private func drawShapes(for index: Int, in grid: Grid, repeat times: Numbers, shape: Shapes, with color: Colors)
    {
        let cornerOffSet = (grid.cellSize.height * cornerRadiusCoefficient) * cornerOffsetCoefficient
        let boxRect = grid[index]!.insetBy(dx: cornerOffSet, dy: cornerOffSet)
        
        switch times {
        case .one:
            if (shape == .oval) { drawOval(within: boxRect, with: color) }
            else if (shape == .diamond) { drawDiamond(within: boxRect, with: color) }
            else { drawSquiggle(within: boxRect, with: color) }
            
            break
        case .two:
            let (upperRect, lowerRect) = boxRect.divided(atDistance: boxRect.height/2, from: .minYEdge)
            
            if (shape == .oval) { drawOval(within: upperRect, with: color); drawOval(within: lowerRect, with: color) }
            else if (shape == .diamond) { drawDiamond(within: upperRect, with: color); drawDiamond(within: lowerRect, with: color) }
            else { drawSquiggle(within: upperRect, with: color); drawSquiggle(within: lowerRect, with: color) }
            
            break
        case .three:
            let (upperRect, auxRect) = boxRect.divided(atDistance: boxRect.height/3, from: .minYEdge)
            let (middleRect, lowerRect) = auxRect.divided(atDistance: auxRect.height/2, from: .minYEdge)
            
            if (shape == .oval) { drawOval(within: upperRect, with: color); drawOval(within: middleRect, with: color); drawOval(within: lowerRect, with: color) }
            else if (shape == .diamond) { drawDiamond(within: upperRect, with: color); drawDiamond(within: middleRect, with: color); drawDiamond(within: lowerRect, with: color) }
            else { drawSquiggle(within: upperRect, with: color); drawSquiggle(within: middleRect, with: color); drawSquiggle(within: lowerRect, with: color) }
            
            break
        }
    }
}



extension BoardView {
    private var cornerRadiusCoefficient: CGFloat { return 0.1 }
    private var cornerOffsetCoefficient: CGFloat { return 0.33 }
    
    private func drawOval(within rect: CGRect, with color: Colors) {
        let cornerOffSetX = rect.width * cornerOffsetCoefficient
        let cornerOffSetY = rect.height * cornerOffsetCoefficient
        let ovalRect = rect.insetBy(dx: cornerOffSetX/2, dy: cornerOffSetY/1.5)
        
        let oval = UIBezierPath(ovalIn: ovalRect)
        switch color {
        case .green:
            UIColor.green.setFill()
        case .red:
            UIColor.red.setFill()
        case .purple:
            UIColor.purple.setFill()
        }
        oval.fill()
    }
    
    private func drawDiamond(within rect: CGRect, with color: Colors) {
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint( x: rect.midX, y: rect.midY + (rect.height/3) ))
        diamond.addLine(to: CGPoint( x: rect.midX + (rect.width/3), y: rect.midY ))
        diamond.addLine(to: CGPoint( x: rect.midX, y: rect.midY - (rect.height/3) ))
        diamond.addLine(to: CGPoint( x: rect.midX - (rect.width/3), y: rect.midY ))
        diamond.close()
        
        switch color {
        case .green:
            UIColor.green.setFill()
        case .red:
            UIColor.red.setFill()
        case .purple:
            UIColor.purple.setFill()
        }
        diamond.fill()
    }
    
    private func drawSquiggle(within rect: CGRect, with color: Colors) {
        let squiggle = UIBezierPath()
        squiggle.addArc(withCenter: CGPoint(x: rect.midX - (rect.width/2)/6, y: rect.midY), radius: (rect.width/2)/6, startAngle: 0, endAngle: 3*CGFloat.pi/2, clockwise: false)
        squiggle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY - (rect.width/2)/6), radius: (rect.width/2)/6, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2, clockwise: true)
        squiggle.addArc(withCenter: CGPoint(x: rect.midX + (rect.width/2)/6, y: rect.midY), radius: (rect.width/2)/6, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2, clockwise: false)
        squiggle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY + (rect.width/2)/6), radius: (rect.width/2)/6, startAngle: 0, endAngle: 3*CGFloat.pi/2, clockwise: true)
        squiggle.close()
        
        switch color {
        case .green:
            UIColor.green.setFill()
        case .red:
            UIColor.red.setFill()
        case .purple:
            UIColor.purple.setFill()
        }
        squiggle.fill()
    }
}
