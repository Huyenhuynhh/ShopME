//
//  NewCategoryViewController.swift
//  ShopME
//
//  Created by Huyen on 05/03/2022.
//

import UIKit

class NewCategoryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addNameButton: UIButton!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.dismissButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissButton.backgroundColor = .clear
    }
    
    // MARK: - Actions
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func addNameTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Category Name", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Category Name..."
        }
        alert.addAction(UIAlertAction(title: "Done", style: .destructive, handler: { [weak self] _ in
            guard let name = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
                self?.showAlert(title: "Sorry", message: "Please add category name")
                return
            }
            self?.categoryNameLabel.text = name
            self?.addNameButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            self?.addNameButton.setTitle(" Click here to change category name", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func publishTapped(_ sender: UIButton) {
        if isValidCategoryData() {
            publishCategory()
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Private Methods
extension NewCategoryViewController {
    private func setupViews() {
        setupContainerView()
        setupButtons()
    }
    
    private func setupContainerView() {
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.label.cgColor
        categoryImage.layer.cornerRadius = 8
        categoryImage.contentMode = .scaleToFill
    }
    
    private func setupButtons() {
        setupButton(publishButton)
        setupButton(cancelButton)
    }
    
    private func setupButton(_ button: UIButton) {
        button.layer.cornerRadius = 12
    }
    
    private func isValidCategoryData() -> Bool {
        guard categoryImage.image != nil else {
            showAlert(title: "Sorry", message: "Please add category image")
            return false
        }
        guard let name = categoryNameLabel.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
            showAlert(title: "Sorry", message: "Please add category name")
            return false
        }
        return true
    }
    
    private func publishCategory() {
        guard let imageData = categoryImage.image?.jpegData(compressionQuality: 1) else { return }
        guard CartManager.shared.isCategoryNameAvailable(name: categoryNameLabel.text!.trimmingCharacters(in: .whitespaces)) else {
            showAlert(title: "Sorry", message: "Looks like there is category with same name!")
            return
        }
        let category = Category(id: CartManager.shared.categories.count, name: categoryNameLabel.text!.trimmingCharacters(in: .whitespaces), image: nil, items: [], imageData: imageData)
        CartManager.shared.addNewCategory(category: category)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Picker Delegate
extension NewCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImage.image = image
        picker.dismiss(animated: true) { [weak self] in
            self?.addImageButton.setTitle(" Click here to change category image", for: .normal)
            self?.addImageButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
    }
}
