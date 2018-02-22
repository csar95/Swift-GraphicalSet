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
    var deck = Deck()
    
    var board = [Card]()
        
    init() {
        // Initialize board with 12 cards
        for _ in 0..<12 {
            addCardToBoard(at: nil)
        }
    }
    
    func chooseCard(at index: Int) {
        
        let chosenCard = board[index]
        
        // If chosen card is not currently selected
        if (!selectedCards.contains(chosenCard)) {
            selectedCards.append(chosenCard)
            
            if (selectedCards.count == 3) {
                // Check if selected cards form a set
                if checkSet(in: selectedCards) {
                    if !deck.cardsInDeck.isEmpty {
                        if (board.count > 12) {
                            // Remove cards that form set
                            for card in selectedCards {
                                if let index = getIndexOnBoard(of: card) {
                                    board.remove(at: index)
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
                                board.remove(at: index)
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
        if (!deck.cardsInDeck.isEmpty) {
            for _ in 1...3 {
                addCardToBoard(at: nil)
            }
        }
    }
    
    func reset () {
        deck = Deck()
        board = [Card]()
        selectedCards = [Card]()
        points = 0
        
        // Initialize board with 12 cards
        for _ in 0..<12 {
            addCardToBoard(at: nil)
        }
    }
    
    private func checkSet(in cards: [Card]) -> Bool{
        return checkForColor(in: cards) && checkForShape(in: cards) && checkForShade(in: cards) && checkForTime(in: cards)
    }
    
    private func getIndexOnBoard(of card: Card) -> Int? {
        for index in 0..<board.count {
            if (board[index] == card) {
                return index
            }
        }
        return nil
    }
    
    func addCardToBoard (at index: Int?) {
        // Take random card from deck and put it on the board
        let randomIndex = deck.cardsInDeck.count.arc4random
        let randomCard = deck.cardsInDeck.remove(at: randomIndex)
        
        if let i = index {
            board[i] = randomCard
        }
        else {
            board.append(randomCard)
        }
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
