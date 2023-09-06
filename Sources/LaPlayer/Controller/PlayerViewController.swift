
import UIKit
import BrightcovePlayerSDK
import Combine

class PlayerViewController: UIViewController, BCOVPlaybackControllerDelegate, BCOVPUIPlayerViewDelegate {
    
    private var playerViewModel: PlayerViewModel
    
    private var accountId: String
    private var policyKey: String
    
    private var playbackService: BCOVPlaybackService?
    
    private var hideableLayoutView: BCOVPUILayoutView?
    
    private var playerView: BCOVPUIPlayerView?
    
    private var playbackSession: BCOVPlaybackSession?
    
    private let tag = "La Player"
    
    private var isViewVisible = false
    
    private lazy var playbackController: BCOVPlaybackController? = {
        guard let manager = BCOVPlayerSDKManager.shared(), let controller = manager.createPlaybackController() else {
            return nil
        }
        controller.delegate = self
        //        controller.isAutoAdvance = true
        //        controller.isAutoPlay = true
        controller.allowsBackgroundAudioPlayback = false
        return controller
    }()
    
    private lazy var compactLayoutMaximumWidth: CGFloat = {
        return (view.frame.width + view.frame.height) / 2
    }()
    
    private let rewindDuration: Int = 10
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(playerViewModel: PlayerViewModel) {
        self.playerViewModel = playerViewModel
        self.accountId = playerViewModel.accountId
        self.policyKey = playerViewModel.policyKey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(tag) init(coder:) is not supported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        debugPrint("\(tag) viewWillAppear")
        isViewVisible = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        debugPrint("\(tag) viewDidAppear")
        isViewVisible = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("\(tag) viewDidLoad")
        isViewVisible = true
        configurePlayer()
        setPlayerCallbacks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        debugPrint("\(tag) viewWillDisappear")
        isViewVisible = false
        removePlayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        debugPrint("\(tag) viewDidDisappear")
        isViewVisible = false
    }
    
    
    private func configurePlayer() {
        
        playbackService = BCOVPlaybackService(accountId: accountId, policyKey: policyKey)
        
        let options = BCOVPUIPlayerViewOptions()
        options.presentingViewController = self
        
        // Make the controls linger on screen for a long time
        // so you can examine the controls.
        options.hideControlsInterval = 10
        
        // But hide and show quickly.
        options.hideControlsAnimationDuration = 0.2
        
        let controlView = BCOVPUIBasicControlView.withVODLayout()
        
        playerView = BCOVPUIPlayerView(playbackController: playbackController, options: options, controlsView: controlView)
        
        guard let playerView = playerView else {
            return
        }
        
        playerView.delegate = self
        playerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Add BCOVPUIPlayerView to video view.
        view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        //        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //        playerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        //        playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            playerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hideableLayoutView = setCustomLayout(
            forControlsView: playerView.controlsView,
            compactLayoutMaximumWidth: compactLayoutMaximumWidth
        )
        
        PlayerViewStyle().setCustomStyle(forControlsView: playerView.controlsView)
    }
    
    private func setCustomLayout(
        forControlsView controlsView: BCOVPUIBasicControlView,
        compactLayoutMaximumWidth: CGFloat
    ) -> BCOVPUILayoutView? {
        
        var controlLayout: BCOVPUIControlLayout?
        var layoutView: BCOVPUILayoutView?
        
        let (_controlLayout, _layoutView) = PlayerCustomLayout().setCustomLayout(forControlsView: controlsView, playerControls: playerViewModel.playerControl)
        controlLayout = _controlLayout
        layoutView = _layoutView
        
        controlLayout?.compactLayoutMaximumWidth = compactLayoutMaximumWidth
        
        controlsView.layout = controlLayout
        
        return layoutView
    }
    
    private func onRewindBackward() {
        let currentItem = playbackSession?.player.currentItem
        guard let currentTime = currentItem?.currentTime() else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(currentTime)
        var newTime = playerCurrentTime - Float64(rewindDuration)
        if newTime < 0 {
            newTime = 0
        }
        let rewindTime = CMTime(value: CMTimeValue(Int64(newTime * 1000 as Float64)), timescale: 1000)
        playbackController?.seek(to: rewindTime, completionHandler: {
            (completed: Bool) -> Void in
            debugPrint("\(self.tag) onRewindBackward \(completed)")
        })
        
    }
    
    private func onRewindForward() {
        let currentItem = playbackSession?.player.currentItem
        guard let duration  = currentItem?.duration else {
            return
        }
        guard let currentTime = currentItem?.currentTime() else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(currentTime)
        let newTime = playerCurrentTime + Float64(rewindDuration)
        
        if newTime < CMTimeGetSeconds(duration) {
            let rewindTime = CMTime(value: CMTimeValue(Int64(newTime * 1000 as Float64)), timescale: 1000)
            playbackController?.seek(to: rewindTime, completionHandler: {
                (completed: Bool) -> Void in
                debugPrint("\(self.tag) onRewindForward \(completed)")
            })
        }
    }
    
    private func resumeVideoProgress() {
        if let resumeTime = playerViewModel.resumeVideoProgress {
            if resumeTime > 0 && resumeTime < playerViewModel.videoDuration ?? 0 {
                let newResumeTime = CMTime(value: CMTimeValue(Int64(resumeTime * 1000 as Float64)), timescale: 1000)
                playbackController?.seek(to: newResumeTime, completionHandler: {
                    (completed: Bool) -> Void in
                    debugPrint("\(self.tag) resumeVideoProgress() \(completed)")
                })
            }
        }
    }
    
    private func findVideo(videoId: String) {
        playbackService?.findVideo(withVideoID: videoId, parameters: nil, completion: {
            [weak self] (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) in
            
            if let video = video, let strongSelf = self {
                strongSelf.playbackController?.setVideos([video] as NSFastEnumeration)
            }
            
            if let error = error {
                debugPrint("La Player ViewController Debug - Error retrieving video playlist: \(error.localizedDescription)")
            }
            
        })
    }
    
    private func removePlayer() {
        debugPrint("\(tag) removePlayer() pause video")
        //        self.playerView?.removeFromSuperview()
        //        self.playerView = nil
        playerViewModel.videoState = .settingChanged
        self.playbackController?.pause()
        //        self.playbackController = nil
    }
    
    private func setPlayerCallbacks() {
        playerViewModel.$playerState.sink(receiveValue: { playerState in
            switch playerState.self {
            case .forward: self.onRewindForward()
            case .backward: self.onRewindBackward()
            case .play: self.playbackController?.play()
            case .pause: self.playbackController?.pause()
            }
        })
        .store(in: &subscriptions)
        
        playerViewModel.$videoQuality.sink(receiveValue: { quality in
            self.playbackController?.setPreferredPeakBitRate(Double(quality.quality.quality))
        })
        .store(in: &subscriptions)
        
        playerViewModel.$playbackSpeed.sink(receiveValue: { speed in
            self.playbackController?.playbackRate = speed.speed.rate
        })
        .store(in: &subscriptions)
        
        playerViewModel.$videoId.sink(receiveValue: { videoId in
            if videoId != nil {
                self.findVideo(videoId: videoId!)
            } else {
                self.findVideo(videoId: "")
                //                self.playbackSession?.playerLayer.removeFromSuperlayer()
            }
        })
        .store(in: &subscriptions)
        
    }
}

