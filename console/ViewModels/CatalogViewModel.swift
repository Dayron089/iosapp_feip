import Foundation

/// ViewModel для экрана каталога товаров
final class CatalogViewModel {
    // MARK: - Типы
    
    /// Категория товаров
    struct Category {
        let name: String
        let isSelected: Bool
    }
    
    // MARK: - Публичные свойства
    
    /// Список категорий
    private(set) var categories: [String] = ["Новинки", "Джинсы", "Футболки"]
    
    /// Выбранная категория
    private(set) var selectedCategory: String = "Футболки"
    
    /// Список всех товаров
    private(set) var allProducts: [Product] = []
    
    /// Отфильтрованные товары по выбранной категории
    private(set) var filteredProducts: [Product] = []
    
    /// Корзина товаров
    var cart: Cart {
        return Cart.shared
    }
    
    /// Блок для обновления UI при изменении данных
    var onDataChanged: (() -> Void)?
    
    // MARK: - Зависимости
    private let catalogService: CatalogService
    
    // MARK: - Инициализация
    
    init(catalogService: CatalogService = CatalogService()) {
        self.catalogService = catalogService
        
        // Загружаем список товаров
        loadProducts()
    }
    
    // MARK: - Публичные методы
    
    /// Выбор категории
    /// - Parameter category: Имя категории
    func selectCategory(_ category: String) {
        guard categories.contains(category), selectedCategory != category else { return }
        
        selectedCategory = category
        filterProductsByCategory(category)
        onDataChanged?()
    }
    
    /// Получить категории в формате модели для отображения
    /// - Returns: Список категорий
    func getCategoriesForDisplay() -> [Category] {
        return categories.map { Category(name: $0, isSelected: $0 == selectedCategory) }
    }
    
    /// Обновить список товаров
    func refreshProducts() {
        loadProducts()
    }
    
    /// Проверить, находится ли товар в корзине
    /// - Parameter product: Товар для проверки
    /// - Returns: true, если товар в корзине
    func isProductInCart(_ product: Product) -> Bool {
        return cart.items.contains(where: { $0.product.title == product.title })
    }
    
    /// Получить товар из корзины
    /// - Parameter product: Товар для поиска
    /// - Returns: Элемент корзины или nil
    func getCartItem(for product: Product) -> CartItem? {
        return cart.items.first(where: { $0.product.title == product.title })
    }
    
    // MARK: - Приватные методы
    
    /// Загрузка списка товаров
    private func loadProducts() {
        // В реальном приложении здесь был бы запрос к API
        // Для примера используем предварительно подготовленные данные
        allProducts = [
            // Новинки
            Product(image: "blazer", title: "Блейзер прямого кроя", description: "Двубортный блейзер на основе лиоцелла и вискозы.", price: "2 970 ₽", category: "Новинки", additionalInfo: "Состав: 70% лиоцелл, 30% вискоза. Подкладка: 100% вискоза. Рекомендуется сухая чистка. Сделано в Португалии."),
            Product(image: "cardigan", title: "Кардиган из хлопка", description: "Короткие рукава. Застежка на пуговицы.", price: "14 999 ₽", category: "Новинки", additionalInfo: "Состав: 100% хлопок премиум-класса. Машинная стирка при 30°C. Бережный отжим. Сделано в Италии."),
            Product(image: "coat", title: "Пальто с поясом", description: "Элегантное пальто из шерсти с поясом и боковыми карманами.", price: "8 490 ₽", category: "Новинки", additionalInfo: "Состав: 80% шерсть, 20% полиэстер. Подкладка: 100% полиэстер. Сухая чистка. Прямой крой. Сделано в Турции."),
            Product(image: "jacket", title: "Куртка-бомбер", description: "Стильная куртка из экокожи с передними карманами.", price: "5 990 ₽", category: "Новинки", additionalInfo: "Состав: экологичная искусственная кожа. Подкладка: 100% полиэстер. Протирать влажной тканью. Не стирать. Коллекция осень-зима 2023."),
            
            // Джинсы
            Product(image: "jeans", title: "Джинсы straight fit", description: "Пять карманов. Прямой крой.", price: "3 999 ₽", category: "Джинсы", additionalInfo: "Состав: 99% хлопок, 1% эластан. Высота посадки: средняя. Машинная стирка при 40°C. Не отбеливать. Страна производства: Бангладеш."),
            Product(image: "jeans_slim", title: "Джинсы slim", description: "Зауженный крой. Тёмно-синий деним.", price: "3 299 ₽", category: "Джинсы", additionalInfo: "Состав: 92% хлопок, 6% полиэстер, 2% эластан. Высота посадки: средняя. Машинная стирка при 30°C. Можно сушить в машине при низкой температуре."),
            Product(image: "jeans_wide", title: "Джинсы wide leg", description: "Широкий крой. Высокая посадка.", price: "4 299 ₽", category: "Джинсы", additionalInfo: "Состав: 100% хлопок. Высота посадки: высокая. Машинная стирка при 30°C. Не отбеливать. Длина по внутреннему шву: 79 см."),
            Product(image: "pants", title: "Брюки из лиоцелла", description: "Брюки прямого кроя из ткани.", price: "2 490 ₽", category: "Джинсы", additionalInfo: "Состав: 100% лиоцелл. Эластичный пояс. Боковые карманы. Машинная стирка при 30°C. Не сушить в машине. Экологичное производство."),
            
            // Футболки
            Product(image: "tshirt1", title: "Футболка базовая", description: "Футболка из хлопка. Круглый вырез.", price: "1 290 ₽", category: "Футболки", additionalInfo: "Состав: 100% органический хлопок. Круглый вырез. Прямой крой. Машинная стирка при 40°C. Сертификат GOTS (Global Organic Textile Standard)."),
            Product(image: "tshirt2", title: "Футболка с принтом", description: "Хлопковая футболка с графическим принтом.", price: "1 790 ₽", category: "Футболки", additionalInfo: "Состав: 100% хлопок. Принт нанесен экологичными красками на водной основе. Машинная стирка при 30°C. Гладить с изнаночной стороны."),
            Product(image: "tshirt3", title: "Поло с коротким рукавом", description: "Тенниска из хлопкового пике.", price: "2 190 ₽", category: "Футболки", additionalInfo: "Состав: 95% хлопок, 5% эластан. Застежка на пуговицы. Отложной воротник. Машинная стирка при 40°C. Страна производства: Португалия."),
            Product(image: "tshirt4", title: "Лонгслив оверсайз", description: "Футболка с длинным рукавом свободного кроя.", price: "1 990 ₽", category: "Футболки", additionalInfo: "Состав: 80% хлопок, 20% полиэстер. Свободный крой. Удлиненная спинка. Машинная стирка при 30°C. Не отбеливать. Низкая температура глажки.")
        ]
        
        // Применяем фильтр
        filterProductsByCategory(selectedCategory)
    }
    
    /// Фильтрация товаров по категории
    /// - Parameter category: Категория для фильтрации
    private func filterProductsByCategory(_ category: String) {
        filteredProducts = allProducts.filter { $0.category == category }
    }
} 