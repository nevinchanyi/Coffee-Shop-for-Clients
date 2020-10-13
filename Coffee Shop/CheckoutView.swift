//
//  CheckoutView.swift
//  Coffee Shop
//
//  Created by constantine kos on 05.10.2020.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var basketListener = BasketListener()
    
    static let paymentTypes = ["Cash", "Card"]
    static let tipAmounts = [10, 15, 20, 0]
    @State private var paymentType = 0
    @State private var tipAmount = 1
    
    @State private var showingPaymentAlert = false
    
    var totalPrice: Double {
        let total = basketListener.orderBasket.total
        let tipValue = total / 100 * Double(Self.tipAmounts[tipAmount])
        return total + tipValue
    }
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $paymentType, label: Text("How do you want to pay?")) {
                    ForEach(0..<Self.paymentTypes.count) {
                        Text(Self.paymentTypes[$0])
                    }
                }
            } // end of section
            
            Section(header: Text("Add a tip?")) {
                Picker(selection: $tipAmount, label: Text("Percentage")) {
                    ForEach(0..<Self.tipAmounts.count) {
                        Text("\(Self.tipAmounts[$0])%")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            } // end of section
            
            Section(header: Text("Total: $\(totalPrice, specifier: "%.2f")").font(.title)) {
                Button(action: {
                    print("Checkout working")
                    showingPaymentAlert.toggle()
                    createOrder()
                    emptyBasket()
                }, label: {
                    Text("Confirm Order")
                        .foregroundColor(.green)
                })
            } // end of section
            .disabled(basketListener.orderBasket?.items.isEmpty ?? true)
        }
        .navigationBarTitle(Text("Payment"), displayMode: .inline)
        .alert(isPresented: $showingPaymentAlert) {
            Alert(title: Text("Order Confirmed"), message: Text("Thank You!"), dismissButton: .default(Text("Ok")))
        }
    }
    private func createOrder() {
        let order = Order()
        order.amount = totalPrice
        order.id = UUID().uuidString
        order.customerID = FUser.currentId()
        order.orderItems = basketListener.orderBasket.items
        
        order.customerName = FUser.currentUser()?.fullName
        
        order.saveOrderToFirestore()
    }
    private func emptyBasket() {
        basketListener.orderBasket.emptyBasket()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
