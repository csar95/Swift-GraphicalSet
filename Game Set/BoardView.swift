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
    
    var board : [Card] = [] {
        didSet {
            draw(bounds)
            setNeedsDisplay(); setNeedsLayout()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        var grid = Grid(layout: .aspectRatio(0.75), frame: bounds)
        grid.cellCount = board.count
        
        for index in 0..<grid.cellCount {
            let card = board[index]
            drawCard(with: index, in: grid, repeat: card.times, shape: card.shape, with: card.color, shade: card.shade)
        }
    }
    
    func drawCard(with index: Int, in grid: Grid, repeat times: Numbers, shape: Shapes, with color: Colors, shade: Shading) {
        let roundedRect = UIBezierPath(roundedRect: grid[index]!, cornerRadius: grid.cellSize.height * cornerRadiusCoefficient)
        UIColor.white.setFill()
        roundedRect.fill()
        drawShapes(for: index, in: grid, repeat: times, shape: shape, with: color, shade: shade)
    }
    
    private func drawShapes(for index: Int, in grid: Grid, repeat times: Numbers, shape: Shapes, with color: Colors, shade: Shading)
    {
        let cornerOffSet = (grid.cellSize.height * cornerRadiusCoefficient) * cornerOffsetCoefficient
        let boxRect = grid[index]!.insetBy(dx: cornerOffSet, dy: cornerOffSet)
        
        switch times {
        case .one:
            let (_, auxRect) = boxRect.divided(atDistance: boxRect.height/3, from: .minYEdge)
            let (middleRect, _) = auxRect.divided(atDistance: auxRect.height/2, from: .minYEdge)
            
            if (shape == .oval) { drawOval(within: middleRect, with: color, shade: shade) }
            else if (shape == .diamond) { drawDiamond(within: middleRect, with: color, shade: shade) }
            else { drawSquiggle(within: middleRect, with: color, shade: shade) }
            
            break
        case .two:
            let (upperRect, auxRect) = boxRect.divided(atDistance: boxRect.height/3, from: .minYEdge)
            let (_, lowerRect) = auxRect.divided(atDistance: auxRect.height/2, from: .minYEdge)
            
            if (shape == .oval) { drawOval(within: upperRect, with: color, shade: shade); drawOval(within: lowerRect, with: color, shade: shade) }
            else if (shape == .diamond) { drawDiamond(within: upperRect, with: color, shade: shade); drawDiamond(within: lowerRect, with: color, shade: shade) }
            else { drawSquiggle(within: upperRect, with: color, shade: shade); drawSquiggle(within: lowerRect, with: color, shade: shade) }
            
            break
        case .three:
            let (upperRect, auxRect) = boxRect.divided(atDistance: boxRect.height/3, from: .minYEdge)
            let (middleRect, lowerRect) = auxRect.divided(atDistance: auxRect.height/2, from: .minYEdge)
            
            if (shape == .oval) { drawOval(within: upperRect, with: color, shade: shade); drawOval(within: middleRect, with: color, shade: shade); drawOval(within: lowerRect, with: color, shade: shade) }
            else if (shape == .diamond) { drawDiamond(within: upperRect, with: color, shade: shade); drawDiamond(within: middleRect, with: color, shade: shade); drawDiamond(within: lowerRect, with: color, shade: shade) }
            else { drawSquiggle(within: upperRect, with: color, shade: shade); drawSquiggle(within: middleRect, with: color, shade: shade); drawSquiggle(within: lowerRect, with: color, shade: shade) }
            
            break
        }
    }
}



extension BoardView {
    private var cornerRadiusCoefficient: CGFloat { return 0.1 }
    private var cornerOffsetCoefficient: CGFloat { return 0.33 }
    
    private func drawOval(within rect: CGRect, with color: Colors, shade: Shading) {
        let cornerOffSetX = rect.width * cornerOffsetCoefficient
        let cornerOffSetY = rect.height * cornerOffsetCoefficient
        let ovalRect = rect.insetBy(dx: cornerOffSetX/2, dy: cornerOffSetY/1.5)
        
        let oval = UIBezierPath(ovalIn: ovalRect)
        
        drawInside(of: oval, within: rect, with: color, shade: shade)
    }
    
    private func drawDiamond(within rect: CGRect, with color: Colors, shade: Shading) {
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint( x: rect.midX, y: rect.midY + (rect.height/3) ))
        diamond.addLine(to: CGPoint( x: rect.midX + (rect.width/3), y: rect.midY ))
        diamond.addLine(to: CGPoint( x: rect.midX, y: rect.midY - (rect.height/3) ))
        diamond.addLine(to: CGPoint( x: rect.midX - (rect.width/3), y: rect.midY ))
        diamond.close()
        
        drawInside(of: diamond, within: rect, with: color, shade: shade)
    }
    
    private func drawSquiggle(within rect: CGRect, with color: Colors, shade: Shading) {
        let squiggle = UIBezierPath()
        squiggle.addArc(withCenter: CGPoint(x: rect.midX - (rect.width/2)/6, y: rect.midY), radius: (rect.width/2)/6, startAngle: 0, endAngle: 3*CGFloat.pi/2, clockwise: false)
        squiggle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY - (rect.width/2)/6), radius: (rect.width/2)/6, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2, clockwise: true)
        squiggle.addArc(withCenter: CGPoint(x: rect.midX + (rect.width/2)/6, y: rect.midY), radius: (rect.width/2)/6, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2, clockwise: false)
        squiggle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY + (rect.width/2)/6), radius: (rect.width/2)/6, startAngle: 0, endAngle: 3*CGFloat.pi/2, clockwise: true)
        squiggle.close()
        
        drawInside(of: squiggle, within: rect, with: color, shade: shade)
    }
    
    private func drawInside(of path: UIBezierPath, within rect: CGRect, with color: Colors, shade: Shading) {
        if (shade == Shading.open) {
            switch color {
            case .green:
                UIColor.green.setStroke()
            case .red:
                UIColor.red.setStroke()
            case .purple:
                UIColor.purple.setStroke()
            }
            path.stroke()
        }
        else if (shade == Shading.solid) {
            switch color {
            case .green:
                UIColor.green.setFill()
            case .red:
                UIColor.red.setFill()
            case .purple:
                UIColor.purple.setFill()
            }
            path.fill()
        }
        else {
            // Saves the entire graphics state (including the clipping) at the time you call it
            UIGraphicsGetCurrentContext()?.saveGState()
            path.addClip()
            switch color {
            case .green:
                UIColor.green.setStroke()
            case .red:
                UIColor.red.setStroke()
            case .purple:
                UIColor.purple.setStroke()
            }
            drawStripes(in: rect)
            path.stroke()
            // Returns back to that saved graphics state
            UIGraphicsGetCurrentContext()?.restoreGState()
        }
    }
    
    private func drawStripes(in rect: CGRect) {
        let numberOfStripes = 15
        let path = UIBezierPath()
        
        let step = Int(rect.width)/numberOfStripes
        
        for stripe in 1...numberOfStripes {
            path.move(to: CGPoint(x: rect.minX + CGFloat(step*stripe), y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + CGFloat(step*stripe), y: rect.maxY))
        }
        path.stroke()
    }
}
