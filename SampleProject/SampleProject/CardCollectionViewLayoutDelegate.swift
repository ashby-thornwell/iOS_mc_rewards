//
//  CardCollectionViewLayoutDelegate.swift
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

/// Extended delegate.
@objc public protocol CardCollectionViewLayoutDelegate : UICollectionViewDelegate {
    
    /// Asks if the card at the specific index can be revealed.
    /// - Parameter collectionViewLayout: The current CardCollectionViewLayout.
    /// - Parameter canRevealCardAtIndex: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: CardCollectionViewLayout, canRevealCardAtIndex index: Int) -> Bool
    
    /// Asks if the card at the specific index can be Unrevealed.
    /// - Parameter collectionViewLayout: The current CardCollectionViewLayout.
    /// - Parameter canUnrevealCardAtIndex: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: CardCollectionViewLayout, canUnrevealCardAtIndex index: Int) -> Bool
    
    /// Feedback when the card at the given index will be revealed.
    /// - Parameter collectionViewLayout: The current CardCollectionViewLayout.
    /// - Parameter didRevealedCardAtIndex: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: CardCollectionViewLayout, willRevealCardAtIndex index: Int)
    
    /// Feedback when the card at the given index was revealed.
    /// - Parameter collectionViewLayout: The current CardCollectionViewLayout.
    /// - Parameter didRevealedCardAtIndex: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: CardCollectionViewLayout, didRevealCardAtIndex index: Int)
    
    /// Feedback when the card at the given index will be Unrevealed.
    /// - Parameter collectionViewLayout: The current CardCollectionViewLayout.
    /// - Parameter didUnrevealedCardAtIndex: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: CardCollectionViewLayout, willUnrevealCardAtIndex index: Int)
    
    /// Feedback when the card at the given index was Unrevealed.
    /// - Parameter collectionViewLayout: The current CardCollectionViewLayout.
    /// - Parameter didUnrevealedCardAtIndex: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: CardCollectionViewLayout, didUnrevealCardAtIndex index: Int)
    
}
