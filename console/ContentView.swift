import SwiftUI
import UIKit

struct ProductDetailViewRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> ProductDetailViewController {
        return ProductDetailViewController()
    }

    func updateUIViewController(_ uiViewController: ProductDetailViewController, context: Context) {
    }
}


struct ContentView: View {
    var body: some View {
        ProductDetailViewRepresentable()
             .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
