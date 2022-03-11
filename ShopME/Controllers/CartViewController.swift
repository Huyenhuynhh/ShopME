//
//  CartViewController.swift
//  ShopME
//
//  Created by Huyen on 02/03/2022.
//

import UIKit

class CartViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nothingView: UIView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subQuantityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var emptyButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNothingView()
    }
    
    // MARK: - Actions
    @IBAction func emptyButtonTapped(_ sender: UIButton) {
        reset()
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        displayPaymentAlert()
    }
}

// MARK: - Private Methods
extension CartViewController {
    private func setupViews() {
        setupNavigationController()
        setupTableView()
        handleLabelsAndButtons()
        calculateTotal()
    }
    
    private func setupNavigationController() {
        title = "Your Cart"
        let homeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        homeButton.setBackgroundImage(UIImage(named: "homeButton"), for: .normal)
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        let homeItem = UIBarButtonItem(customView: homeButton)
        navigationItem.rightBarButtonItem = homeItem
    }
    
    @objc private func homeTapped() {
        navigationController?.popToViewController(navigationController!.viewControllers.first!, animated: true)
    }
    
    private func setupTableView() {
        tableView.rowHeight = 44
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func handleLabelsAndButtons() {
        guard CartManager.shared.items.count == 0 else { return }
        subTotalLabel.isHidden = true
        subQuantityLabel.isHidden = true
        totalLabel.isHidden = true
        totalCostLabel.isHidden = true
        totalQuantityLabel.isHidden = true
        emptyButton.isHidden = true
        buyButton.isHidden = true
    }
    
    private func handleNothingView() {
        if CartManager.shared.items.count == 0 {
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
    
    private func calculateTotal() {
        totalQuantityLabel.text = "\(CartManager.shared.items.count)"
        totalCostLabel.text = "\(CartManager.shared.getTotalCost())"
    }
    
    private func displayPaymentAlert() {
        let alert = UIAlertController(title: "PAYMENT", message: "Your card will be charged $\(CartManager.shared.getTotalCost())", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Place Order", style: .destructive, handler: { _ in
            CartManager.shared.addToRecentOrders()
            self.displayDeliveryAlert()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func displayDeliveryAlert() {
        let alert = UIAlertController(title: "DONE!", message: "Your order will arrive within 6 hours", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { _ in
            self.reset()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func reset() {
        CartManager.shared.reset()
        tableView.reloadData()
        handleLabelsAndButtons()
        handleNothingView()
    }
    
    private func getRowIndex(for indexPath: IndexPath) -> Int {
        var row = 0
        for section in 0..<indexPath.section {
            let rows = tableView.numberOfRows(inSection: section)
            row += rows
        }
        row += indexPath.row
        return row
    }
    
    private func removeFromTableView(indexPath: IndexPath, categoryId: Int) {
        if !CartManager.shared.pickedCategoriesIds.contains(categoryId) {
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - TableView Delegates
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CartManager.shared.pickedCategoriesIds.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        CartManager.shared.getSectionTitle(index: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.getCellsCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.configure(itemName: CartManager.shared.uniqueItems[getRowIndex(for: indexPath)].name, quantity: CartManager.shared.quantities[getRowIndex(for: indexPath)], price: CartManager.shared.uniqueItems[getRowIndex(for: indexPath)].price)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - CartCell Delegate
extension CartViewController: CartCellProtocol {
    func increaseTapped(cell: CartCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let currentRow = getRowIndex(for: indexPath)
        CartManager.shared.increaseItem(index: currentRow)
        cell.configure(itemName: CartManager.shared.uniqueItems[getRowIndex(for: indexPath)].name, quantity: CartManager.shared.quantities[getRowIndex(for: indexPath)], price: CartManager.shared.uniqueItems[getRowIndex(for: indexPath)].price)
        calculateTotal()
    }
    
    func decreaseTapped(cell: CartCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let currentRow = getRowIndex(for: indexPath)
        let categoryId = CartManager.shared.uniqueItems[currentRow].categoryId
        if CartManager.shared.isLastItem(index: currentRow) {
            CartManager.shared.decreaseItem(index: currentRow)
            removeFromTableView(indexPath: indexPath, categoryId: categoryId)
        } else {
            CartManager.shared.decreaseItem(index: currentRow)
            cell.configure(itemName: CartManager.shared.uniqueItems[getRowIndex(for: indexPath)].name, quantity: CartManager.shared.quantities[getRowIndex(for: indexPath)], price: CartManager.shared.uniqueItems[getRowIndex(for: indexPath)].price)
        }
        calculateTotal()
        handleLabelsAndButtons()
        handleNothingView()
    }
}
