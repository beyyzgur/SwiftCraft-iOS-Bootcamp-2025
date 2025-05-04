//
//  HomePageViewController.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 26.04.2025.
//

import UIKit

class HomePageViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var productList = [ProductModel]()
    var filteredProductList = [ProductModel]()
    var cartList = [CartModel]()
    var homePageViewModel = HomePageViewModel()
    var allCategories = [String]()
    var filteredCategories = [String]()
    var categoriesToDisplay = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        registerCollectionViewCells()
        setProductCollectionViewLayout()
        
        _ = homePageViewModel.productList.subscribe(onNext: { products in
            self.productList = products
            self.filteredProductList = products
            self.updateCategories()
            DispatchQueue.main.async {
                self.productCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
            }
        })
        
        _ = homePageViewModel.cartList.subscribe(onNext: { cart in
            self.cartList = cart
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homePageViewModel.fetchProducts()
        homePageViewModel.fetchCart()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProductDetail" {
            if let product = sender as? ProductModel {
                if let destinationVC = segue.destination as? ProductDetailViewController {
                    destinationVC.product = product
                }
                
            }
        }
    }
    
    func updateCategories() {
        allCategories = Array(Set(productList.compactMap { $0.category }))
        categoriesToDisplay = ["Tüm Kategoriler"] + allCategories
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
        }
    }
    
    func filterProducts(by searchText: String) {
        filteredProductList = productList.filter { product in
            let productNameMatches = product.name?.lowercased().contains(searchText.lowercased()) ?? false
            let categoryMatches = product.category?.lowercased().contains(searchText.lowercased()) ?? false
            return productNameMatches || categoryMatches
        }
        DispatchQueue.main.async {
            self.productCollectionView.reloadData()
        }
    }
    
    func filterCategories(by searchText: String) {
        filteredCategories = allCategories.filter { $0.lowercased().contains(searchText.lowercased()) }
    }

    func setDelegates() {
        categoryCollectionView.delegate = self
        productCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        productCollectionView.dataSource = self
        searchBar.delegate = self
    }

    func registerCollectionViewCells() {
        productCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
    }

    func setProductCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 12
        let collectionViewWidth = productCollectionView.frame.width
        let itemWidth = (collectionViewWidth - (padding * 3)) / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4) // yüksekliği oranladık
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumLineSpacing = padding + 4
        layout.minimumInteritemSpacing = padding
        
        productCollectionView.collectionViewLayout = layout
    }
    
    func checkProductInCart(product: ProductModel) -> (isInCart: Bool, quantity: Int, cartId: Int) {
        for item in cartList {
            guard item.name == product.name else { continue }
            guard item.price == product.price else { continue }
            
            if let cartId = item.cart_id {
                let quantity = item.quantity ?? 1
                return (true, quantity, cartId)
            }
        }
        
        return (false, 0, 0)
    }
}

extension HomePageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProductList = productList
            filteredCategories = allCategories
        } else {
            filterProducts(by: searchText)
            filterCategories(by: searchText)
        }
        DispatchQueue.main.async {
            self.productCollectionView.reloadData()
            self.categoryCollectionView.reloadData()
        }
    }
}

extension HomePageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoriesToDisplay.count
        } else {
            return filteredProductList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            let category = categoriesToDisplay[indexPath.item]
            cell.categoryLabel.text = category
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            let product = filteredProductList[indexPath.item]
            cell.product = product
            cell.delegate = self
            cell.configure(with: product, isFavorite: FavoritesManager.shared.isFavorite(product))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView {
            let product = filteredProductList[indexPath.item]
            performSegue(withIdentifier: "toProductDetail", sender: product)
        } else if collectionView == categoryCollectionView {
            let selectedCategory = categoriesToDisplay[indexPath.item]
            if selectedCategory == "Tüm Kategoriler" {
                filteredProductList = productList
            } else {
                filteredProductList = productList.filter { $0.category == selectedCategory }
            }
            productCollectionView.reloadData()
        }
    }
}

extension HomePageViewController: ProductCollectionViewCellDelegate {
    func didClickedFavoritesButton(product: ProductModel) {
        if FavoritesManager.shared.isFavorite(product) {
            FavoritesManager.shared.removeFavorite(product)
        }else {
            FavoritesManager.shared.addFavorite(product)
        }
        productCollectionView.reloadData()
    }
    
    func didClickedAddToCartButton(product: ProductModel) {
        let (isInCart, quantity, cartId) = checkProductInCart(product: product)
        
        let checkedQuantity = isInCart ? quantity + 1 : 1
        
        if isInCart {
            homePageViewModel.deleteProductFromCart(cartId: cartId)
        }
        
        homePageViewModel.addProductToCart(product: product, checkedQuantity: checkedQuantity)
    }
}
