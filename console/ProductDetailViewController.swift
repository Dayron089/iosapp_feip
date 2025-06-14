import UIKit

class ProductDetailViewController: UIViewController {
    var product: Product?
    
    // MARK: - Private Properties
    private var availableSizes: [String] = []
    private var selectedSize: String?
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var newLabel: UILabel = {
        let label = UILabel()
        label.text = "NEW"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 130/255, green: 100/255, blue: 90/255, alpha: 1.0)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        button.setImage(UIImage(systemName: "info", withConfiguration: config), for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = UIColor(red: 250/255, green: 235/255, blue: 215/255, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sizeButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 160/255, green: 120/255, blue: 100/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomModuleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground // Or a slightly off-white color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20 // Rounded top corners
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var bottomButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16 // Spacing between size buttons and add to cart button
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var topModuleShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // Very light gray background
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05 // Subtle shadow
        view.layer.shadowOffset = CGSize(width: 0, height: -2) // Shadow above the line
        view.layer.shadowRadius = 2 // Soft shadow
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0) // Light gray color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor // Shadow color
        view.layer.shadowOpacity = 0.05 // Subtle shadow
        view.layer.shadowOffset = CGSize(width: 0, height: -2) // Shadow above the line
        view.layer.shadowRadius = 2 // Soft shadow
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        updateUI()
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        title = "Экран товара / Измененная начинка"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        view.addSubview(topModuleShadowView)
        view.addSubview(bottomModuleView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(productImageView)
        productImageView.addSubview(newLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(descriptionLabel)
        view.addSubview(bottomModuleView)
        bottomModuleView.addSubview(bottomButtonsStackView)
        
        bottomButtonsStackView.addArrangedSubview(sizeButtonsStackView)
        bottomButtonsStackView.addArrangedSubview(separatorView)
        bottomButtonsStackView.addArrangedSubview(addToCartButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomModuleView.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 350),
            
            newLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 16),
            newLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 16),
            newLabel.widthAnchor.constraint(equalToConstant: 50),
            newLabel.heightAnchor.constraint(equalToConstant: 25),

            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoButton.leadingAnchor, constant: -8),
            
            infoButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoButton.widthAnchor.constraint(equalToConstant: 28),
            infoButton.heightAnchor.constraint(equalToConstant: 28),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            sizeButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sizeButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sizeButtonsStackView.heightAnchor.constraint(equalToConstant: 40),
            
            bottomModuleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomModuleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomModuleView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
            bottomModuleView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            
            topModuleShadowView.bottomAnchor.constraint(equalTo: bottomModuleView.topAnchor),
            topModuleShadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topModuleShadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topModuleShadowView.heightAnchor.constraint(equalToConstant: 1),

            bottomButtonsStackView.topAnchor.constraint(equalTo: bottomModuleView.topAnchor, constant: 16),
            bottomButtonsStackView.leadingAnchor.constraint(equalTo: bottomModuleView.leadingAnchor, constant: 16),
            bottomButtonsStackView.trailingAnchor.constraint(equalTo: bottomModuleView.trailingAnchor, constant: -16),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: bottomModuleView.bottomAnchor, constant: -16),

            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Data Population
    private func updateUI() {
        guard let product = product else { return }
        
        productImageView.image = UIImage(named: product.image)
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        
        // Update Add to Cart Button title with price
        addToCartButton.setTitle("В корзину • \(product.price)", for: .normal)

        availableSizes = ["XXS", "XS", "S", "M", "L", "XL"]
        if let firstSize = availableSizes.first {
            selectedSize = firstSize
        }
        createSizeButtons()
        updateSelectedSizeButtonAppearance()
    }
    
    private func createSizeButtons() {
        sizeButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Clear existing buttons
        
        for size in availableSizes {
            let button = UIButton(type: .system)
            button.setTitle(size, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            button.layer.cornerRadius = 20 // Half of 40 height for pill shape
            button.layer.masksToBounds = true // Ensure clipping
            button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            sizeButtonsStackView.addArrangedSubview(button)
        }
    }
    
    private func updateSelectedSizeButtonAppearance() {
        for case let button as UIButton in sizeButtonsStackView.arrangedSubviews {
            let isSelected = button.title(for: .normal) == selectedSize
            button.backgroundColor = isSelected ? UIColor(red: 92/255, green: 64/255, blue: 51/255, alpha: 1.0) : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            button.setTitleColor(isSelected ? .white : .darkGray, for: .normal)
        }
    }

    // MARK: - Actions
    @objc private func addToCartButtonTapped() {
        guard let product = product, let size = selectedSize else { return }
        
        let cartItem = CartItem(product: product, quantity: 1, size: size)
        Cart.shared.addItem(cartItem)
        
        // Post notification to update cart badge and catalog view
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
        NotificationCenter.default.post(name: NSNotification.Name.productAddedToCart, object: nil)
        
        // Dismiss the detail view
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sizeButtonTapped(_ sender: UIButton) {
        if let size = sender.title(for: .normal) {
            selectedSize = size
            updateSelectedSizeButtonAppearance()
        }
    }
    
    @objc private func infoButtonTapped() {
        guard let product = product else { return }
        let alert = UIAlertController(title: "Дополнительная информация", message: product.additionalInfo, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
} 