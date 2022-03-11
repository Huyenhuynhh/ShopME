//
//  CartCell.swift
//  ShopME
//
//  Created by Huyen on 02/03/2022.
//

import UIKit

protocol CartCellProtocol {
    func increaseTapped(cell: CartCell)
    func decreaseTapped(cell: CartCell)
}

class CartCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    // MARK: - Properties
    var delegate: CartCellProtocol?
    
    // MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        itemNameLabel.layer.cornerRadius = 10
        itemNameLabel.clipsToBounds = true
    }

    // MARK: - Actions
    @IBAction func decreaseButtonTapped(_ sender: Any) {
        delegate?.decreaseTapped(cell: self)
    }
    
    @IBAction func increaseButtonTapped(_ sender: Any) {
        delegate?.increaseTapped(cell: self)
    }
    
    // MARK: - Public Methods
    func configure(itemName: String, quantity: Int, price: Double) {
        itemNameLabel.text = " " + itemName
        quantityLabel.text = "\(quantity)"
        let subTotal = Double(quantity) * price
        subTotalLabel.text = "$\(subTotal.rounded(toPlaces: 2))"
    }
}
