//
//  SetModel.swift
//  Game Set
//
//  Created by Cesar Gutierrez Carrero on 26/1/18.
//  Copyright © 2018 Cesar Gutierrez Carrero. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit.GKRandomSource

protocol CheckFeaturesProtocol {
    func checkForColor(in selectedCards: [Card]) -> Bool
    func checkForShape(in selectedCards: [Card]) -> Bool
    func checkForShade(in selectedCards: [Card]) -> Bool
    func checkForTime(in selectedCards: [Card]) -> Bool
}

class SetModel {
    
    var points = 0
    //private(set) var cardsBeingPlayed = [Card]()
    private(set) var selectedCards = [Card]()
    var deck = [Card]()
    
    var board = [Card?]()
        
    init() {
        generateDeck()
        
        // Shuffle cards
        deck = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: deck) as! [Card]
        
        // Initialize board with 12 cards
        for i in 0..<24 {
            i < 12 ? addCardToBoard(at: nil) : board.append(nil)
        }
    }
    
    func chooseCard(at index: Int) {
        
        if let chosenCard = board[index] {
            // If chosen card is not currently selected
            if (!selectedCards.contains(chosenCard)) {
                selectedCards.append(chosenCard)
                
                if (selectedCards.count == 3) {
                    // Check if selected cards form a set
                    if checkSet(in: selectedCards) {
                        if !deck.isEmpty {
                            if (countOfNotNil(in: board) > 12) {
                                // Remove cards that form set
                                for card in selectedCards {
                                    if let index = getIndexOnBoard(of: card) {
                                        board[index] = nil
                                    }
                                    else {
                                        print("ERROR: Selected card not found in board")
                                    }
                                }
                            }
                            else {
                                // Subtitute cards in set for new ones from the deck
                                for card in selectedCards {
                                    if let index = getIndexOnBoard(of: card) {
                                        addCardToBoard(at: index)
                                    }
                                    else {
                                        print("ERROR: Selected card not found in board")
                                    }
                                }
                            }
                        }
                        // If deck is empty
                        else {
                            // Remove cards that form set
                            for card in selectedCards {
                                if let index = getIndexOnBoard(of: card) {
                                    board[index] = nil
                                }
                                else {
                                    print("ERROR: Selected card not found in board")
                                }
                            }
                            if lookForSetsOnBoard().count == 0 {
                                print("GAME OVER!")
                            }
                        }
                        points += 3
                    }
                    else {
                        points -= 3
                    }
                    // Clear list of selected cards
                    selectedCards.removeAll()
                }
            }
            // If chosen card is already selected, deselect it
            else {
                selectedCards.remove( at: selectedCards.index(of: chosenCard)! )
                points -= 1
            }
        }
    }
    
    func getIndecesOfSets () -> [[Int]]? {
        let setsOnBoard = lookForSetsOnBoard()
        
        var indecesOfSets = [[Int]]()
        // In case there is a set
        if setsOnBoard.count > 0 {
            for set in setsOnBoard {
                var indeces = [Int]()
                for card in set {
                    indeces.append(getIndexOnBoard(of: card)!)
                }
                indecesOfSets.append(indeces)
            }
        }
        return indecesOfSets.count > 0 ? indecesOfSets : nil
    }
    
    private func lookForSetsOnBoard () -> [[Card]] {
        let allCombosOfCards = getAllCombos(from: board)
        
        var setsOnBoard = [[Card]]()
        for combo in allCombosOfCards
        {
            if checkSet(in: combo) {
                setsOnBoard.append(combo)
            }
        }
        return setsOnBoard
    }
    
    func add3MoreCards () {
        // Penalize pressing "3 More Cards" if there is a set available in the visible cards
        if lookForSetsOnBoard().count != 0 {
            points -= 5
        }
        if (countOfNotNil(in: board) < 24 && !deck.isEmpty) {
            var numberOfCardsToAdd = 3
            for index in 0..<board.count {
                if (board[index] == nil && numberOfCardsToAdd > 0) {
                    addCardToBoard(at: index)
                    numberOfCardsToAdd -= 1
                }
            }
        }
    }
    
    func reset () {
        board = [Card?]()
        selectedCards = [Card]()
        deck = [Card]()
        points = 0
        
        generateDeck()
        
        // Shuffle cards
        deck = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: deck) as! [Card]
        
        // Initialize board with 12 cards
        for i in 0..<24 {
            i < 12 ? addCardToBoard(at: nil) : board.append(nil)
        }
    }
    
    func countOfNotNil (in array: [Card?]) -> Int {
        var count = 0
        for i in 0..<array.count {
            if let _ = array[i] { count += 1 }
        }
        return count
    }
    
    private func checkSet(in cards: [Card]) -> Bool{
        return checkForColor(in: cards) && checkForShape(in: cards) && checkForShade(in: cards) && checkForTime(in: cards)
    }
    
    private func getIndexOnBoard(of card: Card) -> Int? {
        for index in 0..<board.count {
            if (board[index] != nil && board[index] == card) {
                return index
            }
        }
        return nil
    }
    
    func addCardToBoard (at index: Int?) {
        // Take random card from deck and put it on the board
        let randomIndex = deck.count.arc4random
        let randomCard = deck.remove(at: randomIndex)
        
        if let i = index {
            board[i] = randomCard
        }
        else {
            board.append(randomCard)
        }
    }
    
    // This function generates all possible combinations
    private func generateDeck() {
        let shapes = ["●", "■", "▲"] // circle, square, triangle
        let colors = [UIColor.green, UIColor.red, UIColor.blue] // green, red, blue
        let shading = [[-5.0, 1.0], [-5.0, 0.15], [5.0, 1.0]] // solid, striped, open
        
        for shape in shapes {
            for color in colors {
                for times in 1...3 {
                    for shade in shading {
                        
                        let attributes: [NSAttributedStringKey : Any] = [
                            .strokeWidth : shade[0],
                            .foregroundColor : color.withAlphaComponent(CGFloat(shade[1]))
                        ]
                        let attributedString = NSMutableAttributedString(string: shape, attributes: attributes)
                        
                        for _ in 1..<times {
                            attributedString.append( NSAttributedString(string: shape, attributes: attributes) )
                        }
                        addCardToDeck(color: color, shape: shape, shade0: shade[0], shade1: shade[1], times: times, attrString: attributedString)
                    }
                }
            }
        }
    }
    
    private func addCardToDeck(color: UIColor, shape: String, shade0: Double, shade1: Double, times: Int, attrString: NSAttributedString) {
        
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
        let card = Card(content: attrString, color: c, shape: sp, times: t, shade: sd)
        deck.append(card)
    }
    
    private func getAllCombos(from board: [Card?]) -> [[Card]] {
        // Get cards on board
        var cardsBeingPlayed = [Card]()
        for i in board.indices {
            if let card = board[i] {
                cardsBeingPlayed.append(card)
            }
        }
        
        var indices = [Int]()
        for pos in 0..<cardsBeingPlayed.count {
            indices.append(pos)
        }
        
        let combosOfIndeces = indices.getCombinationsWithoutRepetition(of: 3)
        
        var allCombosOfCards = [[Card]]()
        for combo in combosOfIndeces
        {
            var comboOfCards = [Card]()
            for index in combo {
                comboOfCards.append(cardsBeingPlayed[index])
            }
            allCombosOfCards.append(comboOfCards)
        }
        
        return allCombosOfCards
    }
    
    // It probably wants to keep track of which cards have already been matched.
}



