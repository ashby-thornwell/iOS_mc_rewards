//
//  RewardCollectionViewCell.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

class RewardCollectionViewCell: UICollectionViewCell {
    
    @IBInspectable open var cornerRadius: CGFloat = 10

    // MARK: - IBOutlets

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundGradient: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Properties

    var disposeBag: DisposableBag?
    weak var delegate: RewardCellDelegate?

    var viewModel: RewardCellViewModel? {
        didSet {

            let disposeBag = DisposableBag()

            viewModel?.title.bind(titleLabel).addDisposableTo(disposeBag)
            viewModel?.rewardDescription.bind(descriptionLabel).addDisposableTo(disposeBag)

            viewModel?.backgroundImage.bind(backgroundImageView).addDisposableTo(disposeBag)

            self.disposeBag = disposeBag
        }
    }

    // MARK: - Cell Cycle
    
    /// Overwritten to setup the view
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupLayer(self)
        self.setupLayer(backgroundImageView)
//        self.setupLayer(backgroundGradient)
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = self.cornerRadius
        self.contentView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }
    
    ///
    /// - Parameter layoutAttributes: The new layout attributes
    override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let cardLayoutAttributes = layoutAttributes as? CardCollectionViewLayoutAttributes {
            self.layer.zPosition = CGFloat(cardLayoutAttributes.zIndex)
            self.contentView.isUserInteractionEnabled = cardLayoutAttributes.isRevealed
        } else {
            self.contentView.isUserInteractionEnabled = true
        }
    }
    
    /// Overwritten to update the shadowPath.
    override open var bounds: CGRect {
        didSet {
            let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
            self.layer.shadowPath = shadowPath
        }
    }
    

    /// Overwritten to create a better snapshot.
    ///
    /// The CardCollectionViewLayout will create a snapshot of this cell as the moving card view.
    /// This Function will recreate the shadows to the snapshotView.
    override open func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        let snapshotView = UIView(frame: self.frame)
        if let snapshotOfContentView = self.contentView.snapshotView(afterScreenUpdates: afterUpdates) {
            snapshotView.addSubview(snapshotOfContentView)
        }
        self.setupLayer(snapshotView)
        return snapshotView
    }
    
    // MARK: Private Functions
    
    private func setupLayer(_ forView: UIView) {
        // Shadow can have performance issues on older devices
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
        forView.layer.shadowPath = shadowPath
        forView.layer.masksToBounds = false
        forView.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        forView.layer.shadowRadius = 2
        forView.layer.shadowOpacity = 0.35
        forView.layer.shadowOffset = CGSize(width: 0, height: 0)
        forView.layer.rasterizationScale = UIScreen.main.scale
        forView.layer.shouldRasterize = true
        forView.clipsToBounds = false
    }
}

    

