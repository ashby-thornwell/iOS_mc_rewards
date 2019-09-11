//
//  RewardCellDelegate.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

protocol RewardCellDelegate: NSObjectProtocol {
    func favoriteButtonTapped(cell: RewardCollectionViewCell)
}