extension PlayerViewController {
    func playbackController(
        _ controller: BCOVPlaybackController?,
        playbackSession session: BCOVPlaybackSession?,
        didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent?
    ) {
        guard let eventType = lifecycleEvent?.eventType else {
            return
        }
        guard let playerSession = session else {
            return
        }
        
        debugPrint("\(tag) lifecycleEventType \(eventType)")
        if (eventType == kBCOVPlaybackSessionLifecycleEventReady) {
            self.playbackSession = playerSession
            resumeVideoProgress()
            if self.isViewVisible {
                debugPrint("\(tag) lifecycleEventType \(eventType) play video")
                self.playbackController?.play()
            }
        } else if (eventType == kBCOVPlaybackSessionLifecycleEventPlayRequest && self.playerView != nil) {
            playerViewModel.videoState = .play
        } else if (eventType == kBCOVPlaybackSessionLifecycleEventPauseRequest && self.playerView != nil) {
            playerViewModel.videoState = .pause
        } else if (eventType == kBCOVPlaybackSessionLifecycleEventEnd && self.playerView != nil) {
            playerViewModel.videoState = .complete
        } else if (eventType == kBCOVPlaybackSessionLifecycleEventPlaybackBufferEmpty) {
            playerViewModel.videoState = .bufferEmpty
        } else if (eventType == kBCOVPlaybackSessionLifecycleEventPlaybackLikelyToKeepUp) {
            playerViewModel.videoState = .bufferComplete
        }
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
        debugPrint("\(tag) playbackController didProgressTo \(progress)")
        DispatchQueue.main.async { [weak self] in
            self?.playerViewModel.videoProgress = progress
        }
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didChangeDuration duration: TimeInterval) {
        debugPrint("\(tag) playbackController didChangeDuration \(duration)")
        DispatchQueue.main.async { [weak self] in
            self?.playerViewModel.videoDuration = duration
        }
        
    }
    
    
    func playerView(_ playerView: BCOVPUIPlayerView!, controlsFadingViewDidFadeIn controlsFadingView: UIView!) {
        DispatchQueue.main.async { [weak self] in
            self?.playerViewModel.showPlayerControls = true
        }
    }
    
    func playerView(_ playerView: BCOVPUIPlayerView!, controlsFadingViewDidFadeOut controlsFadingView: UIView!) {
        
        DispatchQueue.main.async { [weak self] in
            self?.playerViewModel.showPlayerControls = false
        }
    }
    
    func playerView(_ playerView: BCOVPUIPlayerView!, didTransitionTo screenMode: BCOVPUIScreenMode) {
        playerViewModel.screenMode = screenMode
        guard let windowScene = view.window?.windowScene else { return }
        
        if screenMode == BCOVPUIScreenMode.normal {
            if #available(iOS 16.0, *) {
                debugPrint("\(tag) Normal Screen Mode for iOS16 > ")
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
                    debugPrint("change to portrait \(error)")
                }
            } else {
                // Fallback on earlier versions
                debugPrint("\(tag) Normal Screen Mode for < iOS16")
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
        } else if screenMode == BCOVPUIScreenMode.full {
            if #available(iOS 16.0, *) {
                debugPrint("\(tag) Full Screen Mode for iOS16 >")
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)) { error in
                    debugPrint("change to landscape \(error)")
                    
                }
            } else {
                // Fallback on earlier versions
                debugPrint("\(tag) Full Screen Mode for < iOS16")
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
    }
}


//extension PlayerViewController: BCOVPlaybackSessionConsumer {
//
//    func didAdvance(to session: BCOVPlaybackSession!) {
//        print("didAdvance")
//        // Reset State
//    }
//
//    func playbackSession(_ session: BCOVPlaybackSession!, didChangeDuration duration: TimeInterval) {
//        print("\(tag) playbackSession PlayerViewController - \(duration)")
//    }
//
//    func playbackSession(_ session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
//        print("\(tag) playbackSession PlayerViewController - \(progress)")
//    }
//}
