//
//  FavoritesViewController.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 26.04.2025.
//

import UIKit
import Lottie

class FavoritesViewController: UIViewController {
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var lottieView: LottieAnimationView!
    @IBOutlet weak var lottieStackView: UIStackView!
    
    var favoriteProductList: [ProductModel] = []
    let favoritesViewModel = FavoritesViewModel()
    var cartList = [CartModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegatesandDataSources()
        registerTableViewCell()
        setLottieAnimation()
        
        _ = favoritesViewModel.cartList.subscribe(onNext: { cart in
            self.cartList = cart
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteProductList = FavoritesManager.shared.getFavorites()
        favoritesTableView.reloadData()
        checkIsTableViewEmpty()
        favoritesViewModel.fetchCart()
    }
    
    func setDelegatesandDataSources() {
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
    }
    
    func registerTableViewCell() {
        favoritesTableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoritesTableViewCell")
    }
    
    func setLottieAnimation() {
        DispatchQueue.main.async {
            self.lottieView.animation = LottieAnimation.named("empty-favList")
            self.lottieView.contentMode = .scaleAspectFit
            self.lottieView.loopMode = .loop
        }
    }
    
//    func checkIsTableViewEmpty() {
//        if favoriteProductList.isEmpty {
//            DispatchQueue.main.async {
//                self.lottieStackView.isHidden = false
//                self.lottieView.play()
//                self.favoritesTableView.isHidden = true
//            }
//        } else {
//            self.favoritesTableView.isHidden = false
//            lottieStackView.isHidden = true
//        }
//    }
    
    func checkIsTableViewEmpty() {
        DispatchQueue.main.async {
            if self.favoriteProductList.isEmpty {
                UIView.animate(withDuration: 0.3, animations: {
                    self.favoritesTableView.alpha = 0
                }) { _ in
                    self.favoritesTableView.isHidden = true
                    self.lottieStackView.alpha = 0
                    self.lottieStackView.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        self.lottieStackView.alpha = 1
                    }
                    self.lottieView.play()
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.lottieStackView.alpha = 0
                }) { _ in
                    self.lottieStackView.isHidden = true
                    self.favoritesTableView.alpha = 0
                    self.favoritesTableView.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        self.favoritesTableView.alpha = 1
                    }
                }
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailFromFavorites" {
            guard let indexPath = favoritesTableView.indexPathForSelectedRow else { return }
            let product = favoriteProductList[indexPath.row]
            let destinationVC = segue.destination as! ProductDetailViewController
            destinationVC.product = product
        }
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

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = favoriteProductList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        cell.delegate = self
        cell.configure(with: product, isFavorite: FavoritesManager.shared.isFavorite(product))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = favoriteProductList[indexPath.row]
        performSegue(withIdentifier: "toDetailFromFavorites", sender: product)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = favoriteProductList[indexPath.row]
            
            let alert = UIAlertController(
                title: "Remove Favorite",
                message: "Are you sure you want to remove '\(product.name ?? "this item")' from your favorites?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                FavoritesManager.shared.removeFavorite(product)
                self.favoriteProductList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.checkIsTableViewEmpty()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension FavoritesViewController: FavoritesTableViewCellDelegate {
    func didTriggeredAddToCartButton(product: ProductModel) {
        let (isInCart, quantity, cartId) = checkProductInCart(product: product)
        
        let checkedQuantity = isInCart ? quantity + 1 : 1
        
        if isInCart {
            favoritesViewModel.deleteProductFromCart(cartId: cartId)
        }
        
        favoritesViewModel.addProductToCart(product: product, checkedQuantity: checkedQuantity)
    }
}
