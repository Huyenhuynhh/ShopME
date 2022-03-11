//
//  CartManager.swift
//  ShopME
//
//  Created by Huyen on 02/03/2022.
//

import Foundation

class CartManager {
    
    // MARK: - Signleton
    static let shared = CartManager()
    private init() {}
    
    // MARK: - Properties
    var items: [Item] = []
    var uniqueItems: [Item] = []
    var quantities: [Int] = []
    var pickedCategoriesIds: [Int] = []
    var recentOrders: [RecentOrder] = []
    var categories: [Category] = [
        Category(id: 1, name: "Recent Orders", image: "category-1-recent", items: []),
        Category(id: 2, name: "Cart (0)", image: "category-2-cart", items: []),
        Category(id: 3, name: "Grocery", image: "category-3-grocery", items: [Item(name: "Tomatoes", description: "On the vine", image: "grocery-1-tomatoes", price: 2.45, categoryId: 3, itemId: 1), Item(name: "Banana", description: "Very durable", image: "grocery-2-bananas", price: 0.49, categoryId: 3, itemId: 2), Item(name: "Apple", description: "Gala apples", image: "grocery-3-gala", price: 1.47, categoryId: 3, itemId: 3), Item(name: "Lettuce", description: "Grean leaf lettuce", image: "grocery-4-lettuce", price: 3.19, categoryId: 3, itemId: 4), Item(name: "Broccoli", description: "Bunch", image: "grocery-5-broccoli", price: 1.99, categoryId: 3, itemId: 5), Item(name: "Milk", description: "One box, organic", image: "grocery-6-milk", price: 4.49, categoryId: 3, itemId: 6), Item(name: "Bread", description: "6 items packet", image: "grocery-7-bread", price: 2.99, categoryId: 3, itemId: 7), Item(name: "Eggs", description: "6 eggs box", image: "grocery-8-eggs", price: 4.99, categoryId: 3, itemId: 8)]),
        Category(id: 4, name: "Clothing", image: "category-4-clothing", items: [Item(name: "T-Shirt", description: "95% cotton", image: "clothing-1-shirt", price: 17.5, categoryId: 4, itemId: 9), Item(name: "Shoes", description: "comfortable one", image: "clothing-2-shoes", price: 59, categoryId: 4, itemId: 10), Item(name: "Jacket", description: "Will keep you warm", image: "clothing-3-jacket", price: 129, categoryId: 4, itemId: 11), Item(name: "Pants", description: "comfortable one", image: "clothing-4-pants", price: 34.9, categoryId: 4, itemId: 12), Item(name: "Socks", description: "It would give you the motivation", image: "clothing-5-socks", price: 8.99, categoryId: 4, itemId: 13)]),
        Category(id: 5, name: "Movies", image: "category-5-movies", items: [Item(name: "Shawshank", description: "Drama - Action", image: "movies-1-shawshank", price: 24.99, categoryId: 5, itemId: 14), Item(name: "Lord of the rings", description: "Deep story", image: "movies-2-lord-of-the-rings", price: 22.5, categoryId: 5, itemId: 15), Item(name: "Godfather", description: "Deep story", image: "movies-3-godfather", price: 29.9, categoryId: 5, itemId: 16), Item(name: "Saving private ryan", description: "Based on a World War II drama. US soldiers try to save their comrade, paratrooper Private Ryan, who's stationed behind enemy lines", image: "movies-4-saving-private-ryan", price: 99.99, categoryId: 5, itemId: 17), Item(name: "Black hawk down", description: "The story of 160 elite U.S. soldiers who dropped into Mogadishu in October 1993 to capture two top lieutenants of a renegade warlord", image: "movies-5-black-hawk-down", price: 89.9, categoryId: 5, itemId: 18)]),
        Category(id: 6, name: "Garden", image: "category-6-garden", items: [Item(name: "Shovel", description: "Safe one", image: "garden-1-shovel", price: 14.90, categoryId: 6, itemId: 19), Item(name: "Tomato plant", description: "Let's eat organic", image: "garden-2-tomato-plant", price: 21.5, categoryId: 6, itemId: 20), Item(name: "Mower", description: "Safe one", image: "garden-3-mower", price: 40, categoryId: 6, itemId: 21), Item(name: "Garden soil", description: "Safe one", image: "garden-4-garden-soil", price: 50, categoryId: 6, itemId: 22), Item(name: "Fruit tree", description: "Let's eat organic", image: "garden-5-fruit-tree", price: 22, categoryId: 6, itemId: 23), Item(name: "Leaves rake", description: "Keep it beautiful", image: "garden-6-leaves-rake", price: 39, categoryId: 6, itemId: 24)]),
        Category(id: 7, name: "Electronics", image: "category-7-electronics", items: [Item(name: "iPhone 12 Pro", description: "256 GB - Blue", image: "elec-1-12pro", price: 1200, categoryId: 7, itemId: 25), Item(name: "AirPods Pro", description: "Activate noise cancellation and DIVE DEEP in the music!", image: "elec-2-airpods", price: 240, categoryId: 7, itemId: 26), Item(name: "MgSafe", description: "Charging is now easier than ever", image: "elec-3-mgsafe", price: 24.5, categoryId: 7, itemId: 27), Item(name: "MacBook Pro M1 Pro", description: "Feel the power with the baseline!", image: "elec-4-macbook", price: 2200, categoryId: 7, itemId: 28), Item(name: "Apple Watch", description: "Series 7 will keep you healthy", image: "elec-5-watch", price: 359.9, categoryId: 7, itemId: 29)]),
        Category(id: 8, name: "Books", image: "category-8-books", items: [Item(name: "Incarnation Cross", description: "A Guidebook of Purpose Archetypes : From Human Design and the Gene Keys", image: "books-1-HumanDesign", price: 14.99, categoryId: 8, itemId: 30), Item(name: "In Search of Lost Time", description: "by Marcel Proust", image: "books-2-LostTime", price: 8, categoryId: 8, itemId: 31), Item(name: "Ulysses", description: "by James Joyce", image: "books-3-Ulysses", price: 17, categoryId: 8, itemId: 32), Item(name: "One Hundred Years of Solitude", description: "by Gabriel Garcia Marquez", image: "books-4-HundredYears", price: 27, categoryId: 8, itemId: 33), Item(name: "Don Quixote", description: "by Miguel de Cervantes", image: "books-5-DonQuixote", price: 19.5, categoryId: 8, itemId: 34)]),
        Category(id: 9, name: "Appliances", image: "category-9-appliances", items: [Item(name: "Air Condition", description: "it will keep you cool, made by LG", image: "appliances-1-ar", price: 609, categoryId: 9, itemId: 35), Item(name: "Dishwasher", description: "Save your efforts!", image: "appliances-2-dishwasher", price: 139, categoryId: 9, itemId: 36), Item(name: "Microwave", description: "Keep your food warm!", image: "appliances-3-microwave", price: 199, categoryId: 0, itemId: 37), Item(name: "Washing Machine", description: "Keep your clothes new!", image: "appliances-4-washingmachine", price: 499, categoryId: 9, itemId: 38), Item(name: "Fridge", description: "Keep your food fresh!", image: "appliances-5-fridge", price: 600, categoryId: 9, itemId: 39)]),
        Category(id: 10, name: "Toys", image: "category-10-toys", items: [Item(name: "Blazin' Wheels", description: "Blazin' Wheels Red Wild Cross Utv 12 Volt Two Seater with Eva", image: "toys-1-blazin", price: 437.99, categoryId: 10, itemId: 40), Item(name: "Lil' Rider", description: "Lil' Rider 3 Wheel Trike Chopper Motorcycle", image: "toys-2-lil", price: 149, categoryId: 10, itemId: 41), Item(name: "Rolly", description: "Rolly Toys Cat Kid Backhoe Pedal Tractor with Front Loader", image: "toys-3-rolly", price: 291, categoryId: 10, itemId: 42), Item(name: "Magnet Tiles", description: "Mag-Genius Magnet Tiles, 141 + 2 Pieces", image: "toys-4-141", price: 62.99, categoryId: 10, itemId: 43), Item(name: "Magnetic Building", description: "Mag-Genius Magnetic Building Blocks 60 Piece Set", image: "toys-5-60", price: 24.99, categoryId: 10, itemId: 44)])
    ]
    
