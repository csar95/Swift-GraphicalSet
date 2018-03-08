//
//  ViewController.swift
//  Game Set
//
//  Created by Cesar Gutierrez Carrero on 26/1/18.
//  Copyright © 2018 Cesar Gutierrez Carrero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boardView: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDownGesture))
            swipe.direction = [.down]
            boardView.addGestureRecognizer(swipe)
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(onRotateGesture))
            boardView.addGestureRecognizer(rotate)
        }
    }
    private var grid : Grid!
    private var cardsInBoard = [CardView]()
    private var game : SetModel!
    
    private var iPhoneTimer: Timer!
    private var iPhonePoints = 0
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var playIPhoneButton: UIButton!
    @IBOutlet weak var cheatButton: UIButton!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsIPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameButton.layer.cornerRadius = 15
        playIPhoneButton.layer.cornerRadius = 15
        cheatButton.layer.cornerRadius = 15
        
        pointsIPhoneLabel.isHidden = true
        
        game = SetModel()
        updateViewFromModel()
    }
    
    @IBAction func cheat(_ sender: UIButton) {
        if let indecesOfSets = game.getIndecesOfSets() {
            for index in indecesOfSets[0] {
                game.board[index].formASet = true
            }
        }
        else {
            print("There are no sets on board")
        }
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
        iPhoneTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(5.arc4random + 20), repeats: true, block: { _ in
            self.playIPhone()
            self.boardView.subviews.forEach({ $0.removeFromSuperview() })
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
    
    @objc func onSwipeDownGesture() {
        game.add3MoreCards()
        boardView.subviews.forEach({ $0.removeFromSuperview() })
        updateViewFromModel()
    }
    
    @objc func onRotateGesture() {
        game.reshuffleBoard()
        boardView.subviews.forEach({ $0.removeFromSuperview() })
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        reloadBoard()
        
        pointsLabel.text = "Points: \(game.points)"
        pointsIPhoneLabel.text = "iPhone: \(iPhonePoints)"
    }
    
    
    private func reloadBoard()
    {
        cardsInBoard.removeAll()

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
        
            cardsInBoard.append(cardButton)
        
            boardView.addSubview(cardButton)
            game.board[index].formASet = false
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
