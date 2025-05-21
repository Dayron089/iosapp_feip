import UIKit

protocol OrderConfirmationDelegate: AnyObject {
    func didTapReturnToMainButton()
}

class OrderConfirmationViewController: UIViewController {

    weak var delegate: OrderConfirmationDelegate?

    // MARK: - UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        // Используем SF Symbol. Вы можете заменить на свое изображение.
        if #available(iOS 15.0, *) {
            imageView.image = UIImage(systemName: "bag.badge.plus") // Альтернатива: checkmark.circle.fill
        } else {
            imageView.image = UIImage(systemName: "checkmark.circle.fill")
        }
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Заказ успешно оформлен"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Подтверждение и чек отправили на вашу почту"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться на главную", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = UIColor(red: 172/255, green: 145/255, blue: 132/255, alpha: 1.0) // Цвет как на скриншоте
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4) // Полупрозрачный фон
        view.addSubview(containerView)
        
        containerView.addSubview(grabberView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(returnButton)
    }

    private func setupLayout() {
        let padding: CGFloat = 24
        let spacing: CGFloat = 16

        NSLayoutConstraint.activate([
            // Container View - центрируем и задаем примерную высоту, но не фиксированную
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // Примерная высота, чтобы контент поместился. Можно сделать более динамичной.
            // containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            
            grabberView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            grabberView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 40),
            grabberView.heightAnchor.constraint(equalToConstant: 5),

            iconImageView.topAnchor.constraint(equalTo: grabberView.bottomAnchor, constant: padding),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing / 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),

            returnButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding),
            returnButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            returnButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            returnButton.heightAnchor.constraint(equalToConstant: 50),
            returnButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -padding) // Привязка к низу контейнера
        ])
    }

    // MARK: - Actions
    @objc private func returnButtonTapped() {
        delegate?.didTapReturnToMainButton()
    }
} 