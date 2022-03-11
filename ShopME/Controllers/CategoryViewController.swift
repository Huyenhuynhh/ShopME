//
//  CategoryViewController.swift
//  ShopME
//
//  Created by Huyen on 02/03/2022.
//

import UIKit

class CategoryViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nothingView: UIView!
    
    // MARK: - Properties
    var category: Category!
        
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(itemsCountChanged), name: NSNotification.Name("ItemsCountChanged"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNothingView()
    }
}

// MARK: - Private Methods
extension CategoryViewController {
    private func setupViews() {
        setupNavigationController()
        setupTableView()
    }
    
    private func setupNavigationController() {
        title = category.name
        let cartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        cartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        cartButton.setImage(UIImage(named: "cart"), for: .normal)
        let cartItem = UIBarButtonItem(customView: cartButton)
        let badgeLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 17, height: 17))
        badgeLabel.backgroundColor = .red
        badgeLabel.tag = 100
        badgeLabel.clipsToBounds = true
        badgeLabel.layer.cornerRadius = 8.5
        badgeLabel.text = "\(CartManager.shared.items.count)"
        badgeLabel.textColor = .black
        badgeLabel.font = UIFont.systemFont(ofSize: 12)
        badgeLabel.textAlignment = .center
        badgeLabel.minimumScaleFactor = 0.1
        badgeLabel.adjustsFontSizeToFitWidth = true
        cartItem.customView?.addSubview(badgeLabel)
        navigationItem.rightBarButtonItem = cartItem
    }
    
    @objc private func cartTapped() {
        let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartViewController")
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ShoppingItemCell", bundle: nil), forCellReuseIdentifier: "ShoppingItemCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func itemsCountChanged() {
        guard let cartView = navigationItem.rightBarButtonItem?.customView, let badgeLabel = cartView.viewWithTag(100) as? UILabel else { return }
        badgeLabel.text = "\(CartManager.shared.items.count)"
    }
    
    private func handleNothingView() {
        if category.items.count == 0 {
            setNothingView(alpha: 1)
        } else {
            setNothingView(alpha: 0)
        }
    }
    
    private func setNothingView(alpha: CGFloat) {
        UIView.animate(withDuration: 0.7) {
            self.nothingView.alpha = alpha
        }
    }
}

// MARK: - TableView Delegates
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        category.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath) as! ShoppingItemCell
        cell.configure(with: category.items[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ShoppingItemCell Delegate
extension CategoryViewController: ShoppingItemCellProtocol {
    func addItem(cell: ShoppingItemCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        CartManager.shared.addItem(item: category.items[indexPath.row])
    }
}
