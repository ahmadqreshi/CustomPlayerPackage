import SwiftUI
import LAResources

public struct LAPlayerView: View {
    
    @ObservedObject private var viewModel: PlayerViewModel
    
    public init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            
            PlayerUIViewController(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            if viewModel.videoState == .bufferEmpty {
                LottieView(fileName: LottieFilesName.preloader.set, isLooping: true, animationCompletes: nil)
                    .frame(width: Dimensions.cg50,  height: Dimensions.cg50)
            }
            
            if viewModel.showPlayerControls {
                VStack {
                    HStack {
                        Spacer()
                        
                        Text(viewModel.playbackSpeed.speed.label)
                            .frame(width: Dimensions.cg64, height: Dimensions.cg32, alignment: .center)
                            .foregroundColor(Color.white)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.showPlaybackSpeed.toggle()
                                viewModel.showVideoQuality = false
                            }
                        
                        Text(viewModel.videoQuality.quality.label)
                            .frame(width: Dimensions.cg64, height: Dimensions.cg32, alignment: .center)
                            .foregroundColor(Color.white)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.showPlaybackSpeed = false
                                viewModel.showVideoQuality.toggle()
                            }
                    }
                    Spacer()
                }
                .padding(.trailing, Dimensions.cg32)
                .padding(.top, Dimensions.cg16)
                
                HStack {
                    Spacer()
                    ImageAsset.icRewindBack.set
                        .onTapGesture {
                            viewModel.playerState = PlayerState.backward
                        }
                    Spacer()
                    
                    
                    ZStack {
                        Image(systemName: viewModel.playerState == .pause ? "play.fill" : "pause.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: Dimensions.cg30, height: Dimensions.cg40)
                        
                    }
                    .frame(width: Dimensions.cg100, height: Dimensions.cg100)
                    .onTapGesture {
                        viewModel.playerState = viewModel.playerState == .play ? .pause : .play
                    }
                    
                    
                    Spacer()
                    
                    
                    ImageAsset.icRewindForward.set
                        .onTapGesture {
                            viewModel.playerState = PlayerState.forward
                        }
                    Spacer()
                }
            }
            
            
            
//            if viewModel.showPlaybackSpeed {
//                PlabackSpeedView(
//                    showPlaybackSpeed: $viewModel.showPlaybackSpeed, defaultPlaybackSpeed: $viewModel.playbackSpeed,
//                    orientation: $viewModel.orientation
//                )
//            }
//
//            if viewModel.showVideoQuality {
//                VideoQualityView(
//                    showVideoQuality: $viewModel.showVideoQuality, defaultVideoQuality: $viewModel.videoQuality,
//                    orientation: $viewModel.orientation
//                )
//            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @ObservedObject static var viewModel: PlayerViewModel = PlayerViewModel()
    
    static var previews: some View {
        Group {
            LAPlayerView(viewModel: viewModel)
        }
    }
}
