
import SwiftUI
import LAResources

public struct VideoQualityView: View {
    
    @Binding private var showVideoQuality: Bool
    
    @Binding private var defaultVideoQuality: VideoQuality
    
    @Binding private var orientation: UIDeviceOrientation
    
    public init(
        showVideoQuality: Binding<Bool>,
        defaultVideoQuality: Binding<VideoQuality>,
        orientation: Binding<UIDeviceOrientation>
    ) {
        self._showVideoQuality = showVideoQuality
        self._defaultVideoQuality = defaultVideoQuality
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
                    Text("Quality")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(ColorAsset.settingTitle.set)
                        .font(AppFonts.manropeRegular.withDefaultSize())
                    
                    Spacer()
                }
                

                ForEach(VideoQuality.allCases, id:\.self) { quality in
                    HStack {
                        Text(quality.quality.label)
                            .font(AppFonts.manropeRegular.withSize(16).weight(quality == defaultVideoQuality ? .bold : .regular))
                            .foregroundColor(quality == defaultVideoQuality ? ColorAsset.cyanBlue.set : Color.white)
                            .padding([.top, .bottom], 10)

                        Spacer()

                        if quality == defaultVideoQuality {
                            ImageAsset.checkMark.set
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        defaultVideoQuality = quality
                        showVideoQuality.toggle()
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
            showVideoQuality.toggle()
        }
        .edgesIgnoringSafeArea(.all)
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}

struct VideoQualityView_Previews: PreviewProvider {
    
    @State static var showVideoQuality: Bool = false
    @ObservedObject static var viewModel = PlayerViewModel()
    
    @State static var defaultVideoQuality: VideoQuality = VideoQuality.veryHigh
    
    static var previews: some View {
        VideoQualityView(
            showVideoQuality: $showVideoQuality,
            defaultVideoQuality: $defaultVideoQuality,
            orientation: $viewModel.orientation
        )
    }
}