/******************************************/
/*  IMPLEMENTING CHECK FEATURES PROTOCOL  */
/******************************************/

extension SetModel: CheckFeaturesProtocol {
    func checkForColor (in selectedCards: [Card]) -> Bool {
        if (selectedCards[0].color == selectedCards[1].color && selectedCards[0].color == selectedCards[2].color && selectedCards[1].color == selectedCards[2].color) {
            return true
        }
        else if (selectedCards[0].color != selectedCards[1].color && selectedCards[0].color != selectedCards[2].color && selectedCards[1].color != selectedCards[2].color){
            return true
        }
        else {
            return false
        }
    }
    
    func checkForShape (in selectedCards: [Card]) -> Bool {
        if (selectedCards[0].shape == selectedCards[1].shape && selectedCards[0].shape == selectedCards[2].shape && selectedCards[1].shape == selectedCards[2].shape) {
            return true
        }
        else if (selectedCards[0].shape != selectedCards[1].shape && selectedCards[0].shape != selectedCards[2].shape && selectedCards[1].shape != selectedCards[2].shape){
            return true
        }
        else {
            return false
        }
    }
    
    func checkForShade (in selectedCards: [Card]) -> Bool {
        if (selectedCards[0].shade == selectedCards[1].shade && selectedCards[0].shade == selectedCards[2].shade && selectedCards[1].shade == selectedCards[2].shade) {
            return true
        }
        else if (selectedCards[0].shade != selectedCards[1].shade && selectedCards[0].shade != selectedCards[2].shade && selectedCards[1].shade != selectedCards[2].shade){
            return true
        }
        else {
            return false
        }
    }
    
    func checkForTime (in selectedCards: [Card]) -> Bool {
        if (selectedCards[0].times == selectedCards[1].times && selectedCards[0].times == selectedCards[2].times && selectedCards[1].times == selectedCards[2].times) {
            return true
        }
        else if (selectedCards[0].times != selectedCards[1].times && selectedCards[0].times != selectedCards[2].times && selectedCards[1].times != selectedCards[2].times){
            return true
        }
        else {
            return false
        }
    }
}

extension Array where Element == Int {
    
    func getCombinationsWithoutRepetition(of length: Int) -> [[Element]] {
        
        let size = self.count
        var auxList = [[Element]]()
        var auxList2 = [[Element]]()
        for pos in 0..<size-1 {
            auxList.append([pos])
        }

        for time in 1...length-1 {
            // If time is odd
            if (time % 2 != 0)
            {
                auxList2.removeAll()
                for i in 0..<auxList.count
                {
                    if (auxList[i].last != size-1)
                    {
                        var aux = [Element]()
                        for j in (auxList[i].last!+1)..<size
                        {
                            for elem in auxList[i] {
                                aux.append(elem)
                            }
                            aux.append(j)
                            auxList2.append(aux)
                            aux.removeAll()
                        }
                    }
                }
            }
            // If time is even
            else
            {
                auxList.removeAll()
                for i in 0..<auxList2.count
                {
                    if (auxList2[i].last != size-1)
                    {
                        var aux = [Element]()
                        for j in (auxList2[i].last!+1)..<size
                        {
                            for elem in auxList2[i] {
                                aux.append(elem)
                            }
                            aux.append(j)
                            auxList.append(aux)
                            aux.removeAll()
                        }
                    }
                }
            }
        }
        
        if (length % 2 == 0) {
            return auxList2
        }
        else {
            return auxList
        }
    }
    
}
