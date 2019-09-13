//
//  RewardsViewController.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController {

    // MARK: - Constants

    struct CellIdentifiers {
        static let reward = "rewardCell"
    }

    // MARK: - Properties

   lazy var modelController: RewardsViewModel = RewardsViewModel()

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: CardCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = modelController.rewards.addChangeHandler(self, fireImmediately: false, handler: { [weak self] (rewards) in
            self?.collectionView?.reloadData()
        })

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            modelController.bootstrapper = appDelegate.bootstrapper
        }

        title = "View Rewards"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        modelController.refreshRewards()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RewardsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelController.numberOfItems(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         return cardCollectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cardCollectionView(collectionView, didSelectItemAt: indexPath)
    }
}

// MARK: Card Collection View Delegate and Data Source

extension RewardsViewController {
    func cardCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelController.numberOfItems(section: section)
    }
    
    func cardCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.reward, for: indexPath) as! RewardCollectionViewCell
        
        if let cellViewModel = modelController.viewModel(at: indexPath) {
            cell.viewModel = cellViewModel
        }
        
        cell.subviews.filter { $0 != cell.contentView }.forEach { $0.removeFromSuperview() }
        cell.subviews.forEach { $0.isUserInteractionEnabled = false }
        
        return cell
    }
    
    func cardCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.collectionViewLayout as! CardCollectionViewLayout).revealCardAt(index: indexPath.item)
    }
}

extension RewardsViewController : CardCollectionViewLayoutDelegate {
    func cardCollectionViewLayout(_ collectionViewLayout: CardCollectionViewLayout, didRevealCardAtIndex index: Int) {
        collectionView?.cellForItem(at: IndexPath(item: index, section: 0))?.subviews.forEach { $0.isUserInteractionEnabled = true }
    }
    
    func cardCollectionViewLayout(_ collectionViewLayout: CardCollectionViewLayout, didUnrevealCardAtIndex index: Int) {
        collectionView?.cellForItem(at: IndexPath(item: index, section: 0))?.subviews.forEach { $0.isUserInteractionEnabled = false }
    }
}


