//
//  CardCell.swift
//  MemoryGame
//
//  Created by Derek Carter on 12/21/18.
//  Copyright © 2018 Derek Carter. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card? {
        didSet {
            guard let card = card else {
                return
            }
            frontImageView.image = card.image
            frontImageView.contentMode = .scaleAspectFill
            frontImageView.layer.cornerRadius = 4.0
            frontImageView.clipsToBounds = true
        }
    }
    
    private(set) var shown: Bool = false
    
    
    // MARK: - Public Methods
    
    func showCard(show: Bool, animted: Bool) {
        frontImageView.isHidden = false
        backImageView.isHidden = false
        shown = show
        
        if animted {
            if show {
                UIView.animate(withDuration: 0.25) {
                    self.backgroundColor = UIColor.clear
                }
                UIView.transition(from: backImageView,
                                  to: frontImageView,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion: { (finished: Bool) -> () in
                })
            }
            else {
                UIView.animate(withDuration: 0.25) {
                    self.backgroundColor = UIColor.white
                }
                UIView.transition(from: frontImageView,
                                  to: backImageView,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion:  { (finished: Bool) -> () in
                })
            }
        }
        else {
            if show {
                bringSubviewToFront(frontImageView)
                backImageView.isHidden = true
                UIView.animate(withDuration: 0.25) {
                    self.backgroundColor = UIColor.clear
                }
            }
            else {
                bringSubviewToFront(backImageView)
                frontImageView.isHidden = true
                UIView.animate(withDuration: 0.25) {
                    self.backgroundColor = UIColor.white
                }
            }
        }
    }
    
}
