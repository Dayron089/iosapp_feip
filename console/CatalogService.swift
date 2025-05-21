import Foundation

/// Сервис для работы с каталогом товаров
class CatalogService {
    private let networkManager = NetworkManager.shared
    
    /// Получить список товаров
    /// - Parameters:
    ///   - page: Номер страницы
    ///   - pageSize: Размер страницы
    ///   - categoryId: ID категории (опционально)
    ///   - completion: Замыкание, вызываемое после получения результата
    func getProducts(
        page: Int = 1,
        pageSize: Int = 20,
        categoryId: String? = nil,
        completion: @escaping (Result<ProductListResponse, NetworkError>) -> Void
    ) {
        let endpoint = CatalogEndpoint.products(page: page, pageSize: pageSize, categoryId: categoryId)
        networkManager.request(endpoint: endpoint, responseType: ProductListResponse.self, completion: completion)
    }
    
    /// Получить информацию о конкретном товаре
    /// - Parameters:
    ///   - id: ID товара
    ///   - completion: Замыкание, вызываемое после получения результата
    func getProduct(id: String, completion: @escaping (Result<ProductDTO, NetworkError>) -> Void) {
        let endpoint = CatalogEndpoint.product(id: id)
        networkManager.request(endpoint: endpoint, responseType: ProductDTO.self, completion: completion)
    }
    
    /// Получить список категорий
    /// - Parameter completion: Замыкание, вызываемое после получения результата
    func getCategories(completion: @escaping (Result<CategoryListResponse, NetworkError>) -> Void) {
        let endpoint = CatalogEndpoint.categories
        networkManager.request(endpoint: endpoint, responseType: CategoryListResponse.self, completion: completion)
    }
    
    /// Поиск товаров
    /// - Parameters:
    ///   - query: Строка поиска
    ///   - page: Номер страницы
    ///   - pageSize: Размер страницы
    ///   - completion: Замыкание, вызываемое после получения результата
    func searchProducts(
        query: String,
        page: Int = 1,
        pageSize: Int = 20,
        completion: @escaping (Result<ProductListResponse, NetworkError>) -> Void
    ) {
        let endpoint = CatalogEndpoint.search(query: query, page: page, pageSize: pageSize)
        networkManager.request(endpoint: endpoint, responseType: ProductListResponse.self, completion: completion)
    }
    
    // Асинхронные версии методов (для iOS 15+)
    
    /// Получить список товаров асинхронно
    /// - Parameters:
    ///   - page: Номер страницы
    ///   - pageSize: Размер страницы
    ///   - categoryId: ID категории (опционально)
    /// - Returns: Результат запроса
    @available(iOS 15.0, *)
    func getProducts(
        page: Int = 1,
        pageSize: Int = 20,
        categoryId: String? = nil
    ) async -> Result<ProductListResponse, NetworkError> {
        let endpoint = CatalogEndpoint.products(page: page, pageSize: pageSize, categoryId: categoryId)
        return await networkManager.request(endpoint: endpoint, responseType: ProductListResponse.self)
    }
    
    /// Получить информацию о конкретном товаре асинхронно
    /// - Parameter id: ID товара
    /// - Returns: Результат запроса
    @available(iOS 15.0, *)
    func getProduct(id: String) async -> Result<ProductDTO, NetworkError> {
        let endpoint = CatalogEndpoint.product(id: id)
        return await networkManager.request(endpoint: endpoint, responseType: ProductDTO.self)
    }
    
    /// Получить список категорий асинхронно
    /// - Returns: Результат запроса
    @available(iOS 15.0, *)
    func getCategories() async -> Result<CategoryListResponse, NetworkError> {
        let endpoint = CatalogEndpoint.categories
        return await networkManager.request(endpoint: endpoint, responseType: CategoryListResponse.self)
    }
    
    /// Поиск товаров асинхронно
    /// - Parameters:
    ///   - query: Строка поиска
    ///   - page: Номер страницы
    ///   - pageSize: Размер страницы
    /// - Returns: Результат запроса
    @available(iOS 15.0, *)
    func searchProducts(
        query: String,
        page: Int = 1,
        pageSize: Int = 20
    ) async -> Result<ProductListResponse, NetworkError> {
        let endpoint = CatalogEndpoint.search(query: query, page: page, pageSize: pageSize)
        return await networkManager.request(endpoint: endpoint, responseType: ProductListResponse.self)
    }
}
