//
//  StockItem.swift
//  MIP25-Aug20
//
//  Created by Sezgin Çiftci on 20.08.2025.
//

import SwiftUI

struct StockItem: View {
    
    var stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    var body: some View {
        HStack {
            Text(stock.symbol)
                .font(.headline)
                .foregroundStyle(Color.black)
            Spacer()
            
            Text(String(format: "%2.f$", stock.price))
                .foregroundStyle(Color.black)

            Text(String(format: "%2.f%%", stock.change))
                .foregroundColor(stock.change > 0 ? .green : .red)
        }
    }
}

#Preview {
    StockItem(
        stock: Stock(
            symbol: "AAPL",
            price: 190.0,
            change: 0.5
        )
    )
}
