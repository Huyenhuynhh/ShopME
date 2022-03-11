//
//  HomeViewController.swift
//  ShopME
//
//  Created by Huyen on 28/02/2022.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
        
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(categoryAdded), name: NSNotification.Name("CategoryAdded"), object: nil)
    }
}

// MARK: - Private Methods
extension HomeViewController {
    private func setupViews() {
        setupNavigationController()
        setupCollectionView()
    }
    
    @objc private func categoryAdded() {
        collectionView.insertItems(at: [IndexPath(item: CartManager.shared.categories.count - 1, section: 0)])
    }
    
    private func setupNavigationController() {
        title = "ShopME"
        let logoImage = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView = logoImage
        let managementItem = UIBarButtonItem(title: "Manage", style: .done, target: self, action: #selector(managementButtonTapped))
        navigationItem.rightBarButtonItem = managementItem
    }
    
    @objc private func managementButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "New Category", style: .destructive, handler: { _ in
            self.newCategoryTapped()
        }))
        alert.addAction(UIAlertAction(title: "New Item", style: .destructive, handler: { _ in
            self.newItemTapped()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.size.width - 80 , y: 0, width: 1.0, height: 1.0)
            popoverPresentationController.permittedArrowDirections = .right
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func newCategoryTapped() {
        let newCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewCategoryViewController")
        present(newCategoryVC, animated: true, completion: nil)
    }
    
    private func newItemTapped() {
        print("I couldn't do it at the time")
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 125, height: 125)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - CollectionView Delegates
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CartManager.shared.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.configure(with: CartManager.shared.categories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.item == 0 {
            let recentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentViewController")
            navigationController?.pushViewController(recentVC, animated: true)
        } else if indexPath.item == 1 {
            let cartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartViewController")
            navigationController?.pushViewController(cartVC, animated: true)
        } else {
            let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
            categoryVC.category = CartManager.shared.categories[indexPath.item]
            navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
}
