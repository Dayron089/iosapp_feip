import Foundation

/// Протокол для описания API-эндпоинта
protocol APIEndpoint {
    /// Базовый URL API
    var baseURL: URL { get }
    
    /// Путь к ресурсу
    var path: String { get }
    
    /// HTTP-метод запроса
    var method: HTTPMethod { get }
    
    /// Параметры запроса
    var parameters: [String: Any]? { get }
    
    /// Заголовки запроса
    var headers: [String: String]? { get }
    
    /// Полный URL запроса
    var url: URL { get }
}

/// HTTP-методы для запросов
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Расширение для реализации стандартной логики
extension APIEndpoint {
    var url: URL {
        let url = baseURL.appendingPathComponent(path)
        
        // Если метод GET и есть параметры, добавляем их к URL
        guard method == .get, let parameters = parameters, !parameters.isEmpty else {
            return url
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = parameters.map { 
            URLQueryItem(name: $0, value: "\($1)")
        }
        
        return components.url ?? url
    }
    
    /// Создание URLRequest из эндпоинта
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Добавление заголовков
        if let headers = headers {
            headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        }
        
        // Добавление тела запроса для POST, PUT, PATCH
        if method != .get, let parameters = parameters, !parameters.isEmpty {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error serializing parameters: \(error)")
            }
        }
        
        return request
    }
} 