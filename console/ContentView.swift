import SwiftUI
import UIKit

struct CatalogViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CatalogViewController {
        return CatalogViewController()
    }

    func updateUIViewController(_ uiViewController: CatalogViewController, context: Context) {
    }
}

struct ContentView: View {
    var body: some View {
        CatalogViewControllerRepresentable()
             .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
