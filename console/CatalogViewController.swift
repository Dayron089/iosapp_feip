import UIKit

class CatalogViewController: UIViewController {
    
    // MARK: - Константы и переменные
    private let categories = ["Новинки", "Джинсы", "Футболки"]
    private var allProducts = [
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
    
    private var filteredProducts: [Product] = []
    private var selectedCategory = "Футболки" // Начальная выбранная категория
    
    // MARK: - UI элементы
    private lazy var categoryScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var categoryDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        return tableView
    }()
    
    private lazy var tabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Создаем кнопки таб-бара напрямую, без промежуточных container views
        let menuButton = createDirectTabBarButton(title: "Меню", imageName: "square.grid.2x2", isSelected: true, tag: 0)
        menuButton.addTarget(self, action: #selector(menuTabButtonTapped), for: .touchUpInside)
        
        let cartButton = createDirectTabBarButton(title: "Корзина", imageName: "cart", isSelected: false, tag: 1)
        cartButton.addTarget(self, action: #selector(cartTabButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(menuButton)
        stackView.addArrangedSubview(cartButton)
        
        // Сохраняем ссылки на кнопки для использования
        self.menuTabBarItemView = menuButton
        self.cartTabBarItemView = cartButton
        
        return view
    }()
    
    private weak var menuTabBarItemView: UIButton?
    private weak var cartTabBarItemView: UIButton?
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCategories()
        
        // Фильтруем товары по выбранной категории
        filterProductsByCategory(selectedCategory)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Добавляем наблюдателей за уведомлениями
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: Notification.Name.cartUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleProductAddedToCart), name: NSNotification.Name.productAddedToCart, object: nil)

        updateCartBadge() // Первоначальное обновление
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Обновляем данные таблицы каждый раз, когда контроллер появляется
        // Это обеспечит обновление состояния кнопок товаров (цена/количество)
        tableView.reloadData()
        updateCartBadge() // Также обновляем бейдж корзины
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.cartUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.productAddedToCart, object: nil)
    }
    
    // MARK: - UI настройка
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(categoryScrollView)
        view.addSubview(categoryDivider)
        view.addSubview(tableView)
        view.addSubview(tabBar)
        
        categoryScrollView.addSubview(categoryStackView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Категории
            categoryScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 60),
            
            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor, constant: 10),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: -10),
            categoryStackView.heightAnchor.constraint(equalToConstant: 40),
            
            // Разделитель
            categoryDivider.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryDivider.heightAnchor.constraint(equalToConstant: 1),
            
            // Таблица товаров
            tableView.topAnchor.constraint(equalTo: categoryDivider.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            
            // Таб-бар
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupCategories() {
        for (index, category) in categories.enumerated() {
            // Активной делаем выбранную категорию
            let isSelected = category == selectedCategory
            let button = createCategoryButton(title: category, isSelected: isSelected)
            categoryStackView.addArrangedSubview(button)
        }
    }
    
    private func setupTabBarReferences() {
        // Этот метод больше не нужен, так как ссылки устанавливаются при создании tabBar
        // Оставим его пустым для обратной совместимости
    }
    
    // MARK: - Вспомогательные методы
    private func createCategoryButton(title: String, isSelected: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 20
        button.backgroundColor = isSelected ? UIColor(red: 92/255, green: 64/255, blue: 51/255, alpha: 1.0) : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        button.setTitleColor(isSelected ? .white : .darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func createDirectTabBarButton(title: String, imageName: String, isSelected: Bool = false, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Создаем контейнер для иконки и текста
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        button.addSubview(stackView)
        
        // Настраиваем иконку
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let iconImage = UIImage(systemName: imageName, withConfiguration: imageConfig)
        let iconImageView = UIImageView(image: iconImage)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = isSelected ? .black : .systemGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Настраиваем текст
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = isSelected ? .black : .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return button
    }
    
    // MARK: - Обработчики событий
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        // Обновляем внешний вид кнопок
        for case let button as UIButton in categoryStackView.arrangedSubviews {
            button.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            button.setTitleColor(.darkGray, for: .normal)
        }
        
        sender.backgroundColor = UIColor(red: 92/255, green: 64/255, blue: 51/255, alpha: 1.0)
        sender.setTitleColor(.white, for: .normal)
        
        // Фильтруем товары по выбранной категории
        filterProductsByCategory(title)
    }
    
    @objc private func menuTabButtonTapped() {
        print("Нажата кнопка Меню через прямой метод")
        if let menuView = menuTabBarItemView {
            updateSpecificTabBarButtonAppearance(menuView, isSelected: true)
        }
        if let cartView = cartTabBarItemView {
            updateSpecificTabBarButtonAppearance(cartView, isSelected: false)
        }
    }
    
    @objc private func cartTabButtonTapped() {
        print("DEBUG: Нажата кнопка Корзина")
        
        // Проверяем наличие navigationController
        if let navController = self.navigationController {
            print("DEBUG: navigationController найден: \(navController)")
            
            // Проверяем стек навигации
            print("DEBUG: Текущий стек навигации: \(navController.viewControllers)")
            
            // Предыдущая реализация
            navigateToCart()
        } else {
            print("DEBUG: navigationController отсутствует, используем альтернативный способ")
            
            // Альтернативный способ - показываем модально
            presentCartModally()
        }
    }
    
    // Альтернативный метод для открытия корзины модально, если навигация не работает
    private func presentCartModally() {
        let cartVC = CartViewController()
        
        // Добавляем navigation controller, чтобы была кнопка закрытия
        let navController = UINavigationController(rootViewController: cartVC)
        
        // Добавляем кнопку закрытия
        cartVC.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, 
            target: self, 
            action: #selector(dismissCartModal)
        )
        
        // Показываем модально
        present(navController, animated: true, completion: nil)
        print("DEBUG: Корзина показана модально")
    }
    
    @objc private func dismissCartModal() {
        dismiss(animated: true, completion: nil)
        print("DEBUG: Модальная корзина закрыта")
    }
    
    private func filterProductsByCategory(_ category: String) {
        selectedCategory = category
        filteredProducts = allProducts.filter { $0.category == category }
        tableView.reloadData()
    }
    
    // Метод для показа детальной информации о товаре
    private func showProductDetail(for product: Product) {
        let detailVC = ProductDetailViewController()
        detailVC.product = product
        
        // Настройка модального представления
        detailVC.modalPresentationStyle = .pageSheet // Возвращаем .pageSheet для модального вида
        
        // Настройка, чтобы можно было закрыть экран свайпом вниз
        if let sheet = detailVC.sheetPresentationController {
            // Убираем системный индикатор, чтобы не было тени и двойных линий
            sheet.prefersGrabberVisible = false // Убираем grabber
            sheet.preferredCornerRadius = 20
            // Устанавливаем только .large() для открытия на максимальную высоту модального окна
            sheet.detents = [.large()]
            // Опционально: установить .large() как выбранный по умолчанию, если есть другие detents
            // sheet.selectedDetentIdentifier = .large 
        }
        
        present(detailVC, animated: true)
    }
    
    func navigateToCart() {
        print("DEBUG: Запущен navigateToCart()")
        // Перед переходом убедимся, что кнопка корзины выглядит выделенной, а меню - нет
        if let cartView = cartTabBarItemView {
            updateSpecificTabBarButtonAppearance(cartView, isSelected: true)
            print("DEBUG: Внешний вид кнопки корзины обновлен")
        }
        if let menuView = menuTabBarItemView {
            updateSpecificTabBarButtonAppearance(menuView, isSelected: false)
            print("DEBUG: Внешний вид кнопки меню обновлен")
        }

        let cartVC = CartViewController()
        print("DEBUG: CartViewController создан: \(cartVC)")
        
        if let navController = navigationController {
            print("DEBUG: Выполняем pushViewController в navController: \(navController)")
            navController.pushViewController(cartVC, animated: true)
            print("DEBUG: pushViewController выполнен")
        } else {
            print("DEBUG: ОШИБКА! navigationController = nil, pushViewController невозможен")
            // Альтернативное решение - показать модально
            presentCartModally()
        }
    }

    private func updateSpecificTabBarButtonAppearance(_ button: UIButton, isSelected: Bool) {
        if let internalStackView = button.subviews.first(where: { $0 is UIStackView }) as? UIStackView {
            if let iconImageView = internalStackView.arrangedSubviews.first(where: { $0 is UIImageView }) as? UIImageView {
                iconImageView.tintColor = isSelected ? .black : .systemGray
            }
            if let label = internalStackView.arrangedSubviews.first(where: { $0 is UILabel }) as? UILabel {
                label.textColor = isSelected ? .black : .systemGray
            }
        } else {
            button.tintColor = isSelected ? .black : .systemGray
            button.setTitleColor(isSelected ? .black : .systemGray, for: .normal)
        }
    }
    
    @objc private func updateCartBadge() {
        guard let targetCartView = cartTabBarItemView else {
            return
        }

        let itemCount = Cart.shared.itemCount
        let badgeTag = 123
        
        var badgeLabel = targetCartView.viewWithTag(badgeTag) as? UILabel
        
        // Логика отображения/скрытия и обновления текста бейджа
        if itemCount > 0 {
            if badgeLabel == nil {
                // Создаем бейдж, если его нет
                badgeLabel = UILabel()
                badgeLabel!.tag = badgeTag
                badgeLabel!.backgroundColor = .red
                badgeLabel!.textColor = .white
                badgeLabel!.font = UIFont.systemFont(ofSize: 10, weight: .bold)
                badgeLabel!.textAlignment = .center
                badgeLabel!.layer.cornerRadius = 9
                badgeLabel!.layer.masksToBounds = true
                badgeLabel!.translatesAutoresizingMaskIntoConstraints = false
                targetCartView.addSubview(badgeLabel!)
                
                if let stackView = targetCartView.subviews.first as? UIStackView,
                   let iconImageView = stackView.arrangedSubviews.first as? UIImageView {
                     NSLayoutConstraint.activate([
                        badgeLabel!.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: -4),
                        badgeLabel!.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                        badgeLabel!.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
                        badgeLabel!.heightAnchor.constraint(equalToConstant: 18)
                    ])
                } else {
                     print("Не удалось найти ImageView для бейджа на кнопке корзины")
                }
            }
            badgeLabel?.text = "\(itemCount)"
            badgeLabel?.isHidden = false
        } else {
            badgeLabel?.isHidden = true
        }
        
        // Всегда перезагружаем таблицу каталога при любом обновлении корзины.
        // Это гарантирует, что состояние ячеек (кнопка цены или контрол количества)
        // будет соответствовать актуальному состоянию Cart.shared.
        tableView.reloadData()
    }
    
    @objc private func handleProductAddedToCart() {
        // Обновляем бейдж корзины
        updateCartBadge()
        
        // Обновляем интерфейс ячеек, чтобы отобразить элементы управления количеством для добавленных товаров
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CatalogViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        let product = filteredProducts[indexPath.row]
        cell.configure(with: product)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = filteredProducts[indexPath.row]
        showProductDetail(for: product)
    }
}

