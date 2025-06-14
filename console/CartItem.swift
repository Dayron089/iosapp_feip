import Foundation

class CartItem {
    let product: Product
    var quantity: Int
    var size: String
    var color: String?
    
    var totalPrice: Double {
        let priceString = product.price.replacingOccurrences(of: " ", with: "")
                                       .replacingOccurrences(of: "₽", with: "")
        if let price = Double(priceString) {
            return price * Double(quantity)
        }
        return 0
    }
    
    var formattedTotalPrice: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        
        if let formattedPrice = formatter.string(from: NSNumber(value: totalPrice)) {
            return "\(formattedPrice) ₽"
        }
        return "\(Int(totalPrice)) ₽"
    }
    
    init(product: Product, quantity: Int = 1, size: String, color: String? = nil) {
        self.product = product
        self.quantity = quantity
        self.size = size
        self.color = color
    }
} 