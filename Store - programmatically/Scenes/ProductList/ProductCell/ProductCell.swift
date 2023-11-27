//
//  ProductCell.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func addProduct(for cell: ProductCell?)
    func removeProduct(for cell: ProductCell?)
}

final class ProductCell: UITableViewCell {
    
    // MARK: - Properties
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let subtractProductButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let selectedQuantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let addProductButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private lazy var productInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productTitleLabel, descriptionLabel, stockLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var selectProductStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [subtractProductButton, selectedQuantityLabel, addProductButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView, productInfoStackView, selectProductStackView])
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    weak var delegate: ProductCellDelegate?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupUI()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productTitleLabel.text = nil
        descriptionLabel.text = nil
        stockLabel.text = nil
        priceLabel.text = nil
    }
    
    // MARK: - Actions
    private func addActions() {
        addProductButton.addAction(UIAction(title: "", handler: { [weak self] _ in
            self?.delegate?.addProduct(for: self)
        }), for: .touchUpInside)
        
        subtractProductButton.addAction(UIAction(title: "", handler: { [weak self] _ in
            self?.delegate?.removeProduct(for: self)
        }), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    private func setupUI(){
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            productImageView.widthAnchor.constraint(equalToConstant: 100),
            
            productInfoStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            productInfoStackView.widthAnchor.constraint(equalToConstant: 120),
            
        ])
    }
    
    func reload(with product: Product) {
        setImage(from: product.thumbnail)
        productTitleLabel.text = product.title
        descriptionLabel.text = product.description
        stockLabel.text = "\(product.stock)"
        priceLabel.text = "\(product.price)$"
        selectedQuantityLabel.text = "\(product.selectedAmount ?? 0)"
    }
    
    func updateQuantityLabel(with product: Product) {
        selectedQuantityLabel.text = "\(product.selectedAmount ?? 0)"
    }
    
    private func setImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.productImageView.image = image
            }
        }
    }
}



