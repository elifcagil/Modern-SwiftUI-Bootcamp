//
//  ContentView.swift
//  MIP25-Aug20
//
//  Created by Sezgin Çiftci on 20.08.2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.red)
            
                Text("Hello, world!")
                    .fontWeight(.bold)
                    .modifier(Title(color: .blue))
            }
            
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.gray)
                
                HStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    
                    Text("Hello, world!")
                        .makeTitle(color: .red)
                }
            }
        }

        
    } //body
    
}

#Preview {
    ContentView()
}


struct Title: ViewModifier {
    
    var color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(color)
    }
}

extension View {
    func makeTitle(color: Color) -> some View {
        modifier(Title(color: color))
    }
}
