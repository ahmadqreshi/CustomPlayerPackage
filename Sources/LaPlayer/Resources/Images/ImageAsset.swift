
import Foundation
import SwiftUI

enum ImageAsset : String {
    
    case checkMark
    case icRewindBack
    case icRewindForward
    
    var set : Image {
        return Image(self.rawValue, bundle: .module)
    }
}
