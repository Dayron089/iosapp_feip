import UIKit

class CheckoutViewController: UIViewController {

    // MARK: - UI Elements
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

    private lazy var fioLabel: UILabel = createLabel(text: "ФИО")
    private lazy var fioTextField: UITextField = createTextField(placeholder: "Иванов Иван Иванович")

    private lazy var addressLabel: UILabel = createLabel(text: "Адрес доставки")
    private lazy var addressTextField: UITextField = createTextField(placeholder: "Город, улица, дом, квартира")

    private lazy var emailLabel: UILabel = createLabel(text: "Email")
    private lazy var emailTextField: UITextField = createTextField(placeholder: "example@mail.com", keyboardType: .emailAddress)

    private lazy var paymentMethodLabel: UILabel = createLabel(text: "Способ оплаты")
    private lazy var paymentMethodSegmentedControl: UISegmentedControl = {
        let items = ["Банковская карта", "Наличные"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private lazy var confirmOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оформить заказ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 92/255, green: 64/255, blue: 51/255, alpha: 1.0) // Dark brown
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(confirmOrderTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Оформление заказа"
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        setupKeyboardDismissTapGesture()
    }

    // MARK: - Keyboard Handling
    private func setupKeyboardDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Позволяет нажатиям проходить к кнопкам и т.д.
        view.addGestureRecognizer(tapGesture) // Добавляем к основному view, чтобы ловить тапы везде
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true) // Этот метод найдет активное поле ввода и скроет клавиатуру
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(fioLabel)
        contentView.addSubview(fioTextField)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressTextField)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(paymentMethodLabel)
        contentView.addSubview(paymentMethodSegmentedControl)
        contentView.addSubview(confirmOrderButton)
    }

    // MARK: - Helper Creation Functions
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = keyboardType
        return textField
    }

    // MARK: - Constraints
    private func setupConstraints() {
        let padding: CGFloat = 20
        let spacing: CGFloat = 12

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            // ФИО
            fioLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            fioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            fioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            fioTextField.topAnchor.constraint(equalTo: fioLabel.bottomAnchor, constant: spacing),
            fioTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            fioTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            fioTextField.heightAnchor.constraint(equalToConstant: 44),

            // Адрес
            addressLabel.topAnchor.constraint(equalTo: fioTextField.bottomAnchor, constant: padding),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            addressTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: spacing),
            addressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            addressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            addressTextField.heightAnchor.constraint(equalToConstant: 44),

            // Email
            emailLabel.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: padding),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: spacing),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            // Способ оплаты
            paymentMethodLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            paymentMethodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            paymentMethodLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            paymentMethodSegmentedControl.topAnchor.constraint(equalTo: paymentMethodLabel.bottomAnchor, constant: spacing),
            paymentMethodSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            paymentMethodSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            paymentMethodSegmentedControl.heightAnchor.constraint(equalToConstant: 44),

            // Кнопка Оформить заказ
            confirmOrderButton.topAnchor.constraint(greaterThanOrEqualTo: paymentMethodSegmentedControl.bottomAnchor, constant: padding * 2),
            confirmOrderButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            confirmOrderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            confirmOrderButton.heightAnchor.constraint(equalToConstant: 50),
            confirmOrderButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding) // Привязка к низу contentView
        ])
    }

    // MARK: - Actions
    @objc private func confirmOrderTapped() {
        // Здесь будет логика подтверждения заказа (например, отправка данных на сервер)
        print("ФИО: \(fioTextField.text ?? "")")
        print("Адрес: \(addressTextField.text ?? "")")
        print("Email: \(emailTextField.text ?? "")")
        let paymentMethod = paymentMethodSegmentedControl.titleForSegment(at: paymentMethodSegmentedControl.selectedSegmentIndex) ?? "Не выбран"
        print("Способ оплаты: \(paymentMethod)")

        // Показываем кастомное модальное окно
        let confirmationVC = OrderConfirmationViewController()
        confirmationVC.delegate = self
        confirmationVC.modalPresentationStyle = .overCurrentContext // Для полупрозрачного фона
        confirmationVC.modalTransitionStyle = .crossDissolve // Плавное появление
        present(confirmationVC, animated: true, completion: nil)
    }
}

// MARK: - OrderConfirmationDelegate
extension CheckoutViewController: OrderConfirmationDelegate {
    func didTapReturnToMainButton() {
        // 1. Сначала скрываем модальное окно подтверждения заказа
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            // 2. Очищаем корзину
            Cart.shared.clearCart()

            // 3. Отправляем уведомление, чтобы другие части приложения (например, CatalogViewController)
            // могли обновить свой UI (значок корзины и состояние ячеек товаров).
            NotificationCenter.default.post(name: Notification.Name.cartUpdated, object: nil)

            // 4. Определяем, как закрыть экраны и вернуться в каталог:
            // Проверяем, был ли навигационный контроллер, содержащий CheckoutViewController,
            // представлен модально.
            if self.navigationController?.presentingViewController != nil {
                // Если да (т.е. CartViewController + CheckoutViewController были в модальном UINavigationController),
                // то закрываем весь этот модальный навигационный контроллер.
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                // Иначе, CartViewController был добавлен в основной стек навигации.
                // В этом случае, возвращаемся к корневому контроллеру (каталогу).
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
} 