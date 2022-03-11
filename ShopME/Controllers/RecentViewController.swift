//
//  RecentViewController.swift
//  ShopME
//
//  Created by Huyen on 03/03/2022.
//

import UIKit

class RecentViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nothingView: UIView!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNothingView()
    }
}

// MARK: - Private Methods
extension RecentViewController {
    private func setupViews() {
        setupNavigationController()
        setupTableView()
    }
    
    private func setupNavigationController() {
        title = "Recent Orders"
        handleEditButton()
    }
    
    private func handleEditButton() {
        if CartManager.shared.recentOrders.count > 0 {
            let editItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editTapped))
            navigationItem.rightBarButtonItem = editItem
        }
    }
    
    @objc private func editTapped() {
        if navigationItem.rightBarButtonItem?.title == "Edit" {
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
        tableView.isEditing.toggle()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func handleNothingView() {
        if CartManager.shared.recentOrders.count == 0 {
            setNothingView(alpha: 1)
            navigationItem.rightBarButtonItem = nil
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
extension RecentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CartManager.shared.recentOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath)
        cell.textLabel?.text = "\(CartManager.shared.recentOrders[indexPath.row].quantity) items ($\(CartManager.shared.recentOrders[indexPath.row].totalCost))"
        cell.detailTextLabel?.text = CartManager.shared.recentOrders[indexPath.row].getDateAsString()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard tableView.isEditing else { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        CartManager.shared.recentOrders.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        handleNothingView()
    }
}
