import Foundation

/// Конфигурация API магазина
struct CatalogAPIConfig {
    /// Базовый URL для API
    static let baseURL = URL(string: "https://api.myshop.com/v1")!
    
    /// Ключ API для авторизации запросов
    static let apiKey = "your-api-key-here" // TODO: Замените на ваш API ключ
    
    /// Стандартные заголовки для API-запросов
    static var defaultHeaders: [String: String] {
        return [
            "Accept": "application/json",
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
    }
}

/// Эндпоинты для работы с каталогом товаров
enum CatalogEndpoint: APIEndpoint {
    /// Получение списка товаров
    case products(page: Int, pageSize: Int, categoryId: String?)
    
    /// Получение информации о конкретном товаре
    case product(id: String)
    
    /// Получение списка категорий
    case categories
    
    /// Получение конкретной категории
    case category(id: String)
    
    /// Поиск товаров
    case search(query: String, page: Int, pageSize: Int)
    
    /// Базовый URL для всех эндпоинтов каталога
    var baseURL: URL {
        return CatalogAPIConfig.baseURL
    }
    
    /// Путь к ресурсу в зависимости от эндпоинта
    var path: String {
        switch self {
        case .products:
            return "/products"
        case .product(let id):
            return "/products/\(id)"
        case .categories:
            return "/categories"
        case .category(let id):
            return "/categories/\(id)"
        case .search:
            return "/products/search"
        }
    }
    
    /// HTTP-метод запроса
    var method: HTTPMethod {
        return .get // Все эндпоинты используют GET
    }
    
    /// Параметры запроса
    var parameters: [String: Any]? {
        switch self {
        case .products(let page, let pageSize, let categoryId):
            var params: [String: Any] = [
                "page": page,
                "pageSize": pageSize
            ]
            
            if let categoryId = categoryId {
                params["categoryId"] = categoryId
            }
            
            return params
            
        case .product:
            return nil
            
        case .categories:
            return nil
            
        case .category:
            return nil
            
        case .search(let query, let page, let pageSize):
            return [
                "query": query,
                "page": page,
                "pageSize": pageSize
            ]
        }
    }
    
    /// Заголовки запроса
    var headers: [String: String]? {
        return CatalogAPIConfig.defaultHeaders
    }
} 