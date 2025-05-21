import Foundation

/// Типы ошибок сетевого слоя
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case serverError(Int, Data?)
    case noInternetConnection
    case unknown
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Недействительный URL"
        case .requestFailed(let error):
            return "Ошибка запроса: \(error.localizedDescription)"
        case .invalidResponse:
            return "Недействительный ответ от сервера"
        case .decodingFailed(let error):
            return "Ошибка декодирования данных: \(error.localizedDescription)"
        case .serverError(let statusCode, _):
            return "Ошибка сервера: \(statusCode)"
        case .noInternetConnection:
            return "Отсутствует подключение к интернету"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}

/// Менеджер сетевых запросов
class NetworkManager {
    
    // MARK: - Свойства
    static let shared = NetworkManager()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // MARK: - Инициализация
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0 // Тайм-аут 30 секунд
        configuration.httpAdditionalHeaders = ["Accept": "application/json"]
        
        self.session = URLSession(configuration: configuration)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
    // MARK: - Методы для выполнения запросов
    
    /// Выполнить запрос и получить результат в виде декодированного объекта
    /// - Parameters:
    ///   - endpoint: Эндпоинт для запроса
    ///   - type: Тип декодируемого объекта
    ///   - completion: Замыкание, вызываемое после завершения запроса
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let request = endpoint.urlRequest
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    completion(.failure(.noInternetConnection))
                } else {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Проверяем статус-код ответа
            let statusCode = httpResponse.statusCode
            guard (200...299).contains(statusCode) else {
                completion(.failure(.serverError(statusCode, data)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedObject = try self.decoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        
        task.resume()
    }
    
    /// Выполнить запрос и получить результат в виде Data
    /// - Parameters:
    ///   - endpoint: Эндпоинт для запроса
    ///   - completion: Замыкание, вызываемое после завершения запроса
    func requestData(
        endpoint: APIEndpoint,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        let request = endpoint.urlRequest
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    completion(.failure(.noInternetConnection))
                } else {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Проверяем статус-код ответа
            let statusCode = httpResponse.statusCode
            guard (200...299).contains(statusCode) else {
                completion(.failure(.serverError(statusCode, data)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    /// Асинхронное выполнение запроса (для iOS 15+)
    /// - Parameters:
    ///   - endpoint: Эндпоинт для запроса
    ///   - type: Тип декодируемого объекта
    /// - Returns: Результат выполнения запроса
    @available(iOS 15.0, *)
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) async -> Result<T, NetworkError> {
        let request = endpoint.urlRequest
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            // Проверяем статус-код ответа
            let statusCode = httpResponse.statusCode
            guard (200...299).contains(statusCode) else {
                return .failure(.serverError(statusCode, data))
            }
            
            do {
                let decodedObject = try self.decoder.decode(T.self, from: data)
                return .success(decodedObject)
            } catch {
                return .failure(.decodingFailed(error))
            }
        } catch let error as URLError where error.code == .notConnectedToInternet {
            return .failure(.noInternetConnection)
        } catch {
            return .failure(.requestFailed(error))
        }
    }
} 