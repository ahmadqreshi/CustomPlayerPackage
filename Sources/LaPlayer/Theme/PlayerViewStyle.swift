//
//  PlayerViewStyle.swift
//  Player
//
//  Created by Rimish Bansod on 17/11/22.
//

import UIKit
import LAResources
import BrightcovePlayerSDK

class PlayerViewStyle: NSObject {
    
    func setCustomStyle(forControlsView controlsView: BCOVPUIBasicControlView) {
        
//        let font = UIFont(name: "Courier", size: 18)
        
//        controlsView.currentTimeLabel.font = font
//        controlsView.currentTimeLabel.textColor = .white
//        controlsView.durationLabel.font = font
//        controlsView.durationLabel.textColor = .white
//
//        controlsView.timeSeparatorLabel.font = font
//        controlsView.timeSeparatorLabel.textColor = .green
        
        // Change color of full-screen button.
//        controlsView.screenModeButton?.setTitleColor(.orange, for: .normal)
//        controlsView.screenModeButton?.setTitleColor(.lightGray, for: .highlighted)
        
        // Change color of jump back button.
//        controlsView.jumpBackButton?.setTitleColor(.orange, for: .normal)
//        controlsView.jumpBackButton?.setTitleColor(.yellow, for: .highlighted)
        
        // Change color of play/pause button.
//        controlsView.playbackButton?.setTitleColor(.white, for: .normal)
//        controlsView.playbackButton?.setTitleColor(.lightGray, for: .highlighted)
        
        // Customize the slider
        let slider = controlsView.progressSlider
        if #available(iOS 14.0, *) {
            slider?.bufferProgressTintColor = UIColor(ColorAsset.seekbarBuffered.set)
            slider?.minimumTrackTintColor = UIColor(ColorAsset.seekbarProgress.set)
            slider?.maximumTrackTintColor = UIColor(ColorAsset.seekbarTrack.set)
        } else {
            // Fallback on earlier versions
        }
        
//        slider?.thumbTintColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 0.5)
        
        // Add markers to the slider for your own use
//        slider?.markerTickColor = .lightGray
//        slider?.addMarker(at: 30, duration: 0.0, isAd: false, image: nil)
//        slider?.addMarker(at: 60, duration: 0.0, isAd: false, image: nil)
//        slider?.addMarker(at: 90, duration: 0.0, isAd: false, image: nil)
        
    }

}

