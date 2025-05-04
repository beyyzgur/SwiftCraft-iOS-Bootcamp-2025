//
//  CartViewController.swift
//  LuxuriaApp
//
//  Created by beyyzgur on 3.05.2025.
//

import UIKit
import Lottie

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var lottieContainerView: UIStackView!
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    
    var productInCart: [CartModel] = []
    let cartViewModel = CartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell( )
        
        cartTableView.dataSource = self
        cartTableView.delegate = self
        
        setLottieAnimation()
        
        _ = cartViewModel.cartList.subscribe(onNext: { cart in
            self.productInCart = cart
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
                self.checkIsTableViewEmpty()
            }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchProductsFromCart()
        cartTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "fromCartToDetail",
              let product = sender as? ProductModel,
              let destinationVC = segue.destination as? ProductDetailViewController else { return }
        destinationVC.product = product
    }
    
    
    
    func registerTableViewCell() {
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
    }
    
    func setLottieAnimation() {
        DispatchQueue.main.async {
            self.lottieView.animation = LottieAnimation.named("empty-card")
            self.lottieView.contentMode = .scaleAspectFit
            self.lottieView.loopMode = .loop
        }
    }
    
//    func checkIsTableViewEmpty() {
//        if productInCart.isEmpty {
//            DispatchQueue.main.async {
//                self.lottieContainerView.isHidden = false
//                self.lottieView.play()
//                self.cartTableView.isHidden = true
//            }
//        } else {
//            self.cartTableView.isHidden = false
//            lottieContainerView.isHidden = true
//        }
//    }
    
    func checkIsTableViewEmpty() {
        DispatchQueue.main.async {
            if self.productInCart.isEmpty {
                UIView.animate(withDuration: 0.3, animations: {
                    self.cartTableView.alpha = 0
                }) { _ in
                    self.cartTableView.isHidden = true
                    self.lottieContainerView.alpha = 0
                    self.lottieContainerView.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        self.lottieContainerView.alpha = 1
                    }
                    self.lottieView.play()
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.lottieContainerView.alpha = 0
                }) { _ in
                    self.lottieContainerView.isHidden = true
                    self.cartTableView.alpha = 0
                    self.cartTableView.isHidden = false
                    UIView.animate(withDuration: 0.3) {
                        self.cartTableView.alpha = 1
                    }
                }
            }
        }
    }

    
    func fetchProductsFromCart() {
        cartViewModel.fetchProductfromCart(userName: "beyyzgur")
    }

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        let product = productInCart[indexPath.row]
        cell.configure(with: product, isFavorite: false)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cartTableView.deselectRow(at: indexPath, animated: true)
        let product = productInCart[indexPath.row] // cart model geliyor bu, bunu product cevirtip detaya aktarabilirim
        let productModelConverted = ProductModel(id: 0, // normalde id gelmeli ama gelmiyor ? :/
                                                 name: product.name ?? "",
                                                 image: product.image ?? "",
                                                 category: product.category ?? "",
                                                 price: product.price ?? 0,
                                                 brand: product.brand ?? "")
        performSegue(withIdentifier: "fromCartToDetail", sender: productModelConverted)
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func didClickedTrashButton(cartId: Int) {
        cartViewModel.deleteProductFromCart(productId: cartId)
    }
}
