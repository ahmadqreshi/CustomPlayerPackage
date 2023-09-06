import UIKit
import BrightcovePlayerSDK

class PlayerCustomLayout: NSObject {

    func setCustomLayout(forControlsView controlsView: BCOVPUIBasicControlView, playerControls: PlayerControls) -> (BCOVPUIControlLayout?, BCOVPUILayoutView?) {
        
        // Create a new control for each tag.
        // Controls are packaged inside a layout view.
        let playbackLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonPlayback, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
        
        let jumpBackButtonLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonJumpBack, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
        
        let currentTimeLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .labelCurrentTime, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
        
        let timeSeparatorLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .labelTimeSeparator, width: 12, elasticity: 0.0) // don't use default value because we're going to use a monospace font
        
        let durationLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .labelDuration, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
        
        let progressLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .sliderProgress, width: kBCOVPUILayoutUseDefaultValue, elasticity: 1.0)
        
        let closedCaptionLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonClosedCaption, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
        closedCaptionLayoutView?.isRemoved = true // Hide until it's explicitly needed.
        
        let screenModeLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .buttonScreenMode, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
        
        let externalRouteLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .viewExternalRoute, width: kBCOVPUILayoutUseDefaultValue, elasticity: 0.0)
        externalRouteLayoutView?.isRemoved = true // Hide until it's explicitly needed.
        
        let spacerLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .viewEmpty, width: kBCOVPUILayoutUseDefaultValue, elasticity: 1.0)
        
        let standardLogoLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .viewEmpty, width: 480, elasticity: 0.25)
        
        let compactLogoLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .viewEmpty, width: 36, elasticity: 0.1)
        
        let buttonLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .viewEmpty, width: 80, elasticity: 0.2)
        
        let labelLayoutView = BCOVPUIBasicControlView.layoutViewWithControl(from: .viewEmpty, width: 80, elasticity: 0.2)
        
        // Put UIImages inside our logo layout views.
        
        // Create logo image inside an image view for display in control bar.
//        if let standardLogoLayoutView = standardLogoLayoutView {
//            let standardLogoImageView = UIImageView(image: UIImage(named: "BrightcoveHorizontal_1115_x_269"))
//            standardLogoImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            standardLogoImageView.contentMode = .scaleAspectFill
//            standardLogoImageView.frame = standardLogoLayoutView.frame
//
//            // Add image view to our empty layout view.
//            standardLogoLayoutView.addSubview(standardLogoImageView)
//        }
        
        // Create logo image inside an image view for display in control bar.
//        if let compactLogoLayoutView = compactLogoLayoutView {
//            let compactLogoImageView = UIImageView(image: UIImage(named: "BrightcoveLogo_96_x_96"))
//            compactLogoImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            compactLogoImageView.contentMode = .scaleAspectFit
//            compactLogoImageView.frame = compactLogoLayoutView.frame
//            
//            // Add image view to our empty layout view.
//            compactLogoLayoutView.addSubview(compactLogoImageView)
//        }
        
        // Add UIButton to layout.
//        if let buttonLayoutView = buttonLayoutView {
//            let button = UIButton(frame: buttonLayoutView.frame)
//            button.setTitle("Tap Me", for: .normal)
//            button.setTitleColor(.green, for: .normal)
//            button.setTitleColor(.yellow, for: .highlighted)
//            buttonLayoutView.addSubview(button)
//
//            if let viewController = UIApplication.shared.delegate?.window??.rootViewController as? ViewController {
//                button.addTarget(viewController, action: #selector(ViewController.handleButtonTap(button:)), for: .touchUpInside)
//            }
//        }
        
        // Configure the standard layout lines.
//        let standardLayoutLine1 = [playbackLayoutView, currentTimeLayoutView, progressLayoutView, durationLayoutView, screenModeLayoutView, closedCaptionLayoutView]
        var standardLayoutLine1 = [playbackLayoutView, currentTimeLayoutView, progressLayoutView, durationLayoutView]
        if playerControls.screenMode {
            standardLayoutLine1.append(screenModeLayoutView)
        }
        standardLayoutLine1.append(closedCaptionLayoutView)
        
//        let standardLayoutLine2 = [buttonLayoutView, spacerLayoutView, standardLogoLayoutView, spacerLayoutView, labelLayoutView]
//
//        let standardLayoutLine3 = [jumpBackButtonLayoutView, spacerLayoutView, screenModeLayoutView]
//
        let standardLayoutLines = [standardLayoutLine1]
        
        // Configure the compact layout lines.
//        let compactLayoutLine1 = [playbackLayoutView, jumpBackButtonLayoutView, currentTimeLayoutView, timeSeparatorLayoutView, durationLayoutView, progressLayoutView, closedCaptionLayoutView, screenModeLayoutView, externalRouteLayoutView, compactLogoLayoutView]
        
        let compactLayoutLines = [standardLayoutLine1]
        
        // Put the two layout lines into a single control layout object.
        let layout = BCOVPUIControlLayout(standardControls: standardLayoutLines, compactControls: compactLayoutLines)

        return (layout, playbackLayoutView)
    }

}

