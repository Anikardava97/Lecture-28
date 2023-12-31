//
//  ProductsListViewModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import Foundation

protocol ProductsListViewModelDelegate: AnyObject {
    func productsFetched(_ products: [Product])
    func showError(_ receivedError: Error)
    func productsAmountChanged()
}

class ProductsListViewModel {
    
    weak var delegate: ProductsListViewModelDelegate?
    
    var products: [Product]?
    var totalPrice: Double? { products?.reduce(0) { $0 + $1.price * Double(($1.selectedAmount ?? 0))} }
    
    func viewDidLoad() {
        fetchProducts()
    }
    
    private func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] response in
            switch response {
            case .success(let products):
                self?.delegate?.productsFetched(products)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
    
    func addProduct(at index: Int) {
        guard let products = products, index >= 0, index < products.count else { return }
        var product = products[index]
        guard product.stock > 0 else { return }
        product.selectedAmount = (product.selectedAmount ?? 0) + 1
        product.stock -= 1
        self.products?[index] = product
        delegate?.productsAmountChanged()
    }
    
    func removeProduct(at index: Int) {
        guard let products = products, index >= 0, index < products.count else { return }
        var product = products[index]
        guard let selectedAmount = product.selectedAmount, selectedAmount > 0 else { return }
        product.selectedAmount = selectedAmount - 1
        product.stock += 1
        self.products?[index] = product
        delegate?.productsAmountChanged()
    }
}

