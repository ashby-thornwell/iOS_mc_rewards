//
//  RewardCellViewModel.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

class RewardCellViewModel {

    let backgroundImage = Observable<UIImage?>(nil)
    let title = Observable<String>("")
    let rewardDescription = Observable<String>("")
    let topRightButtonImage = Observable<UIImage?>(nil)

    var reward: Reward? {
        didSet {
            updateViewModel(reward: reward)
        }
    }

    func updateViewModel(reward: Reward?) {
        guard let reward = reward else { return }

        title.value = reward.title ?? ""
        rewardDescription.value = reward.rewardDescription ?? ""

        if let backgroundImageURL = reward.imageURL {
            FetchImageManager.fetchImageForObservable(backgroundImage, fromString: backgroundImageURL)
        }
    }
}
