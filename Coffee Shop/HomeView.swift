//
//  ContentView.swift
//  Coffee Shop
//
//  Created by constantine kos on 05.10.2020.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var basketListener = BasketListener()
    
    var categories: [String: [Drink]] {
        
        .init(
            //grouping: drinkData,
            grouping: drinkListener.drinks,
            by: { $0.category.rawValue }
        )
    }
    
    @ObservedObject var drinkListener = DrinkListener()
    @State private var showingBasket = false
    @State private var showingLogin = false
    
    var body: some View {
        
        NavigationView() {
            
            List(categories.keys.sorted(), id: \String.self) { key in
                DrinkRow(categoryName: "\(key) Drink".uppercased(), drinks: categories[key]!)
                    //.frame(height: 320)
                    .padding([.top, .bottom])
            }.frame(width: UIScreen.main.bounds.width)
            
            
            .navigationBarTitle(Text("Coffee Shop"))
            .navigationBarItems(leading:
                                    Button(action: {
                                        FUser.logoutCurrentUser { (error) in
                                            print("### ERROR loging out user:", error?.localizedDescription)
                                        }
                                        //createMenu()
                                    }, label: {
                                        Text("Log out")
                                    })
                                    .sheet(isPresented: $showingLogin, content: {
                                        LoginView()
                                    })
                                , trailing:
                                    Button(action: {
                                        showingBasket.toggle()
                                    }, label: {
                                        if basketListener.orderBasket?.items.count != 0 {
                                            ZStack(alignment: .topTrailing) {
                                                Image(systemName: "bag.fill")
                                                    .padding()
                                                    .foregroundColor(.green)
                                                
                                                Text("\((basketListener.orderBasket?.items.count ?? 0))")
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                                    .padding(4)
                                                    .background(Color.red)
                                                    .clipShape(Circle())
                                            }
                                        } else {
                                            Image(systemName: "bag")
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.green)
                                        }
                                        
                                    })
                                    .sheet(isPresented: $showingBasket, content: {
                                        if FUser.currentUser() != nil && FUser.currentUser()!.onboarding {
                                            OrderBasketView()
                                        } else if FUser.currentUser() != nil {
                                            FinishRegistrationView()
                                        } else {
                                            LoginView()
                                        }
                                        
                                    })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
