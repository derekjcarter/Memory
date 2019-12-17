//
//  GameManager.swift
//  MemoryGame
//
//  Created by Derek Carter on 12/21/18.
//  Copyright © 2018 Derek Carter. All rights reserved.
//

import Foundation
import Photos
import UIKit


protocol GameManagerDelegate {
    func didStartGame(game: GameManager)
    func didShowCards(game: GameManager, cards: [Card])
    func didHideCards(game: GameManager, cards: [Card])
    func didEndGame(game: GameManager, elapsedTime: TimeInterval)
}


class GameManager: NSObject {
    
    var delegate: GameManagerDelegate?
    
    // Card properties
    public let useDefaultImages: Bool = false
    static public var defaultCardImages: [UIImage] = [
        UIImage(named: "defaultCard1")!,
        UIImage(named: "defaultCard2")!,
        UIImage(named: "defaultCard3")!,
        UIImage(named: "defaultCard4")!,
        UIImage(named: "defaultCard5")!,
        UIImage(named: "defaultCard6")!
    ];
    public var cards: [Card] = [Card]()
    private var photoLibraryImages = [UIImage]()
    
    // Game play properties
    public var currentRound: Int = 0
    public var roundCounts: [Int: Int] = [
        1: 1, // 2 total cards
        2: 2, // 4 total cards
        3: 3, // 6 total cards
        4: 4, // 8 total cards
        5: 5, // 10 total cards
        6: 6, // 12 total cards
        7: 7, // 14 total cards
        8: 8, // 16 total cards
        9: 9  // 18 total cards
    ]
    public var isPlaying: Bool = false
    private var cardsShown: [Card] = [Card]()
    private var startTime: Date?
    
    public var elapsedTime: TimeInterval {
        get {
            guard startTime != nil else {
                return -1
            }
            return Date().timeIntervalSince(startTime!)
        }
    }
    
    
    // MARK: - Initialization Methods
    
    static let shared = GameManager()
    
    private override init() {
        super.init()
        
        if !useDefaultImages {
            fetchCustomAlbumPhotos()
        }
    }
    
    
    // MARK: - Game Methods
    
    public func newGame() {
        currentRound = currentRound + 1
        
        var maxCards = 0
        if let numberOfCards = roundCounts[currentRound] {
            maxCards = numberOfCards
        }
        else {
            maxCards = roundCounts[roundCounts.count]!
        }
        
        cards = randomCards(maxCards: maxCards)
        startTime = Date()
        isPlaying = true
        delegate?.didStartGame(game: self)
    }
    
    public func stopGame() {
        isPlaying = false
        cards.removeAll()
        cardsShown.removeAll()
        startTime = nil
    }
    
    private func finishGame() {
        isPlaying = false
        delegate?.didEndGame(game: self, elapsedTime: elapsedTime)
    }
    
    
    // MARK: - Card Methods
    
    public func didSelectCard(card: Card?) {
        guard let card = card else {
            return
        }
        
        delegate?.didShowCards(game: self, cards: [card])
        
        if unpairedCardShown() {
            let unpaired = unpairedCard()!
            if card.equals(card: unpaired) {
                cardsShown.append(card)
            }
            else {
                let unpairedCard = cardsShown.removeLast()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.delegate?.didHideCards(game: self, cards: [card, unpairedCard])
                }
            }
        }
        else {
            cardsShown.append(card)
        }
        
        if cardsShown.count == cards.count {
            finishGame()
        }
    }
    
    public func cardAtIndex(index: Int) -> Card? {
        if cards.count > index {
            return cards[index]
        }
        return nil
    }
    
    public func indexForCard(card: Card) -> Int? {
        for index in 0...cards.count-1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }
    
    private func unpairedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    private func unpairedCard() -> Card? {
        let unpairedCard = cardsShown.last
        return unpairedCard
    }
    
    private func randomCards(maxCards: Int) -> [Card] {
        var cards = [Card]()
        
        var i = 1
        if useDefaultImages {
            for image in GameManager.defaultCardImages {
                let card = Card.init(image: image)
                cards.append(contentsOf: [card, Card.init(card: card)])
                if i >= maxCards {
                    break
                }
                i=i+1
            }
        }
        else {
            for image in self.photoLibraryImages.shuffled() {
                let card = Card.init(image: image)
                cards.append(contentsOf: [card, Card.init(card: card)])
                if i >= maxCards {
                    break
                }
                i=i+1
            }
        }
        
        cards.shuffle()
        return cards
    }

    
    
    // MARK: - Photo Asset Methods
    
    func fetchCustomAlbumPhotos() {
        let albumName = "Memory"
        
        var assetCollection = PHAssetCollection()
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        var albumFound: Bool = false
        
        if let firstObject = collection.firstObject {
            print("Album is found")
            assetCollection = firstObject
            albumFound = true
        }
        
        if !albumFound {
            print("Album not found")
            return
        }
        
        let imageManager = PHCachingImageManager()
        
        let photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        photoAssets.enumerateObjects{(object: AnyObject!, count: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            if object is PHAsset {
                let asset = object as! PHAsset
                print("Inside  If object is PHAsset, This is number 1")
                
                let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                //options.deliveryMode = .fastFormat
                options.deliveryMode = .highQualityFormat
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset,
                                          targetSize: imageSize,
                                          contentMode: .aspectFill,
                                          options: options,
                                          resultHandler: { (image, info) -> Void in
                                            print("enum for image, This is number 2")
                                            self.photoLibraryImages.append(image!)
                })
                
                //self.cards = self.randomCards(maxCards: 0)
            }
        }
        
    }
    
}
