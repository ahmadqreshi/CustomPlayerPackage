import Foundation
import BrightcovePlayerSDK

open class PlayerViewModel: PlayerCallbackProtocol, ObservableObject {
    
    @Published public var playerState: PlayerState = PlayerState.forward
    
    @Published public var playbackSpeed: PlaybackSpeed = PlaybackSpeed.normal
    
    @Published public var videoQuality: VideoQuality = VideoQuality.veryHigh
    
    @Published public var downloadQuality: VideoQuality = VideoQuality.veryHigh
    
    @Published public var videoId: String? = nil
    
    @Published public var videoState: VideoState? = nil
    
    @Published public var showPlaybackSpeed: Bool = false
    
    @Published public var showVideoQuality: Bool = false
    
    @Published var showPlayerControls: Bool = false
    
    @Published public var screenMode: BCOVPUIScreenMode = BCOVPUIScreenMode.normal
    
    @Published public var orientation: UIDeviceOrientation = UIDeviceOrientation.unknown
    
    @Published public var videoProgress: Double? = nil
    
    public var videoDuration: Double? = nil
    
    public var resumeVideoProgress: Double? = nil
    
    public var playerControl: PlayerControls = PlayerControls()
    
    var accountId: String = PlayerUIConstants.accountId
    var policyKey: String = PlayerUIConstants.policyKey
    
    public init() {}
    
}

