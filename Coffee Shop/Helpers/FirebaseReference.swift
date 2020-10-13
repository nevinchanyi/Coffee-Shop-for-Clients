//
//  FirebaseReference.swift
//  Coffee Shop
//
//  Created by constantine kos on 05.10.2020.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    case User
    case Menu
    case Order
    case Basket
}

func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
