import SwiftUI

struct ViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update the view controller if needed
    }
}

struct ContentView: View {
    var body: some View {
        ViewControllerWrapper()
    }
}
