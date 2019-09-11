//
//  RewardsViewModel.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit
import CoreData

class RewardsViewModel {

    // MARK: - Properties
    var viewModels = [String : RewardCellViewModel]()
    var bootstrapper: Bootstrapper? { didSet { _ = refreshRewards() } }
    var rewards = Observable<[Reward]?>(nil)


    // MARK: - Initialization
    init() {
        
        //create rewards for now:
    
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: FetchDataFeedOperation.FetchComplete), object: nil, queue: nil, using: { _ in _ = self.refreshRewards() })

    }

    func refreshRewards() {
        guard let store = bootstrapper?.store,
            let rewardList = Reward.allCurrentRewards(inManagedObjectContext: store.mainContext), rewardList.count > 0
            else { return  }

        rewards.value = rewardList
    }



    // MARK: - Utility

    func reward(withId id: String) -> Reward? {
        guard let rewards = rewards.value else { return nil }
        return rewards.filter { $0.id == id }.first
    }


    // MARK: - Collection View Datasource / Delegate

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems(section: Int) -> Int {
        guard let rewards = rewards.value else { return 0 }
        return rewards.count
    }

    func viewModel(at indexPath: IndexPath) -> RewardCellViewModel? {

        guard let rewards = rewards.value else { return nil }

        let reward = rewards[indexPath.row]

        guard let id = reward.id else { return nil }

        if let viewModel = viewModels[id] {
            viewModel.updateViewModel(reward: reward)
            return viewModel
        } else {
            let viewModel = RewardCellViewModel()
            viewModel.reward = reward
            viewModels[id] = viewModel
            return viewModel
        }
    }
}
