//
//  OrderView.swift
//  MIP25-Aug20
//
//  Created by Sezgin Çiftci on 20.08.2025.
//

import SwiftUI

struct OrderView: View {
    
    @State var amount: Int = 1
    
    var stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    var body: some View {
        Form {
            
            Section("Stock Info") {
                HStack {
                    Text(stock.symbol)
                    Spacer()
                    Text(String(format: "%2.f$", stock.price))
                        .foregroundStyle(Color.black)
                }
            }
            
            Section("Adet") {
                Stepper(value: $amount) {
                    Text("Adet: \(amount)")
                }
            }
            
            Section("Toplam Tutar") {
                Text(String(format: "%2.f$", Double(amount) * stock.price))
            }
        }
    }
}

#Preview {
    OrderView(
        stock: Stock(
            symbol: "TSLA",
            price: 250.0,
            change: -0.3
        )
    )
}
