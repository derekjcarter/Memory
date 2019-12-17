//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Derek Carter on 12/21/18.
//  Copyright © 2018 Derek Carter. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GameManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var emitterLayer = CAEmitterLayer()
    
    var numberOfColumns: Int = 2
    var numberOfColumns12: Int {
        get {
            return 2
        }
    }
    let minimumCellSpacing: CGFloat = 8.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Setup GameManager
        GameManager.shared.delegate = self
        
        // Setup collection view layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = minimumCellSpacing
        layout.minimumLineSpacing = minimumCellSpacing
        
        // Setup collectionView
        collectionView.backgroundColor = UIColor.clear
        collectionView.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resetGame()
        //playGame()
        showPlayAgainAlert(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if GameManager.shared.isPlaying {
            resetGame()
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    // MARK: - Game Methods
    
    func resetGame() {
        GameManager.shared.stopGame()
        collectionView.isUserInteractionEnabled = false
        collectionView.reloadData()
        
        // Center the rows in the middle of the collection view
        /*let halfOfCell: CGFloat = max((collectionView.frame.width / CGFloat(numberOfColumns) - minimumCellSpacing) / 2, 0)
        let contentInsetTop = max((collectionView.frame.height - collectionView.contentSize.height) / 2, 0)
        collectionView.contentInset.top = contentInsetTop-halfOfCell*/
    }
    
    func playGame() {
        if GameManager.shared.isPlaying {
            resetGame()
            GameManager.shared.newGame()
        }
        else {
            GameManager.shared.newGame()
        }
    }
    
    func showPlayAgainAlert(_ isNew: Bool = false) {
        var title = "YOU WON!"
        var buttonText = "PLAY AGAIN?"
        var iconImage = UIImage(named: "Particle-Star")
        if isNew {
            title = "MEMORY GAME"
            buttonText = "PLAY"
            iconImage = nil
        }
        let alertview = JSSAlertView().show(self,
                                            title: title,
                                            text: nil,
                                            buttonText: buttonText,
                                            color: UIColor(red: 227/255, green: 61/255, blue: 72/255, alpha: 1),
                                            iconImage: iconImage)
        alertview.setTitleFont("ChalkboardSE-Bold")
        alertview.setButtonFont("ChalkboardSE-Regular")
        alertview.setTextTheme(.light)
        alertview.addAction {
            self.stopParticles()
            self.resetGame()
            self.playGame()
        }
    }
    
    
    // MARK: - UICollectionViewDataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if GameManager.shared.cards.count > 0 {
            return GameManager.shared.cards.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath as IndexPath) as! CardCell
        cell.showCard(show: false, animted: false)
        
        guard let card = GameManager.shared.cardAtIndex(index: indexPath.item) else {
            return cell
        }
        cell.card = card
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CardCell
        
        if cell.shown {
            return
        }
        GameManager.shared.didSelectCard(card: cell.card)
        
        collectionView.deselectItem(at: indexPath as IndexPath, animated:true)
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 50, height: 50)
        if collectionView.numberOfItems(inSection: 0) > 8 {
            numberOfColumns = 3
        }
        let itemWidth: CGFloat = collectionView.frame.width / CGFloat(numberOfColumns) - minimumCellSpacing
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        /*
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidth: CGFloat = collectionView.frame.width / CGFloat(numberOfColumns) - minimumCellSpacing
        let cellHeight = cellWidth
        let numberOfRows = GameManager.shared.cards.count / numberOfColumns
        
        let totalWidth = (cellWidth * CGFloat(numberOfColumns)) + (CGFloat(numberOfColumns-1) * minimumCellSpacing)
        let totalHorizontalOffset = collectionView.frame.width - totalWidth
        //print("totalWidth: \(totalWidth)")
        //print("totalHorizontalOffset: \(totalHorizontalOffset)")
        
        let totalHeight = (cellHeight * CGFloat(numberOfRows)) + (CGFloat(numberOfRows-1) * minimumCellSpacing)
        let totalVerticalOffset = collectionView.frame.height - totalHeight
        //print("totalHeight: \(totalHeight)")
        //print("totalVerticalOffset: \(totalVerticalOffset)")
        
        return UIEdgeInsets(top: totalVerticalOffset/2, left: totalHorizontalOffset/2, bottom: totalVerticalOffset/2, right: totalHorizontalOffset/2)
        */
        
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let cellWidth: CGFloat = flowLayout.itemSize.width
        let cellHeight: CGFloat = flowLayout.itemSize.height
        print("cellWidth: \(cellWidth)")
        print("cellHeight: \(cellHeight)")
        
        let numberOfCards = collectionView.numberOfItems(inSection: section)
        print("numberOfCards: \(numberOfCards)")
        //let numberOfRows = numberOfCards / numberOfColumns

        let totalWidth = (cellWidth * CGFloat(numberOfCards)) + (CGFloat(numberOfCards-1) * minimumCellSpacing)
        print("totalWidth: \(totalWidth)")
        
        let collectionViewWidth = collectionView.frame.size.width
        print("collectionViewWidth: \(collectionViewWidth)")
        
        //let totalHorizontalOffset = collectionView.frame.width - totalWidth
        //print("totalWidth: \(totalWidth)")
        //print("totalHorizontalOffset: \(totalHorizontalOffset)")

        //let totalHeight = (cellHeight * CGFloat(numberOfRows)) + (CGFloat(numberOfRows-1) * minimumCellSpacing)
        //let totalVerticalOffset = collectionView.frame.height - totalHeight
        //print("totalHeight: \(totalHeight)")
        //print("totalVerticalOffset: \(totalVerticalOffset)")

        
        //return UIEdgeInsets(top: totalVerticalOffset/2, left: totalHorizontalOffset/2, bottom: totalVerticalOffset/2, right: totalHorizontalOffset/2)
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//
//        let cellWidth: CGFloat = flowLayout.itemSize.width
//        let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
//        let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
//
//        var collectionWidth = collectionView.frame.size.width
//        if #available(iOS 11.0, *) {
//            collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
//        }
//        print("collectionWidth: \(collectionWidth)")
//
//        let totalWidth: CGFloat = cellWidth * cellCount + cellSpacing * (cellCount - 1)
//        print("totalWidth: \(totalWidth)")
//        if totalWidth <= collectionWidth {
//            let edgeInset = (collectionWidth - totalWidth) / 2
//            print(" flowLayout.sectionInset.top: \(flowLayout.sectionInset.top)")
//            print(" flowLayout.sectionInset.bottom: \(flowLayout.sectionInset.bottom)")
//            print(" edgeInset: \(edgeInset)")
//
//            return UIEdgeInsets(top: flowLayout.sectionInset.top, left: edgeInset, bottom: flowLayout.sectionInset.bottom, right: edgeInset)
//        }
//        else {
//            return flowLayout.sectionInset
//        }
        

