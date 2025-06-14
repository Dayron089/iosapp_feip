import Foundation

// MARK: - Модели данных для работы с API каталога товаров

/// Модель для списка товаров, получаемых с API
struct ProductListResponse: Codable {
    let items: [ProductDTO]
    let totalCount: Int
    let page: Int
    let pageSize: Int
}

/// Модель данных товара, полученного с API
struct ProductDTO: Codable {
    let id: String
    let title: String
    let description: String
    let price: PriceDTO
    let categoryId: String
    let categoryName: String
    let images: [ImageDTO]
    let colors: [ColorDTO]?
    let sizes: [SizeDTO]?
    let additionalInfo: String?
    let isNew: Bool
    
    /// Преобразует DTO-модель в доменную модель
    func toDomain() -> Product {
        return Product(
            image: images.first?.url ?? "",
            title: title,
            description: description,
            price: price.formatted,
            category: categoryName,
            additionalInfo: additionalInfo ?? "Информация отсутствует"
        )
    }
}

/// Модель для цены товара
struct PriceDTO: Codable {
    let value: Double
    let currency: String
    
    /// Форматированная строка цены
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        if let formattedValue = formatter.string(from: NSNumber(value: value)) {
            return "\(formattedValue) \(currency)"
        }
        return "\(Int(value)) \(currency)"
    }
}

/// Модель для изображения товара
struct ImageDTO: Codable {
    let id: String
    let url: String
    let isMain: Bool
}

/// Модель для цвета товара
struct ColorDTO: Codable {
    let id: String
    let name: String
    let hex: String
}

/// Модель для размера товара
struct SizeDTO: Codable {
    let id: String
    let name: String
    let inStock: Bool
}

/// Модель для категории товаров
struct CategoryDTO: Codable {
    let id: String
    let name: String
    let description: String?
    let imageUrl: String?
    let parentId: String?
}

/// Модель для ответа с категориями
struct CategoryListResponse: Codable {
    let items: [CategoryDTO]
    let totalCount: Int
} 