// MARK: - Модель данных
struct Product {
    let image: String
    let title: String
    let description: String
    let price: String
    let category: String
    let additionalInfo: String
}

// MARK: - Ячейка товара
protocol ProductCellDelegate: AnyObject {
    func didTapPriceButton(in cell: ProductCell, for product: Product)
    func updateQuantity(in cell: ProductCell, product: Product, size: String, quantity: Int)
    func removeItem(in cell: ProductCell, product: Product, size: String)
}

class ProductCell: UITableViewCell {
    
    weak var delegate: ProductCellDelegate?
    var product: Product?
    private var quantityControlView: QuantityControlView?
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(red: 242/255, green: 230/255, blue: 224/255, alpha: 1.0)
        container.layer.cornerRadius = 8
        return container
    }()
    
    private lazy var priceButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(priceButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellUI() {
        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceContainer)
        
        priceContainer.addSubview(priceButton)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            productImageView.widthAnchor.constraint(equalToConstant: 120),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 1.25),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceContainer.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            priceContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            priceContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            priceContainer.heightAnchor.constraint(equalToConstant: 40),
            
            priceButton.topAnchor.constraint(equalTo: priceContainer.topAnchor),
            priceButton.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor, constant: 8),
            priceButton.trailingAnchor.constraint(equalTo: priceContainer.trailingAnchor, constant: -8),
            priceButton.bottomAnchor.constraint(equalTo: priceContainer.bottomAnchor),
        ])
    }
    
    func configure(with product: Product) {
        self.product = product
        productImageView.image = UIImage(named: product.image)
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        
        // Проверяем, есть ли этот товар в корзине
        let cartItems = Cart.shared.items
        let matchingItem = cartItems.first { 
            item in item.product.title == product.title
        }
        
        if let item = matchingItem {
            // Товар уже в корзине - показываем элементы управления количеством
            showQuantityControl(for: item)
        } else {
            // Товара нет в корзине - показываем кнопку цены
            showPriceButton(price: product.price)
        }
    }
    
    // Показать кнопку цены (стандартное состояние)
    private func showPriceButton(price: String) {
        // Удаляем контрол количества, если он был
        quantityControlView?.removeFromSuperview()
        quantityControlView = nil
        
        // Показываем контейнер с кнопкой цены
        priceContainer.isHidden = false
        priceButton.isHidden = false
        priceButton.setTitle(price, for: .normal)
    }
    
    // Показать контрол управления количеством
    private func showQuantityControl(for cartItem: CartItem) {
        // Прячем кнопку цены
        priceContainer.isHidden = true
        priceButton.isHidden = true
        
        // Удаляем старый контрол количества, если он был
        quantityControlView?.removeFromSuperview()
        
        // Создаем новый контрол
        let quantityControl = QuantityControlView(
            product: cartItem.product, 
            size: cartItem.size, 
            color: cartItem.color
        )
        quantityControl.quantity = cartItem.quantity
        quantityControl.delegate = delegate as? QuantityControlDelegate
        quantityControl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(quantityControl)
        self.quantityControlView = quantityControl
        
        NSLayoutConstraint.activate([
            quantityControl.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            quantityControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            quantityControl.heightAnchor.constraint(equalToConstant: 40),
            quantityControl.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    @objc private func priceButtonTapped() {
        guard let currentProduct = product else {
            print("Ошибка: товар не установлен в ячейке ProductCell")
            return
        }
        delegate?.didTapPriceButton(in: self, for: currentProduct)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        product = nil
        
        // Очищаем и сбрасываем состояние кнопки цены
        priceButton.setTitle(nil, for: .normal)
        priceButton.isEnabled = true
        priceButton.setTitleColor(.black, for: .normal)
        priceContainer.isHidden = false
        priceButton.isHidden = false
        
        // Удаляем контрол количества, если он есть
        quantityControlView?.removeFromSuperview()
        quantityControlView = nil
    }
}

// MARK: - ProductCellDelegate
extension CatalogViewController: ProductCellDelegate {
    func didTapPriceButton(in cell: ProductCell, for product: Product) {
        print("DEBUG: Нажата кнопка цены для товара: \(product.title)")
        showProductDetail(for: product)
    }
    
    func updateQuantity(in cell: ProductCell, product: Product, size: String, quantity: Int) {
        // Найти соответствующий товар в корзине и обновить его количество
        let cartItems = Cart.shared.items
        if let index = cartItems.firstIndex(where: { 
            $0.product.title == product.title && $0.size == size 
        }) {
            Cart.shared.updateQuantity(at: index, to: quantity)
            NotificationCenter.default.post(name: Notification.Name.cartUpdated, object: nil)
            tableView.reloadData() // Обновляем всю таблицу, чтобы показать актуальные данные
        }
    }
    
    func removeItem(in cell: ProductCell, product: Product, size: String) {
        // Найти соответствующий товар в корзине и удалить его
        let cartItems = Cart.shared.items
        if let index = cartItems.firstIndex(where: { 
            $0.product.title == product.title && $0.size == size 
        }) {
            Cart.shared.removeItem(at: index)
            NotificationCenter.default.post(name: Notification.Name.cartUpdated, object: nil)
            tableView.reloadData() // Обновляем всю таблицу, чтобы показать актуальные данные
        }
    }
}

// MARK: - Notifications
extension NSNotification.Name {
    static let productAddedToCart = NSNotification.Name("productAddedToCart")
}

// MARK: - Quantity Control View
class QuantityControlView: UIView {
    // MARK: - Properties
    weak var delegate: QuantityControlDelegate?
    var quantity: Int = 1 {
        didSet {
            quantityLabel.text = String(quantity)
        }
    }
    
    private var product: Product?
    private var size: String?
    private var color: String?
    
    // MARK: - UI Elements
    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 242/255, green: 230/255, blue: 224/255, alpha: 1.0)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 204/255, green: 177/255, blue: 161/255, alpha: 1.0).cgColor
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 242/255, green: 230/255, blue: 224/255, alpha: 1.0)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 204/255, green: 177/255, blue: 161/255, alpha: 1.0).cgColor
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(product: Product, size: String, color: String? = nil) {
        self.product = product
        self.size = size
        self.color = color
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        layer.cornerRadius = 15
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 204/255, green: 177/255, blue: 161/255, alpha: 0.3).cgColor
        
        addSubview(minusButton)
        addSubview(quantityLabel)
        addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            minusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalToConstant: 30),
            
            quantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 8),
            quantityLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            quantityLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
            
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Actions
    @objc private func minusButtonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.minusButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.minusButton.transform = CGAffineTransform.identity
            }
        }
        
        if quantity > 1 {
            quantity -= 1
            delegate?.quantityControlDidChangeValue(self, newQuantity: quantity)
        } else {
            delegate?.quantityControlDidRemoveItem(self)
        }
    }
    
    @objc private func plusButtonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.plusButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.plusButton.transform = CGAffineTransform.identity
            }
        }
        
        quantity += 1
        delegate?.quantityControlDidChangeValue(self, newQuantity: quantity)
    }
}

