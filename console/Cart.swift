import Foundation

class Cart {
    static let shared = Cart()
    
    private(set) var items: [CartItem] = []
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
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
    
    var itemCount: Int {
        items.count
    }
    
    private init() {}
    
    func addItem(_ item: CartItem) {
        // Проверяем наличие такого же товара в корзине
        if let index = items.firstIndex(where: { 
            $0.product.title == item.product.title && 
            $0.size == item.size &&
            $0.color == item.color
        }) {
            // Если такой товар уже есть, увеличиваем количество
            items[index].quantity += item.quantity
        } else {
            // Если такого товара нет, добавляем новый
            items.append(item)
        }
    }
    
    func removeItem(at index: Int) {
        guard index >= 0 && index < items.count else { return }
        items.remove(at: index)
    }
    
    func updateQuantity(at index: Int, to quantity: Int) {
        guard index >= 0 && index < items.count else { return }
        
        if quantity <= 0 {
            removeItem(at: index)
        } else {
            items[index].quantity = quantity
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    func findCartItem(for productTitle: String, size: String, color: String? = nil) -> CartItem? {
        return items.first { item in
            item.product.title == productTitle && 
            item.size == size &&
            item.color == color
        }
    }
} 