//        var collectionViewHeight = collectionView.frame.size.height
//        if #available(iOS 11.0, *) {
//            collectionViewHeight -= collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom
//        }
//
//        let itemsHeight = collectionView.contentSize.height
//        print(" collectionViewHeight: \(collectionViewHeight)")
//        print(" itemsHeight: \(itemsHeight)")
//
//        let topInset = (collectionViewHeight - itemsHeight) / 4
//        print(" topInset: \(topInset)")
//
//        return UIEdgeInsets(top: topInset, left: 0, bottom: 0 , right: 0)
        
    }
    
    
    // MARK: - GameManagerDelegate Methods
    
    func didStartGame(game: GameManager) {
        print("GameManagerDelegate | didStartGame")
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
    }
    
    func didShowCards(game: GameManager, cards: [Card]) {
        print("GameManagerDelegate | didShowCards")
        for card in cards {
            guard let index = game.indexForCard(card: card) else {
                continue
            }
            let cell = collectionView.cellForItem(at: NSIndexPath(item: index, section:0) as IndexPath) as! CardCell
            cell.showCard(show: true, animted: true)
        }
    }
    
    func didHideCards(game: GameManager, cards: [Card]) {
        print("GameManagerDelegate | didHideCards")
        for card in cards {
            guard let index = game.indexForCard(card: card) else {
                continue
            }
            let cell = collectionView.cellForItem(at: NSIndexPath(item: index, section:0) as IndexPath) as! CardCell
            cell.showCard(show: false, animted: true)
        }
    }
    
    func didEndGame(game: GameManager, elapsedTime: TimeInterval) {
        print("GameManagerDelegate | didEndGame")
        
        showParticles()
        showPlayAgainAlert()
    }
    
    
    // MARK: - Particle Methods
    
    private func showParticles() {
        emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.center.x, y: -50)
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let red = makeEmitterCell(color: UIColor.red)
        let green = makeEmitterCell(color: UIColor.green)
        let blue = makeEmitterCell(color: UIColor.blue)
        let yellow = makeEmitterCell(color: UIColor.yellow)
        let orange = makeEmitterCell(color: UIColor.orange)
        let purple = makeEmitterCell(color: UIColor.purple)
        emitterLayer.emitterCells = [red, green, blue, yellow, orange, purple]
        
        view.layer.addSublayer(emitterLayer)
    }
    
    private func stopParticles() {
        emitterLayer.lifetime = 0.0
    }
    
    private func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 9
        cell.lifetime = 7.0
        cell.lifetimeRange = 1.0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 4
        cell.scale = 0.65
        cell.scaleRange = 0.15
        cell.scaleSpeed = -0.05
        cell.contents = UIImage(named: "Particle-Star")?.cgImage
        return cell
    }
    
    private func addComets() {
        let width = view.bounds.width
        let height = view.bounds.height
        let comets = [Comet(startPoint: CGPoint(x: 100, y: 0),
                            endPoint: CGPoint(x: 0, y: 100),
                            lineColor: UIColor.white.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: 0.4 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.8 * width),
                            lineColor: UIColor.white.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: 0.8 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.2 * width),
                            lineColor: UIColor.white.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: width, y: 0.2 * height),
                            endPoint: CGPoint(x: 0, y: 0.25 * height),
                            lineColor: UIColor.white.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: 0, y: height - 0.8 * width),
                            endPoint: CGPoint(x: 0.6 * width, y: height),
                            lineColor: UIColor.white.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: width - 100, y: height),
                            endPoint: CGPoint(x: width, y: height - 100),
                            lineColor: UIColor.white.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: 0, y: 0.8 * height),
                            endPoint: CGPoint(x: width, y: 0.75 * height),
                            lineColor: UIColor.white.withAlphaComponent(0.2))]
        
        // draw track and animate
        for comet in comets {
            //view.layer.addSublayer(comet.drawLine())
            view.layer.addSublayer(comet.animate())
        }
        
    }
    
}
