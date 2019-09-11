//
//  SplashScreenViewController.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class SplashScreenViewController: UIViewController {
    var bootstrapper: Bootstrapper?
    var observer: NSObjectProtocol?
    var player: AVPlayer?
    var feedsLoaded = false
    var videoFinishedPlaying = false

    @IBOutlet var videoPlayerView: VideoContainerView!
    let loadingViewController = LoadingViewController.viewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        bootstrapper?.startUp(self) {
            self.feedsLoaded = true
            self.dismissSplashScreen()
        }

        playerDidFinish()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AVSessionManager().switchToAmbientAudioCategory()
        
        if player == nil {
            playVideo()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        playVideo()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        player?.pause()
        player = nil
        videoPlayerView.playerLayer?.removeFromSuperlayer()
        videoPlayerView.playerLayer = nil
        
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    static func viewController() -> SplashScreenViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashScreenViewController") as! SplashScreenViewController

        return vc
    }
    
    func playerDidFinish() {
        observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] notification in
            self?.videoFinishedPlaying = true
            self?.showLoading()
            self?.dismissSplashScreen()
        }
    }

    func playVideo() {

        if let path = Bundle.main.path(forResource: "mailchimp_loading", ofType:"mp4"){
            let videoURL = URL(fileURLWithPath: path)
            let playerItem = AVPlayerItem(url: videoURL)
            self.player = AVPlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.frame = self.videoPlayerView.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.videoPlayerView.layer.addSublayer(playerLayer)
            self.videoPlayerView.playerLayer = playerLayer
            
            if let player = player {
                player.isMuted = true
                player.play()
                FadeAnimation.fadeOutAnimation(videoPlayerView, duration: TimeInterval(SplashScreenAnimation.splashScreenDuration()), delay:  TimeInterval(SplashScreenAnimation.splashScreenDelay()))
            }
        }
    }

    func startupOperationsCompleted() {
        feedsLoaded = true
        dismissSplashScreen()
    }
    
    func dismissSplashScreen(_ force: Bool = false) {
        if (feedsLoaded) || force {
            switchViewControllers(homeViewController())
        }
    }

    fileprivate func homeViewController() -> UIViewController {
        let homeFeedVC = storyboard!.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        
        return homeFeedVC
    }

    fileprivate func switchViewControllers(_ viewController: UIViewController) {
        DispatchQueue.main.async { () -> Void in
            if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window!.rootViewController {
                UIView.transition(from: rootViewController.view, to: viewController.view, duration: 0.1, options: UIViewAnimationOptions(), completion: { (complete: Bool) -> Void in
                    window?.rootViewController = viewController
                })
            }
        }
    }

    fileprivate func animateLoading(_ start: Bool) {
        DispatchQueue.main.async {
            if start {
                self.loadingViewController.startAnimating()
            } else {
                self.loadingViewController.stopAnimating()
            }
        }
    }

    fileprivate func showLoading() {
        if let configSwitchCompleted = bootstrapper?.configOperationComplete {
            if !feedsLoaded && configSwitchCompleted {
                switchViewControllers(loadingViewController)
                animateLoading(true)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
