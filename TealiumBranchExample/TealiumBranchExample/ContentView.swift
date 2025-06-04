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
                .frame(width: 280)
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
        ScrollView {
            VStack(spacing: 10) {
                Group {
                    Text("🛒 Commerce Events")
                        .font(.headline)
                        .padding(.top)
                    
                    EventButton(title: "Add To Cart", event: "cart_add", data: [
                        "buo": [
                            "canonical_identifier": "item_123",
                            "title": "Tealium Subscription",
                            "content_description": "Premium analytics subscription"
                        ],
                        "metadata": [
                            "sku": "sku123",
                            "product_name": "Tealium Subscription",
                            "product_brand": "Tealium",
                            "product_category": "SOFTWARE",
                            "price": 99.99,
                            "currency_type": "USD"
                        ],
                        "event": [
                            "revenue": 99.99,
                            "currency": "USD"
                        ]
                    ])
                    
                    EventButton(title: "Add To Wishlist", event: "wishlist_add", data: [
                        "buo": ["canonical_identifier": "item_456"],
                        "metadata": ["product_name": "Analytics Pro", "price": 199.99]
                    ])
                    
                    EventButton(title: "View Cart", event: "view_cart", data: [:])
                    
                    EventButton(title: "Purchase", event: "purchase", data: [
                        "event": [
                            "transaction_id": "txn_789",
                            "revenue": 99.99,
                            "currency": "USD",
                            "tax": 8.99,
                            "shipping": 5.99
                        ]
                    ])
                    
                    EventButton(title: "Subscribe", event: "email_signup", data: [
                        "event": ["revenue": 29.99, "currency": "USD"]
                    ])
                }
                
                Group {
                    Text("📱 Content Events")
                        .font(.headline)
                        .padding(.top)
                    
                    EventButton(title: "View Item", event: "product", data: [
                        "buo": [
                            "canonical_identifier": "product_123",
                            "title": "Premium Analytics",
                            "image_url": "https://example.com/image.jpg"
                        ]
                    ])
                    
                    EventButton(title: "Search", event: "search", data: [
                        "event": ["search_query": "analytics tools"]
                    ])
                    
                    EventButton(title: "Share", event: "share", data: [
                        "buo": ["canonical_identifier": "shared_item"]
                    ])
                    
                    EventButton(title: "Rate", event: "rate", data: [
                        "metadata": ["rating": 5.0, "rating_max": 5.0]
                    ])
                }
                
                Group {
                    Text("👤 User Lifecycle Events")
                        .font(.headline)
                        .padding(.top)
                    
                    EventButton(title: "Complete Registration", event: "user_register", data: [
                        "event": ["user_id": "user123"]
                    ])
                    
                    EventButton(title: "Complete Tutorial", event: "tutorial_complete", data: [:])
                    
                    EventButton(title: "Achieve Level", event: "level_up", data: [
                        "event": ["custom_data": ["level": "10"]]
                    ])
                    
                    EventButton(title: "Unlock Achievement", event: "unlock_achievement", data: [
                        "event": ["custom_data": ["achievement": "first_purchase"]]
                    ])
                    
                    EventButton(title: "Login", event: "login", data: [
                        "event": ["user_id": "user123"]
                    ])
                }
                
                Group {
                    Text("⚙️ Configuration Commands")
                        .font(.headline)
                        .padding(.top)
                    
                    EventButton(title: "Set User Identity", event: "set_user_identity", data: [
                        "user_id": "analytics_user_123"
                    ])
                    
                    EventButton(title: "Logout", event: "logout", data: [:])
                    
                    EventButton(title: "List on Spotlight", event: "list_on_spotlight", data: [
                        "buo": [
                            "canonical_identifier": "spotlight_item",
                            "title": "Searchable Content",
                            "content_description": "This content appears in Spotlight search",
                            "locally_index": true,
                            "publicly_index": false
                        ]
                    ])
                    
                    EventButton(title: "Enable Debug Mode", event: "set_debug_mode", data: [
                        "debug_params": ["test_mode": "true"]
                    ])
                }
                
                Group {
                    Text("🔧 Advanced Features")
                        .font(.headline)
                        .padding(.top)
                    
                    EventButton(title: "Test Deep Link", event: "handle_deep_link", data: [
                        "deep_link_url": "https://tealium-branch.app.link/test?param1=value1&user=testuser"
                    ])
                    
                    EventButton(title: "Add Facebook Partner Param", event: "add_facebook_partner", data: [
                        "parameter_name": "fb_campaign_id",
                        "parameter_value": "campaign_123"
                    ])
                    
                    EventButton(title: "Set Consumer Protection", event: "consumer_protection", data: [
                        "consumer_protection_level": "reduced"
                    ])
                    
                    EventButton(title: "Reset User Session", event: "reset_user_session", data: [:])
                }
                
                Text("🎯 Custom Event with Full BUO")
                    .font(.headline)
                    .padding(.top)
                
                EventButton(title: "Complex Custom Event", event: "teal_custom_event", data: [
                    "buo": [
                        "canonical_identifier": "complex_item_789",
                        "canonical_url": "https://example.com/items/789",
                        "title": "Complex Analytics Item",
                        "content_description": "Demonstrates full BUO properties",
                        "image_url": "https://example.com/image.jpg",
                        "keywords": ["analytics", "tealium", "branch"],
                        "locally_index": true,
                        "publicly_index": false
                    ],
                    "metadata": [
                        "sku": "complex_sku",
                        "product_name": "Advanced Analytics",
                        "product_brand": "Tealium",
                        "product_category": "SOFTWARE",
                        "product_variant": "Enterprise",
                        "price": 299.99,
                        "currency_type": "USD",
                        "quantity": 1,
                        "content_schema": "commerce_product",
                        "condition": "NEW",
                        "rating": 4.8,
                        "rating_average": 4.5,
                        "rating_count": 1250,
                        "rating_max": 5.0,
                        "custom_metadata": [
                            "department": "enterprise",
                            "tier": "premium"
                        ]
                    ],
                    "event": [
                        "revenue": 299.99,
                        "currency": "USD",
                        "transaction_id": "complex_txn_456",
                        "affiliation": "Tealium Store",
                        "coupon": "SAVE20",
                        "tax": 24.99,
                        "shipping": 0.0,
                        "event_description": "Complex event with all properties",
                        "ad_type": "banner",
                        "custom_data": [
                            "campaign": "q4_promotion",
                            "source": "mobile_app"
                        ]
                    ]
                ])
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
