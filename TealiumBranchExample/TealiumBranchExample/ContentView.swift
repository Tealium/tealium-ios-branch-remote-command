//
//  ContentView.swift
//  TealiumBranchExample
//
//  Created by Tyler Rister on 10/14/21.
//

import SwiftUI

struct EventButton: View {
    let title: String
    let event: String
    let data: [String: Any]
    
    var body: some View {
        Button(action: {
            TealiumHelper.trackView(title: event, data: data)
        }, label: {
            Text(title)
                .frame(width: 200)
                .padding()
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .shadow(radius: 8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.purple, lineWidth: 2))
        })
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            EventButton(title: "Log Add To Cart", event: "cart_add", data: ["product_name": "Tealium Subscription", "product_id": "sku123"])
            EventButton(title: "Log Purchase", event: "order", data: ["product_name": "Tealium Beast", "product_id": "sku123", "product_category": "TOYS", "currency_type": "USD", "product_unit_price": "1.99"])
            EventButton(title: "Log Search Event", event: "search", data: ["product_name": "Tealium Beast", "product_id": "sku123", "product_category": "TOYS", "currency_type": "USD", "product_unit_price": "1.99"])
            EventButton(title: "Log Custom Event", event: "teal_custom_event", data: [:])
            EventButton(title: "Set Identity", event: "user_login", data: ["customer_id": "tealUser123"])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
