//
//  Concentration.swift
//  Concentration
//
//  Created by Марина on 25.12.2019.
//  Copyright © 2019 Marina Potashenkova. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    
    private  var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private(set) var flipCount = 0
    var score = 0
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    if cards[index].wasSeenBefore {
                        score -= 1
                    }
                    if cards[matchIndex].wasSeenBefore {
                        score -= 1
                    }
                }
                cards[index].wasSeenBefore = true
                cards[matchIndex].wasSeenBefore = true
                
                cards[index].isFaceUp = true
            } else { 
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards ")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }

        var newCards = [Card]()
        for _ in cards.indices {
            let index = Int(arc4random_uniform(UInt32(cards.count)))
            newCards.append(cards.remove(at: index))
        }
        cards = newCards
    }
}
