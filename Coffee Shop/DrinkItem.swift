//
//  DrinkItem.swift
//  Coffee Shop
//
//  Created by constantine kos on 05.10.2020.
//

import SwiftUI

struct DrinkItem: View {
    var drink: Drink
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(drink.imageName)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 280, height: 170)
                .cornerRadius(10)
                //.shadow(radius: 10)

            VStack(alignment: .leading, spacing: 5) {
                Text(drink.name)
                    .foregroundColor(.primary)
                    .font(.headline)
                
                Text(drink.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(height: 70)
            }
        }
    }
}

struct DrinkItem_Previews: PreviewProvider {
    static var previews: some View {
        DrinkItem(drink: drinkData[0])
    }
}
