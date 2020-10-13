//
//  DrinkDetail.swift
//  Coffee Shop
//
//  Created by constantine kos on 05.10.2020.
//

import SwiftUI

struct DrinkDetail: View {
    var drink: Drink
    @State private var showingAlert = false
    @State private var showingLogin = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .bottom) {
                Image(drink.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
                Rectangle()
                    .frame(height: 80)
                    .foregroundColor(.black)
                    .opacity(0.4)
                    .blur(radius: 10)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(drink.name)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    .padding([.leading, .bottom])
                    Spacer()
                } //end of HStack
            } // end of zstack
            .listRowInsets(EdgeInsets())
            Text(drink.description)
                .foregroundColor(.primary)
                .font(.body)
                .lineLimit(5)
                .padding()
            
            HStack {
                Spacer()
                OrderButton(drink: drink, showingAlert: $showingAlert, showingLogin: $showingLogin)
                Spacer()
            }
            .padding()
            
        } // end of scrollview
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(false)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Added to basket"), dismissButton: .default(Text("Ok")))
        }
    }
}

struct DrinkDetail_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDetail(drink: drinkData[0])
    }
}


struct OrderButton: View {
    @ObservedObject var basketListener = BasketListener()
    var drink: Drink
    @Binding var showingAlert: Bool
    @Binding var showingLogin: Bool
    
    var body: some View {
        Button(action: {
            if FUser.currentUser() != nil && FUser.currentUser()!.onboarding {
                showingAlert.toggle()
                addItemToBasket()
            } else {
                showingLogin.toggle()
            }
            
            print("Add to Bag: \(drink.name)")
        }, label: {
            Text("Add to Bag")
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 140, height: 50)
                .background(Color.green)
                .cornerRadius(10)
                .padding(.top, 20)
        })
        .sheet(isPresented: $showingLogin) {
            if FUser.currentUser() != nil {
                FinishRegistrationView()
            } else {
                LoginView()
            }
        }
    }
    private func addItemToBasket() {
        var orderBasket: OrderBasket!
        
        //check if user has basket
        if basketListener.orderBasket != nil {
            orderBasket = basketListener.orderBasket
        } else {
            orderBasket = OrderBasket()
            orderBasket.ownerID = FUser.currentId()
            orderBasket.id = UUID().uuidString
        }

        orderBasket.add(drink)
        orderBasket.saveBasketToFirestore()
    }
}
