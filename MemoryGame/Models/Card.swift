//
//  Card.swift
//  MemoryGame
//
//  Created by Derek Carter on 12/21/18.
//  Copyright © 2018 Derek Carter. All rights reserved.
//

import Foundation
import UIKit

class Card: CustomStringConvertible {
    
    var id: NSUUID = NSUUID.init()
    var shown: Bool = false
    var image: UIImage
    
    
    init(image: UIImage) {
        self.image = image
    }
    
    init(card: Card) {
        self.id = card.id.copy() as! NSUUID
        self.shown = card.shown
        self.image = card.image.copy() as! UIImage
    }
    
    func equals(card: Card) -> Bool {
        return card.id.isEqual(id)
    }
    
    var description: String {
        return "\(id.uuidString)"
    }
    
}