    // MARK: - Public Methods
    func addItem(item: Item) {
        if let sameItemIndex = items.lastIndex(where: {$0.itemId == item.itemId}) {
            items.insert(item, at: sameItemIndex + 1)
        } else if let sameCategoryIndex = items.lastIndex(where: {$0.categoryId == item.categoryId}) {
            items.insert(item, at: sameCategoryIndex + 1)
        } else {
            items.append(item)
        }
        NotificationCenter.default.post(name: NSNotification.Name("ItemsCountChanged"), object: nil)
        if !pickedCategoriesIds.contains(item.categoryId) {
            pickedCategoriesIds.append(item.categoryId)
        }
        if !uniqueItems.contains(where: {$0.itemId == item.itemId}) {
            if let itemCategoryIndex = uniqueItems.lastIndex(where: {$0.categoryId == item.categoryId}) {
                uniqueItems.insert(item, at: itemCategoryIndex + 1)
                quantities.insert(1, at: itemCategoryIndex + 1)
            } else {
                uniqueItems.append(item)
                quantities.append(1)
            }
        } else {
            guard let indexInUniqueArray = uniqueItems.firstIndex(where: {$0.itemId == item.itemId}) else { return }
            quantities[indexInUniqueArray] += 1
        }
    }
    
    func getSectionTitle(index: Int) -> String? {
        switch pickedCategoriesIds[index] {
        case 3:
            return "Grocery"
        case 4:
            return "Clothing"
        case 5:
            return "Movies"
        case 6:
            return "Garden"
        case 7:
            return "Electronics"
        case 8:
            return "Books"
        case 9:
            return "Appliances"
        case 10:
            return "Toys"
        default: return nil
        }
    }
    
