import Foundation

public enum PlaybackSpeed: CaseIterable {
    case threeQuarter, normal, normalQuarter, normalHalf, normalThreeQuarter, double
    
    public var speed: (label: String, rate: Float) {
        switch self {
        case .threeQuarter: return ("0.75x", 0.75)
        case .normal: return ("1.0x", 1.0)
        case .normalQuarter: return ("1.25x", 1.25)
        case .normalHalf: return ("1.5x", 1.5)
        case .normalThreeQuarter: return ("1.75x", 1.75)
        case .double: return ("2.0x", 2.0)
        }
    }
}
