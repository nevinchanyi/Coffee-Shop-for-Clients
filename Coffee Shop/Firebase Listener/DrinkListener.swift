//
//  DrinkListener.swift
//  Coffee Shop
//
//  Created by constantine kos on 05.10.2020.
//

import Foundation
import Firebase

class DrinkListener: ObservableObject {
    @Published var drinks: [Drink] = []
    
    init() {
        downloadDrinks()
    }
    
    func downloadDrinks() {
        firebaseReference(.Menu).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                self.drinks = DrinkListener.drinkFromDictionary(snapshot)
            }
            
        }
    }
    
    static func drinkFromDictionary(_ snapshot: QuerySnapshot) -> [Drink] {
        var allDrinks: [Drink] = []
        for snapshot in snapshot.documents {
            let drinkData = snapshot.data()
            
            allDrinks.append(Drink(id: drinkData[kID] as? String ?? UUID().uuidString, name: drinkData[kNAME] as? String ?? "unknown", imageName: drinkData[kIMAGENAME] as? String ?? "unknown", category: Category(rawValue: drinkData[kCATEGORY] as? String ?? "category") ?? .cold, description: drinkData[kDESCRIPTION] as? String ?? "description is missing", price: drinkData[kPRICE] as? Double ?? 0.0))
        }
        return allDrinks
    }
}
