import UIKit
import SnapKit

public protocol BitcoinPriceViewDelegate: AnyObject {
    func didSelectUpdateButton()
}

public final class BitcoinPriceView: UIView {
    
    public weak var delegate: BitcoinPriceViewDelegate?
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.accessibilityIdentifier = "contentStackView"
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "bitcoin.png")
        view.accessibilityIdentifier = "imageBitcoinPrice"
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.text = "R$ 0.00"
        view.textColor = .orange
        view.font = AppFont.condensedBlack.size(55.0)
        view.textAlignment = .center
        view.accessibilityIdentifier = "priceLabel"
        return view
    }()
    
    private lazy var updateButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Atualizar", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 21)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.cornerRadius = 8
        view.accessibilityIdentifier = "updateButton"
        return view
    }()
    
//    private var viewData: BitcoinPriceViewData
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
//    public init(_ viewData: BitcoinPriceViewData) {
//        self.viewData = viewData
//        super.init(frame: .zero)
//        setupView()
//        build()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BitcoinPriceView: CodeViewProtocol {
    
    func buildViewHierarrchy() {
        let interfaceElements = [imageView, priceLabel]
        interfaceElements.forEach { item in
            contentStackView.addArrangedSubview(item)
        }
        addSubview(contentStackView)
        addSubview(updateButton)
    }
    
    func makeConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        priceLabel.snp.makeConstraints {  make in
            make.leading.trailing.equalTo(contentStackView)
            make.top.equalTo(imageView.snp.bottom)
        }
        
        updateButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.width.equalTo(contentStackView)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
}

extension BitcoinPriceView {
    
    public func build(_ data: BitcoinPriceViewData) {
        DispatchQueue.main.sync {
            priceLabel.text = "R$ \(data.price)"
            updateButton.addTarget(self, action: #selector(didSelectUpdateButton), for: .touchUpInside)
        }
        
    }
    
    @objc
    private func didSelectUpdateButton() {
        delegate?.didSelectUpdateButton()
    }
    
}
