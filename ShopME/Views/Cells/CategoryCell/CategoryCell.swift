//
//  CategoryCell.swift
//  ShopME
//
//  Created by Huyen on 02/03/2022.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    // MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Public Methods
    func configure(with category: Category) {
        if let imageData = category.imageData {
            categoryImageView.image = UIImage(data: imageData)
        } else if let imageName = category.image {
            categoryImageView.image = UIImage(named: imageName)
        }
        categoryNameLabel.text = category.name
        if category.id == 2 {
            NotificationCenter.default.addObserver(self, selector: #selector(itemsCountChanged), name: NSNotification.Name("ItemsCountChanged"), object: nil)
        }
    }
}

// MARK: - Private Methods
extension CategoryCell {
    @objc private func itemsCountChanged() {
        categoryNameLabel.text = "Cart (\(CartManager.shared.items.count))"
    }
}
