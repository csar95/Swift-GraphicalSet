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
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsIPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameButton.layer.cornerRadius = 15
        playIPhoneButton.layer.cornerRadius = 15
        dealMoreCardsButton.layer.cornerRadius = 15
        cheatButton.layer.cornerRadius = 15
        
        pointsIPhoneLabel.isHidden = true
        
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
        updateViewFromModel()
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        if let _ = iPhoneTimer {
            iPhoneTimer.invalidate()
        }
        pointsIPhoneLabel.isHidden = true
        game.reset()
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
            if !self.game.deck.isEmpty {
                if (self.game.countOfNotNil(in: self.game.board) > 12) {
                    // Remove cards that form set
                    for index in setsOnBoard[randomSet]{
                        self.game.board[index] = nil
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
                    self.game.board[index] = nil
                }
            }
        }
        iPhonePoints += 3
    }
    
    private func updateViewFromModel() {
        for index in 0..<game.board.count {
            // If there is card in that position
            if game.board[index] == nil {
                cardButtons[index].layer.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
                cardButtons[index].layer.borderWidth = 0
                cardButtons[index].setAttributedTitle(nil, for: UIControlState.normal)
            }
            else {
                cardButtons[index].layer.cornerRadius = 7
                cardButtons[index].layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                if ( game.selectedCards.contains(game.board[index]!) ) {
                    // If card is selected
                    cardButtons[index].layer.borderWidth = 3.0
                    cardButtons[index].layer.borderColor = UIColor.yellow.cgColor
                }
                else {
                    cardButtons[index].layer.borderWidth = 0
                    cardButtons[index].setAttributedTitle(game.board[index]!.content, for: UIControlState.normal)
                }
            }
        }
        
        if (game.deck.count > 0 && game.countOfNotNil(in: game.board) < 24) {
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
