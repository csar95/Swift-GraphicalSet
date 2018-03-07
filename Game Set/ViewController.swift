//
//  ViewController.swift
//  Game Set
//
//  Created by Cesar Gutierrez Carrero on 26/1/18.
//  Copyright © 2018 Cesar Gutierrez Carrero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var game: SetModel = SetModel()

    private var iPhoneTimer: Timer!
    private var iPhonePoints = 0
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var playIPhoneButton: UIButton!
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBOutlet weak var cheatButton: UIButton!
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsIPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameButton.layer.cornerRadius = 15
        playIPhoneButton.layer.cornerRadius = 15
        dealMoreCardsButton.layer.cornerRadius = 15
        cheatButton.layer.cornerRadius = 15
        
        pointsIPhoneLabel.isHidden = true
        
        boardView.game = game
        boardView.board = game.board
        
        updateViewFromModel()
    }

    @IBAction func touchCard(_ sender: UIButton) {
        
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
        else {
            print("Chosen card is not in cardButtons")
        }
    }
    
    @IBAction func cheat(_ sender: UIButton) {
        if let indecesOfSets = game.getIndecesOfSets() {
            for index in indecesOfSets[0]
            {
                cardButtons[index].layer.borderWidth = 3.0
                cardButtons[index].layer.borderColor = UIColor.red.cgColor
            }
        }
        else {
            print("There are no sets on board")
        }
    }
    
    @IBAction func addMoreCards(_ sender: UIButton) {
        game.add3MoreCards()
        
        boardView.board = game.board
        updateViewFromModel()
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        if let _ = iPhoneTimer {
            iPhoneTimer.invalidate()
        }
        pointsIPhoneLabel.isHidden = true
        game.reset()
        
        boardView.board = game.board
        updateViewFromModel()
    }
    
    @IBAction func playAgainstIPhone(_ sender: UIButton) {
        game.reset()
        iPhonePoints = 0
        pointsIPhoneLabel.isHidden = false
        updateViewFromModel()
        iPhoneTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(30.arc4random + 20), repeats: true, block: { _ in
            self.playIPhone()
            self.updateViewFromModel()
        })
    }
    
    private func playIPhone() {
        if let setsOnBoard = self.game.getIndecesOfSets()
        {
            let randomSet = setsOnBoard.count.arc4random
            if !self.game.deck.cardsInDeck.isEmpty {
                if (self.game.board.count > 12) {
                    // Remove cards that form set
                    for index in setsOnBoard[randomSet]{
                        self.game.board.remove(at: index)
                    }
                }
                else {
                    for index in setsOnBoard[randomSet]{
                        // Subtitute cards in set for new ones from the deck
                        self.game.addCardToBoard(at: index)
                    }
                }
            }
                // If deck is empty
            else {
                // Remove cards that form set
                for index in setsOnBoard[randomSet]{
                    self.game.board.remove(at: index)
                }
            }
        }
        iPhonePoints += 3
    }
    
    private func updateViewFromModel() {
        if (game.deck.cardsInDeck.count > 0) {
            dealMoreCardsButton.isEnabled = true
        }
        else {
            dealMoreCardsButton.isEnabled = false
        }
        
        pointsLabel.text = "Points: \(game.points)"
        pointsIPhoneLabel.text = "iPhone: \(iPhonePoints)"
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
    }
}
