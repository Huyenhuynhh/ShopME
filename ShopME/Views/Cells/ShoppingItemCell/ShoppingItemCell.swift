//
//  ShoppingItemCell.swift
//  ShopME
//
//  Created by Huyen on 02/03/2022.
//

import UIKit

protocol ShoppingItemCellProtocol {
    func addItem(cell: ShoppingItemCell)
}

class ShoppingItemCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    // MARK: - Properties
    var delegate: ShoppingItemCellProtocol?
    
    // MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        itemNameLabel.layer.cornerRadius = 6
        itemNameLabel.clipsToBounds = true
    }
    
    // MARK: - Actions
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        delegate?.addItem(cell: self)
    }

    // MARK: - Public Methods
    func configure(with item: Item) {
        itemImageView.image = UIImage(named: item.image)
        itemNameLabel.text = " " + item.name
        itemDescriptionLabel.text = item.description
        itemPriceLabel.text = "$\(item.price)"
    }
}
