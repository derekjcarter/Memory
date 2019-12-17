//
//  Array+Shuffle.swift
//  MemoryGame
//
//  Created by Derek Carter on 12/21/18.
//  Copyright © 2018 Derek Carter. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func shuffle() {
        // Randomize the order of the array elements
        if self.count > 0 {
            for _ in 1...self.count {
                self.sort { (a, b) -> Bool in
                    return arc4random() < arc4random()
                }
            }
        }
    }

}

