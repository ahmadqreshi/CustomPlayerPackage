import SwiftUI
import LAResources

public struct PlabackSpeedView: View {
    
    @Binding private var showPlaybackSpeed: Bool
    
    @Binding private var defaultPlaybackSpeed: PlaybackSpeed
    
    @Binding private var orientation: UIDeviceOrientation
    
    public init(
        showPlaybackSpeed: Binding<Bool>,
        defaultPlaybackSpeed: Binding<PlaybackSpeed>,
        orientation: Binding<UIDeviceOrientation>
    ) {
        self._showPlaybackSpeed = showPlaybackSpeed
        self._defaultPlaybackSpeed = defaultPlaybackSpeed
        self._orientation = orientation
    }
    
    public var body: some View {
        
        VStack {
            
            HStack {
                Spacer()
            }
            
            Spacer()
            
            VStack {
                
                HStack {
                    Text("Playback Speed")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(ColorAsset.settingTitle.set)
                        .font(AppFonts.manropeRegular.withDefaultSize())
                    
                    Spacer()
                }
                
                ForEach(PlaybackSpeed.allCases, id:\.self) { speed in
                    HStack {
                        Text(speed.speed.label == PlaybackSpeed.normal.speed.label ? "Normal" : speed.speed.label)
                            .font(AppFonts.manropeRegular.withSize(16).weight(speed == defaultPlaybackSpeed ? .bold : .regular))
                            .foregroundColor(speed == defaultPlaybackSpeed ? ColorAsset.cyanBlue.set : Color.white)
                            .padding([.top, .bottom], 10)
                            
                        
                        Spacer()
                        
                        if speed == defaultPlaybackSpeed {
                            ImageAsset.checkMark.set
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        defaultPlaybackSpeed = speed
                        showPlaybackSpeed.toggle()
                    }
                }
            }
            .padding([.trailing, .leading, .top], 16)
            .padding(.bottom, orientation.isPortrait ? 20 : 16)
            .frame(maxWidth: orientation.isPortrait ? .infinity : 300)
            .background(Color.black)
            
            Spacer()
            
        }
        .background(Color.black.opacity(0.6))
        .onTapGesture {
            showPlaybackSpeed.toggle()
        }
        .edgesIgnoringSafeArea(.all)
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        
    }
}

struct PlabackSpeedView_Previews: PreviewProvider {
    
    @State static var showPlaybackSpeed: Bool = false
    
    @ObservedObject static var viewModel = PlayerViewModel()
    
    @State static var defaultPlaybackSpeed: PlaybackSpeed = PlaybackSpeed.normal
    
    static var previews: some View {
        PlabackSpeedView(
            showPlaybackSpeed: $showPlaybackSpeed,
            defaultPlaybackSpeed: $defaultPlaybackSpeed,
            orientation: $viewModel.orientation
        )
    }
}
