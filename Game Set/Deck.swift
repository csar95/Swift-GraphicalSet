//
//  Deck.swift
//  Game Set
//
//  Created by Cesar Gutierrez Carrero on 20/2/18.
//  Copyright © 2018 Cesar Gutierrez Carrero. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit.GKRandomSource

struct Deck {
    
    var cardsInDeck = [Card]()
    
    init() {
        generateDeck()
        
        // Shuffle cards
        cardsInDeck = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cardsInDeck) as! [Card]
    }
    
    // This function generates all possible combinations
    private mutating func generateDeck() {
        let shapes = ["●", "■", "▲"] // circle, square, triangle
        let colors = [UIColor.green, UIColor.red, UIColor.blue] // green, red, blue
        let shading = [[-5.0, 1.0], [-5.0, 0.15], [5.0, 1.0]] // solid, striped, open
        
        for shape in shapes {
            for color in colors {
                for times in 1...3 {
                    for shade in shading {
                        addCardToDeck(color: color, shape: shape, shade0: shade[0], shade1: shade[1], times: times)
                    }
                }
            }
        }
    }
    
    private mutating func addCardToDeck(color: UIColor, shape: String, shade0: Double, shade1: Double, times: Int) {
        
        var c = Colors.green, sp = Shapes.oval, t = Numbers.one, sd = Shading.open
        
        switch color{
        case UIColor.green: c = Colors.green
        case UIColor.red: c = Colors.red
        case UIColor.blue: c = Colors.purple
        default: break
        }
        switch shape{
        case "●": sp = Shapes.oval
        case "■": sp = Shapes.diamond
        case "▲": sp = Shapes.squiggle
        default: break
        }
        switch shade0{
        case -5.0:
            if (shade1 == 1.0) {
                sd = Shading.solid
            }
            else {
                sd = Shading.striped
            }
        case 5.0: sd = Shading.open
        default: break
        }
        switch times{
        case 1: t = Numbers.one
        case 2: t = Numbers.two
        case 3: t = Numbers.three
        default: break
        }
        
        // Create card with certain features and add it to the deck
        let card = Card(color: c, shape: sp, times: t, shade: sd)
        cardsInDeck.append(card)
    }
}
