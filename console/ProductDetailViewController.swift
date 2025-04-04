import UIKit

class ProductDetailViewController: UIViewController {

    // MARK: - база
    private let availableSizes = ["XXS", "XS", "S", "M", "L", "XL"]
    private var selectedSize: String? = "XXS"
    private var sizeButtons: [UIButton] = []
    private let isNewProduct = true

    let veryLightBrownColor = UIColor(red: 204/255, green: 177/255, blue: 161/255, alpha: 1.0)
    let darkBrownColor = UIColor(red: 92/255, green: 64/255, blue: 51/255, alpha: 1.0)
    let lightBeigeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    let lightBorderColor = UIColor.systemGray5
    let darkTextColor = UIColor.darkGray

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
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var newTagLabel: UILabel = {
        let label = UILabel()
        label.text = "NEW"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = veryLightBrownColor
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = !isNewProduct
        return label
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
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        button.setImage(UIImage(systemName: "info", withConfiguration: symbolConfig), for: .normal)
        button.tintColor = UIColor(red: 168/255, green: 138/255, blue: 121/255, alpha: 1.0)
        button.backgroundColor = UIColor(red: 225/255, green: 215/255, blue: 210/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
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

    private lazy var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var sizeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitle("Загрузка...", for: .normal)
        button.backgroundColor = .systemGray4
        button.setTitleColor(.systemGray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        selectSize(selectedSize)
        updateAddToCartButtonAppearance()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(topSeparatorView)
        view.addSubview(sizeStackView)
        view.addSubview(bottomSeparatorView)
        view.addSubview(addToCartButton)

        scrollView.addSubview(contentView)

        contentView.addSubview(productImageView)
        contentView.addSubview(newTagLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(descriptionLabel)

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
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 20 // Круглые кнопки
        button.layer.borderWidth = 1

        updateSizeButtonAppearance(button, isSelected: false)

        button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualTo: button.heightAnchor).isActive = true

        return button
    }

    // MARK: - Ограничения
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let contentLayoutGuide = scrollView.contentLayoutGuide
        let frameLayoutGuide = scrollView.frameLayoutGuide

        let padding: CGFloat = 16
        let smallPadding: CGFloat = 8
        let tighterPadding: CGFloat = 10

        NSLayoutConstraint.activate([
            // --- ScrollView ---
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: topSeparatorView.topAnchor, constant: -padding),

            // --- ContentView ---
            contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding),
            contentView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor),

            // --- Картинка ---
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 0.75),

             // --- Заголовок ---
            newTagLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: smallPadding),
            newTagLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: smallPadding),
            newTagLabel.heightAnchor.constraint(equalToConstant: 22),
            newTagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoButton.leadingAnchor, constant: -smallPadding),

            // --- Инфа кнопки ---
            infoButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            infoButton.widthAnchor.constraint(equalToConstant: 28), // Увеличенный размер
            infoButton.heightAnchor.constraint(equalToConstant: 28), // Увеличенный размер

            // --- Описание ---
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: smallPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            // --- View ---
            topSeparatorView.bottomAnchor.constraint(equalTo: sizeStackView.topAnchor, constant: -tighterPadding),
            topSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            // --- Размер ---
            sizeStackView.bottomAnchor.constraint(equalTo: bottomSeparatorView.topAnchor, constant: -tighterPadding),
            sizeStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            sizeStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            sizeStackView.heightAnchor.constraint(equalToConstant: 40),

            // --- В корзину ---
            bottomSeparatorView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -tighterPadding),
            bottomSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            // --- Добавить в ---
            addToCartButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -padding),
            addToCartButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            addToCartButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        infoButton.setContentHuggingPriority(.required, for: .horizontal)
        infoButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }


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
        guard let selectedTitle = sender.titleLabel?.text else {
            print("Ошибка: Не удалось получить title кнопки размера")
            return
         }
        selectSize(selectedTitle)
    }

    private func selectSize(_ size: String?) {
        selectedSize = size
        print("Выбран размер: \(selectedSize ?? "Нет")")

        for button in sizeButtons {
            guard let buttonTitle = button.titleLabel?.text else { continue }
            let isSelected = (buttonTitle == selectedSize)
            updateSizeButtonAppearance(button, isSelected: isSelected)
        }

        addToCartButton.isEnabled = (selectedSize != nil)
        updateAddToCartButtonAppearance()
    }

    private func updateAddToCartButtonAppearance() {
        let basePrice = "14 999 ₽"
        let activeTitle = "В корзину ・ \(basePrice)"
        let inactiveTitle = "Выберите размер"

        let activeBackgroundColor = veryLightBrownColor
        let inactiveBackgroundColor = UIColor.systemGray4
        let activeTextColor = UIColor.white
        let inactiveTextColor = UIColor.systemGray

        if addToCartButton.isEnabled {
            addToCartButton.setTitle(activeTitle, for: .normal)
            addToCartButton.backgroundColor = activeBackgroundColor
            addToCartButton.setTitleColor(darkTextColor, for: .normal)
        } else {
            addToCartButton.setTitle(inactiveTitle, for: .normal)
            addToCartButton.setTitle(inactiveTitle, for: .disabled)
            addToCartButton.backgroundColor = inactiveBackgroundColor
            addToCartButton.setTitleColor(inactiveTextColor, for: .disabled)
        }
    }

    private func updateSizeButtonAppearance(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = darkBrownColor
            button.setTitleColor(.white, for: .normal)
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth = 0
        } else {
            button.backgroundColor = lightBeigeColor
            button.setTitleColor(darkTextColor, for: .normal)
            button.layer.borderColor = lightBorderColor.cgColor
            button.layer.borderWidth = 1
        }
    }
}
