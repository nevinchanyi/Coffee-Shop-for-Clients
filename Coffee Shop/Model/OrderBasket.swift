//
//  OrderBasket.swift
//  Coffee Shop
//
//  Created by constantine kos on 05.10.2020.
//

import Foundation
import Firebase

class OrderBasket: Identifiable {
    var id: String!
    var ownerID: String!
    var items: [Drink] = []
    
    var total: Double {
        if items.count > 0 {
            return items.reduce(0) { $0 + $1.price }
        } else {
            return 0.0
        }
    }
    
    func add(_ item: Drink) {
        items.append(item)
    }
    
    func remove(_ item: Drink) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    func emptyBasket() {
        items = []
        saveBasketToFirestore()
    }
    
    func saveBasketToFirestore() {
        firebaseReference(.Basket).document(id).setData(basketDictionary(self))
    }
}


func basketDictionary(_ basket: OrderBasket) -> [String: Any] {
    var allDrinkIds: [String] = []
    
    for drink in basket.items {
        allDrinkIds.append(drink.id)
    }
    
    return NSDictionary(objects: [basket.id,
                                  basket.ownerID,
                                  allDrinkIds],
                        forKeys: [kID as NSCopying,
                                  kOWNERID as NSCopying,
                                  kDRINKIDS as NSCopying]) as! [String : Any]
}
