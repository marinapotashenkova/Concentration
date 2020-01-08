//
//  ViewController.swift
//  Concentration
//
//  Created by Марина on 25.12.2019.
//  Copyright © 2019 Marina Potashenkova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game: Concentration!
    
    var numberOfPairsOfCards: Int  {
        return (cardButtons.count + 1) / 2
    }
    
    var theme: String!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!

    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("choosen card was not in cardButton")
        }
    }
    
    @IBAction private func startNewGame(_ sender: UIButton) {
        initialSetup()
    }
    
    private func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                 button.setTitle(emoji(for: card), for: .normal)
                 button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private func initialSetup() {
        let themes = Array(emojiThemes.keys)
        theme = themes[Int(arc4random_uniform(UInt32(themes.count)))]
        emojiChoices = emojiThemes[theme] ?? []
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
    }
    
    private let emojiThemes = [
        "halloween" : ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"],
        "animals" : ["🐶", "🐱", "🐭", "🐰", "🦊", "🐻", "🦄", "🦁", "🐷"],
        "food" : ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓"],
        "sport" : ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏓", "🏸", "🏒", "🥊"],
        "transport" : ["🚗", "🚕", "🚌", "🚎", "🚂", "✈️", "🚀", "🚁", "⛴"],
        "emotions" : ["😄", "😳", "😍", "😭", "😤", "😪", "😱", "😏", "😛"]
    ]

    private var emojiChoices: [String]!
    
    private var emoji = [Int: String]()
    
    private  func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
         }
        return emoji[card.identifier] ?? "?"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
