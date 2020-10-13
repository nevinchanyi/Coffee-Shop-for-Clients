//
//  OrderBasketView.swift
//  Coffee Shop
//
//  Created by constantine kos on 05.10.2020.
//

import SwiftUI

struct OrderBasketView: View {
    @ObservedObject var basketListener = BasketListener()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(basketListener.orderBasket?.items.sorted(by: { $0.name < $1.name }) ?? []) { drink in
                        HStack {
                            Text(drink.name)
                            Spacer()
                            Text("$\(drink.price.clean)")
                        }//end of hstack
                    }//end of foreack
                    .onDelete { indexSet in
                        print("delete at \(indexSet)")
                        deleteItems(at: indexSet)
                    }
                }
                
                Section {
                    NavigationLink(destination: CheckoutView()) {
                        Text("Place Order")
                            .foregroundColor(.green)
                        }
                }.disabled(basketListener.orderBasket?.items.isEmpty ?? true)
                
            } //end of list
            .navigationTitle("Order")
            .listStyle(GroupedListStyle())
        }
    }
    func deleteItems(at offset: IndexSet) {
        basketListener.orderBasket.items.remove(at: offset.first!)
        basketListener.orderBasket.saveBasketToFirestore()
    }
}

struct OrderBasketView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBasketView()
    }
}