    func getCellsCount(for section: Int) -> Int {
        let categoryId = pickedCategoriesIds[section]
        var cellsCount = 0
        for item in uniqueItems {
            if item.categoryId == categoryId {
                cellsCount += 1
            }
        }
        return cellsCount
    }
    
    func getTotalCost() -> Double {
        var totalCost: Double = 0
        for item in items {
            totalCost += item.price
        }
        return totalCost.rounded(toPlaces: 2)
    }
    
    func reset() {
        items = []
        uniqueItems = []
        quantities = []
        pickedCategoriesIds = []
        NotificationCenter.default.post(name: NSNotification.Name("ItemsCountChanged"), object: nil)
    }
    
    func increaseItem(index: Int) {
        addItem(item: uniqueItems[index])
    }
    
    func isLastItem(index: Int) -> Bool {
        let itemId = uniqueItems[index].itemId
        var sameItemCount = 0
        for item in items {
            if item.itemId == itemId {
                sameItemCount += 1
            }
        }
        return sameItemCount < 2
    }
    
    func decreaseItem(index: Int) {
        guard let uniqueArrayIndex = uniqueItems.firstIndex(where: {$0.itemId == uniqueItems[index].itemId}) else { return }
        items.remove(at: items.firstIndex(where: {$0.itemId == uniqueItems[uniqueArrayIndex].itemId})!)
        if quantities[uniqueArrayIndex] == 1 {
            quantities.remove(at: uniqueArrayIndex)
            uniqueItems.remove(at: uniqueArrayIndex)
        } else {
            quantities[uniqueArrayIndex] -= 1
        }
        for (index, id) in pickedCategoriesIds.enumerated() {
            if !uniqueItems.contains(where: {$0.categoryId == id}) {
                pickedCategoriesIds.remove(at: index)
                break
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("ItemsCountChanged"), object: nil)
    }
    
    func addToRecentOrders() {
        let recentOrder = RecentOrder(quantity: items.count, totalCost: getTotalCost().rounded(toPlaces: 2), date: Date())
        recentOrders.append(recentOrder)
        recentOrders.sort(by: {$0.date > $1.date})
        if recentOrders.count > 10 {
            recentOrders.remove(at: recentOrders.count - 1)
        }
    }
    
    func isCategoryNameAvailable(name: String) -> Bool {
        for category in categories {
            if category.name == name {
                return false
            }
        }
        return true
    }
    
    func addNewCategory(category: Category) {
        categories.append(category)
        NotificationCenter.default.post(name: NSNotification.Name("CategoryAdded"), object: nil)
    }
}
