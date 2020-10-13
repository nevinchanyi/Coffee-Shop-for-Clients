//
//  DrinkRow.swift
//  Coffee Shop
//
//  Created by constantine kos on 05.10.2020.
//

import SwiftUI

struct DrinkRow: View {
    var categoryName: String
    var drinks: [Drink]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(drinks) { drink in
                        NavigationLink(destination: DrinkDetail(drink: drink)) {
                            DrinkItem(drink: drink)
                                .frame(width: 280)
                                //.padding(.trailing, 30)
                            }
                        
                        
                    }
                }
                
            }
            
            
        }
        
    }
}

struct DrinkRow_Previews: PreviewProvider {
    static var previews: some View {
        DrinkRow(categoryName: "HOT DRINKS", drinks: drinkData)
    }
}
