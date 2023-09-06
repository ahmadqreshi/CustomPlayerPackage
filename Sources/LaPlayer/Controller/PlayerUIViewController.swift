import SwiftUI

struct PlayerUIViewController: UIViewControllerRepresentable {
    
    private var viewModel: PlayerViewModel
    
    init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> PlayerViewController {
        return PlayerViewController(
            playerViewModel: viewModel
        )
    }
        
    func updateUIViewController(_ uiViewController: PlayerViewController, context: Context) {}
}
