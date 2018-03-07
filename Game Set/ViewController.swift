//
//  ViewController.swift
//  Game Set
//
//  Created by Cesar Gutierrez Carrero on 26/1/18.
//  Copyright © 2018 Cesar Gutierrez Carrero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boardView: UIView!
    private var grid : Grid!
    private var cardsInBoard = [CardView]()
    private var game : SetModel!
    
    private var iPhoneTimer: Timer!
    private var iPhonePoints = 0
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var playIPhoneButton: UIButton!
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBOutlet weak var cheatButton: UIButton!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsIPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameButton.layer.cornerRadius = 15
        playIPhoneButton.layer.cornerRadius = 15
        dealMoreCardsButton.layer.cornerRadius = 15
        cheatButton.layer.cornerRadius = 15
        
        pointsIPhoneLabel.isHidden = true
        
        game = SetModel()
        updateViewFromModel()
    }
    
    @IBAction func cheat(_ sender: UIButton) {
        if let indecesOfSets = game.getIndecesOfSets() {
            for index in indecesOfSets[0]
            {
//                cardButtons[index].layer.borderWidth = 3.0
//                cardButtons[index].layer.borderColor = UIColor.red.cgColor
            }
        }
        else {
            print("There are no sets on board")
        }
    }
    
    @IBAction func addMoreCards(_ sender: UIButton) {
        game.add3MoreCards()
        boardView.subviews.forEach({ $0.removeFromSuperview() })
        updateViewFromModel()
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        if let _ = iPhoneTimer {
            iPhoneTimer.invalidate()
        }
        pointsIPhoneLabel.isHidden = true
        game.reset()
        boardView.subviews.forEach({ $0.removeFromSuperview() })
        updateViewFromModel()
    }
    
    @IBAction func playAgainstIPhone(_ sender: UIButton) {
        game.reset()
        boardView.subviews.forEach({ $0.removeFromSuperview() })
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
    
    @objc func onCardTapGesture(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let card = sender.view as! CardView
            var cardIndex = 0
            
            for index in 0..<cardsInBoard.count {
                if (card.card == cardsInBoard[index].card) {
                    cardIndex = index
                }
            }
            game.chooseCard(at: cardIndex)
            boardView.subviews.forEach({ $0.removeFromSuperview() })
            updateViewFromModel()
        default:
            break
        }
    }
    
    private func updateViewFromModel() {
        reloadBoard()
        
        if (game.deck.cardsInDeck.count > 0) {
            dealMoreCardsButton.isEnabled = true
        }
        else {
            dealMoreCardsButton.isEnabled = false
        }
        
        pointsLabel.text = "Points: \(game.points)"
        pointsIPhoneLabel.text = "iPhone: \(iPhonePoints)"
    }
    
    
    private func reloadBoard() {
        grid = Grid(layout: .aspectRatio(0.75), frame: boardView.bounds)
        grid.cellCount = game.board.count
        
        for index in 0..<game.board.count
        {
            let cardButton = CardView()
            cardButton.frame = grid[index]!
            cardButton.card = game.board[index]
            cardButton.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            
            let tap = UITapGestureRecognizer( target: self, action: #selector(onCardTapGesture) )
            cardButton.addGestureRecognizer(tap)
            
            if (index < cardsInBoard.count) {
                cardsInBoard[index] = cardButton
            }
            else {
                cardsInBoard.append(cardButton)
            }
            boardView.addSubview(cardButton)
        }
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
