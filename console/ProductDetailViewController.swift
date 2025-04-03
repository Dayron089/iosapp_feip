import UIKit

class ProductDetailViewController: UIViewController {

    // MARK: - база
    private let availableSizes = ["XS", "S", "M", "L", "XL"] // \
    private var selectedSize: String? = nil
    private var sizeButtons: [UIButton] = []

    // MARK: - UI элементы

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loafers_image")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Кожаные лоферы"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Лоферы из натуральной кожи. Фигурная союзка с фактурным швом по контуру.
        Зауженный мыс. Кожаная стелька и подкладка.
        Прорезиненная подошва. В комплект входит пыльник.
        """
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // StackView для размеров
    private lazy var sizeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        // --- Настройка НАЧАЛЬНОГО состояния ---
        let inactiveTitle = "Выберите размер"
        button.isEnabled = false

        button.setTitle(inactiveTitle, for: .normal)
        button.setTitle(inactiveTitle, for: .disabled)

        let activeBackgroundColor = UIColor(red: 168/255, green: 138/255, blue: 121/255, alpha: 1.0)
        let inactiveBackgroundColor = UIColor.systemGray4
        button.backgroundColor = inactiveBackgroundColor //

        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)

        // Добавляем обработчик нажатия
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)

        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()

    }

    // MARK: - Setup UI

    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(addToCartButton)
        scrollView.addSubview(contentView)

        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(sizeStackView)
        setupSizeButtons()
    }

    // --- Функция для создания кнопок размеров ---
    private func setupSizeButtons() {
        sizeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        sizeButtons.removeAll()

        for size in availableSizes {
            let button = createSizeButton(title: size)
            sizeStackView.addArrangedSubview(button)
            sizeButtons.append(button) 
        }
    }

    // --- Функция для создания ОДНОЙ кнопки размера ---
    private func createSizeButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .systemGray5
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)

        let button = UIButton(configuration: config, primaryAction: nil)
        button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

        return button
    }

    // MARK: - Ограничения

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let contentLayoutGuide = scrollView.contentLayoutGuide
        let frameLayoutGuide = scrollView.frameLayoutGuide

        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            // --- ScrollView ---
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -padding),

            // --- ContentView ---
            contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor),

            // --- Картинка ---
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 0.75),

            // --- Заголовок ---
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoButton.leadingAnchor, constant: -8),

            // --- Инфа кнопки ---
            infoButton.centerYAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor),
            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            infoButton.widthAnchor.constraint(equalToConstant: 30),
            infoButton.heightAnchor.constraint(equalToConstant: 30),

            // --- Описание ---
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            // --- Размер StackView ---
            sizeStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding * 1.5),
            sizeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
             sizeStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -padding),
            sizeStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),

            // --- В корзину ---
            addToCartButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -padding),
            addToCartButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            addToCartButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Кнопки

    @objc private func infoButtonTapped() {
        let alertController = UIAlertController(
            title: "Дополнительная информация",
            message: "Это очень качественные кожаные лоферы, сделанные с любовью. Покупайте скорее!",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Понятно", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc private func addToCartButtonTapped() {
        guard let size = selectedSize else {
            print("Ошибка: Размер не выбран!")
            return
        }
        print("Добавлено в корзину: \(titleLabel.text ?? "Товар") - Размер: \(size)")
    }

    @objc private func sizeButtonTapped(_ sender: UIButton) {
        guard let selectedTitle = sender.configuration?.title else { return }
        selectSize(selectedTitle)
    }


    // --- Функция для выбора размера и обновления UI ---
    private func selectSize(_ size: String?) {
        selectedSize = size
        print("Выбран размер: \(selectedSize ?? "Нет")")

        // Обновляем внешний вид всех кнопок
        for button in sizeButtons {
            guard let buttonTitle = button.configuration?.title else { continue }
            let isSelected = (buttonTitle == selectedSize)

            // Создаем новую конфигурацию для обновления
            var newConfig = button.configuration

            if isSelected {
                newConfig?.baseBackgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 1.0) // Темно-серый
                newConfig?.baseForegroundColor = .white
            } else {
                newConfig?.baseBackgroundColor = .systemGray5
                newConfig?.baseForegroundColor = .label
            }
            button.configuration = newConfig
        }

        updateAddToCartButtonState()
        updateAddToCartButtonTitle()
    }
  


    // --- Cостояния кнопки "В корзину" ---
    private func updateAddToCartButtonState() {
        let isEnabled = (selectedSize != nil)
        addToCartButton.isEnabled = isEnabled
        addToCartButton.backgroundColor = isEnabled ? UIColor(red: 168/255, green: 138/255, blue: 121/255, alpha: 1.0) : .systemGray4
    }


    private func updateAddToCartButtonTitle() {
        let basePrice = "14 999 ₽"
        let title = "В корзину ・ \(basePrice)"
        addToCartButton.setTitle(title, for: .normal)
         if !addToCartButton.isEnabled {
              addToCartButton.setTitle("Выберите размер", for: .disabled)
         } else {
             addToCartButton.setTitle(title, for: .normal)
         }
    }
}
// Commit для Pull Request

