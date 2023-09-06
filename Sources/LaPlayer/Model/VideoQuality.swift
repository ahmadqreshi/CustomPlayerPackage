import Foundation

public enum VideoQuality: CaseIterable {
    case veryHigh, high, medium, low, veryLow
    
    public var quality: (label: String, quality: Int) {
        switch self {
        case .veryHigh: return ("1080p", 0)
        case .high: return ("720p", 4000000)
        case .medium: return ("360p", 1000000)
        case .low: return ("240p", 500000)
        case .veryLow: return ("144p", 200000)
        }
    }
    
}
