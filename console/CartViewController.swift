import UIKit

class CartViewController: UIViewController {

    // MARK: - UI Элементы
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        return tableView
    }()

    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        return label
    }()

    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .right
        return label
    }()

    private lazy var checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти к оформлению", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = UIColor(red: 92/255, green: 64/255, blue: 51/255, alpha: 1.0) // darkBrownColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Корзина пуста"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Корзина"
        view.backgroundColor = .systemGroupedBackground
        setupNavigationBar()
        setupUI()
        updateCartView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(clearCartButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .label
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(totalLabel)
        view.addSubview(totalPriceLabel)
        view.addSubview(checkoutButton)
        view.addSubview(emptyCartLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -16),
            
            emptyCartLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),

            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalLabel.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -16),
            
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            totalPriceLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            totalPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: totalLabel.trailingAnchor, constant: 8),

            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func cartUpdated() {
        updateCartView()
    }

    private func updateCartView() {
        let cart = Cart.shared
        if cart.items.isEmpty {
            tableView.isHidden = true
            totalLabel.isHidden = true
            totalPriceLabel.isHidden = true
            checkoutButton.isHidden = true
            emptyCartLabel.isHidden = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            tableView.isHidden = false
            totalLabel.isHidden = false
            totalPriceLabel.isHidden = false
            checkoutButton.isHidden = false
            emptyCartLabel.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = true
            
            totalLabel.text = "Итого"
            totalPriceLabel.text = cart.formattedTotalPrice
            tableView.reloadData()
        }
    }

    @objc private func clearCartButtonTapped() {
        Cart.shared.clearCart()
        tableView.reloadData()
        // Отправить уведомление для обновления бейджа в каталоге
        NotificationCenter.default.post(name: Notification.Name.cartUpdated, object: nil)
    }

    @objc private func checkoutButtonTapped() {
        // Проверяем, что корзина не пуста
        guard !Cart.shared.items.isEmpty else {
            // Можно показать алерт, что корзина пуста, если это необходимо
            print("Корзина пуста. Невозможно перейти к оформлению.")
            return
        }
        
        let checkoutVC = CheckoutViewController()
        navigationController?.pushViewController(checkoutVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.reuseIdentifier, for: indexPath) as? CartItemCell else {
            return UITableViewCell()
        }
        let item = Cart.shared.items[indexPath.row]
        cell.configure(with: item, delegate: self)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Высота ячейки товара в корзине
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Cart.shared.removeItem(at: indexPath.row)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
//            tableView.deleteRows(at: [indexPath], with: .fade) // Анимация удаления, если нужна
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
}

// MARK: - CartItemCellDelegate
extension CartViewController: CartItemCellDelegate {
    func didUpdateQuantity(for cell: CartItemCell, newQuantity: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        Cart.shared.updateQuantity(at: indexPath.row, to: newQuantity)
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
    
    func didTapRemoveButton(for cell: CartItemCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        Cart.shared.removeItem(at: indexPath.row)
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
}

// MARK: - CartItemCell
protocol CartItemCellDelegate: AnyObject {
    func didUpdateQuantity(for cell: CartItemCell, newQuantity: Int)
    func didTapRemoveButton(for cell: CartItemCell)
}

class CartItemCell: UITableViewCell {
    static let reuseIdentifier = "CartItemCell"
    weak var delegate: CartItemCellDelegate?
    private var item: CartItem?

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        return button
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        return button
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        selectionStyle = .none
        setupCellUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCellUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(removeButton)

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -8),

            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24),

            plusButton.trailingAnchor.constraint(equalTo: removeButton.trailingAnchor),
            plusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30),

            quantityLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            quantityLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 25),

            minusButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -8),
            minusButton.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    func configure(with item: CartItem, delegate: CartItemCellDelegate) {
        self.item = item
        self.delegate = delegate
        productImageView.image = UIImage(named: item.product.image)
        titleLabel.text = item.product.title
        var detailText = "Размер: \(item.size)"
        if let color = item.color {
            detailText += ", Цвет: \(color)"
        }
        detailsLabel.text = detailText
        priceLabel.text = item.formattedTotalPrice
        quantityLabel.text = "\(item.quantity)"
    }

    @objc private func minusButtonTapped() {
        guard let currentItem = item else { return }
        let newQuantity = currentItem.quantity - 1
        delegate?.didUpdateQuantity(for: self, newQuantity: newQuantity)
    }

    @objc private func plusButtonTapped() {
        guard let currentItem = item else { return }
        let newQuantity = currentItem.quantity + 1
        delegate?.didUpdateQuantity(for: self, newQuantity: newQuantity)
    }
    
    @objc private func removeButtonTapped() {
        delegate?.didTapRemoveButton(for: self)
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
} 