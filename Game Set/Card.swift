//
//  Card.swift
//  Game Set
//
//  Created by Cesar Gutierrez Carrero on 26/1/18.
//  Copyright © 2018 Cesar Gutierrez Carrero. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int { return self.identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color && lhs.shape == rhs.shape && lhs.shade == rhs.shade && lhs.times == rhs.times
    }
    
    private var identifier: Int
    
    let color: Colors
    let shape: Shapes
    let times: Numbers
    let shade: Shading
    
    let content: NSAttributedString
    
    var isMatched = false
    
    init(content: NSAttributedString, color: Colors, shape: Shapes, times: Numbers, shade: Shading)
    {
        self.content = content
        self.color = color
        self.shape = shape
        self.times = times
        self.shade = shade
        
        self.identifier = Card.getUniqueIdentifier()
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int
    {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }
    
}