// MARK: - Quantity Control Delegate
protocol QuantityControlDelegate: AnyObject {
    func quantityControlDidChangeValue(_ control: QuantityControlView, newQuantity: Int)
    func quantityControlDidRemoveItem(_ control: QuantityControlView)
}

// MARK: - QuantityControlDelegate
extension CatalogViewController: QuantityControlDelegate {
    func quantityControlDidChangeValue(_ control: QuantityControlView, newQuantity: Int) {
        guard let cell = control.superview?.superview as? ProductCell,
              let product = cell.product,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        // Получаем товар из модели
        let productItem = filteredProducts[indexPath.row]
        
        // Ищем соответствующий CartItem для обновления
        let cartItems = Cart.shared.items
        if let existingItemIndex = cartItems.firstIndex(where: { 
            $0.product.title == productItem.title 
        }) {
            let existingItem = cartItems[existingItemIndex]
            
            // Обновляем количество
            Cart.shared.updateQuantity(at: existingItemIndex, to: newQuantity)
            NotificationCenter.default.post(name: Notification.Name.cartUpdated, object: nil)
        }
    }
    
    func quantityControlDidRemoveItem(_ control: QuantityControlView) {
        guard let cell = control.superview?.superview as? ProductCell,
              let product = cell.product,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        // Получаем товар из модели
        let productItem = filteredProducts[indexPath.row]
        
        // Ищем соответствующий CartItem для удаления
        let cartItems = Cart.shared.items
        if let existingItemIndex = cartItems.firstIndex(where: { 
            $0.product.title == productItem.title 
        }) {
            // Удаляем товар
            Cart.shared.removeItem(at: existingItemIndex)
            NotificationCenter.default.post(name: Notification.Name.cartUpdated, object: nil)
            
            // Обновляем ячейку, чтобы вернуть ее в состояние с кнопкой цены
            cell.configure(with: productItem)
        }
    }
} 
