//
//  ProductsListViewController.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import UIKit

class ProductsListViewController: UIViewController {
    
    private let productsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .white
        return indicator
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total: 0$"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    var products = [Product]()
    
    private let productsViewModel = ProductsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProductsViewModelDelegate()
        activityIndicator.startAnimating()
        productsViewModel.viewDidLoad()
    }
    
    //MARK: setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(red: 26/255.0, green: 34/255.0, blue: 50/255.0, alpha: 1)
        setupTableView()
        setupIndicator()
        setupTotalPriceLabel()
    }
    
    private func setupTableView() {
        view.addSubview(productsTableView)
        
        NSLayoutConstraint.activate([
            productsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            productsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        productsTableView.register(ProductCell.self, forCellReuseIdentifier: "productCell")
        productsTableView.dataSource = self
        productsTableView.delegate = self
    }
    
    private func setupIndicator() {
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTotalPriceLabel() {
        view.addSubview(totalPriceLabel)
        
        NSLayoutConstraint.activate([
            totalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalPriceLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - Setup productsViewModelDelegate
    private func setupProductsViewModelDelegate() {
        productsViewModel.delegate = self
    }
}

//MARK: - TableView DataSource
extension ProductsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
                as? ProductCell else {
            fatalError("Could not dequeue cell with identifier: productCell")
        }
        cell.reload(with: products[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - TableViewDelegate
extension ProductsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - ProductsListViewModelDelegate
extension ProductsListViewController: ProductsListViewModelDelegate {
    func productsFetched(_ products: [Product]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.products = products
            self.productsViewModel.products = products
            self.productsTableView.reloadData()
        }
    }
    
    func showError(_ receivedError: Error) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: receivedError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func productsAmountChanged() {
        totalPriceLabel.text = "Total price: \(productsViewModel.totalPrice ?? 0) $"
    }
}

// MARK: - ProductCellDelegate
extension ProductsListViewController: ProductCellDelegate {
    func addProduct(for cell: ProductCell?) {
        if let indexPath = productsTableView.indexPath(for: cell!) {
            productsViewModel.addProduct(at: indexPath.row)
            
            if let updatedInfo = productsViewModel.products?[indexPath.row] {
                cell?.updateQuantityAndStockLabel(with: updatedInfo)
            }
        }
    }
    
    func removeProduct(for cell: ProductCell?) {
        if let indexPath = productsTableView.indexPath(for: cell!) {
            productsViewModel.removeProduct(at: indexPath.row)
            
            if let updatedInfo = productsViewModel.products?[indexPath.row] {
                cell?.updateQuantityAndStockLabel(with: updatedInfo)
            }
        }
    }
}
