//
//  StockView.swift
//  MIP25-Aug20
//
//  Created by Sezgin Çiftci on 20.08.2025.
//

import SwiftUI

struct Stock: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    var price: Double
    var change: Double
}

struct StockView: View {
    
    var stocks: [Stock] = [
        Stock(symbol: "AAPL", price: 190.0, change: 0.5),
        Stock(symbol: "TSLA", price: 250.0, change: -0.3),
        Stock(symbol: "AMZN", price: 130.0, change: 1.2),
        Stock(symbol: "GOOGL", price: 2800.0, change: -0.7),
        Stock(symbol: "MSFT", price: 320.0, change: 0.1),
        Stock(symbol: "NVDA", price: 430.0, change: -0.2),
        Stock(symbol: "META", price: 290.0, change: 0.9),
        Stock(symbol: "NFLX", price: 400.0, change: -0.6),
        Stock(symbol: "BABA", price: 85.0, change: 1.4),
        Stock(symbol: "ORCL", price: 110.0, change: -0.1),
        Stock(symbol: "BTC-USD", price: 29000.0, change: 2.1),
        Stock(symbol: "ETH-USD", price: 1850.0, change: -1.8)
    ]
    
    @State var selectedStock: Stock?
    
    var body: some View {
        NavigationStack {
            List(stocks) { stock in
                Button {
                    selectedStock = stock
                } label: {
                    StockItem(stock: stock)
                }

            } //List
            
            .navigationTitle("Borsa")
            .navigationDestination(item: $selectedStock) { stock in
                OrderView(stock: stock)
            }
        } //NavStack
    }
}

#Preview {
    StockView()
}
