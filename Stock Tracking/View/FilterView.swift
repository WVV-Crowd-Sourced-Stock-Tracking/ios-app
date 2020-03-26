//
//  FilterView.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

class FilterProduct: ObservableObject, Identifiable {
    @Published var isSelected: Bool {
        didSet {
            UserDefaults.standard.set(self.isSelected, forKey: "filter_\(self.product.id)")
        }
    }
    
    let product: ProductModel
    
    var id: Int {
        self.product.id
    }
    
    init(product: ProductModel) {
        self.product = product
        self.isSelected = UserDefaults.standard.bool(forKey: "filter_\(product.id)")
    }
}

struct FilterView: View {
	@Binding var show: Bool
    @State var products: [FilterProduct] = [ProductModel].all.map { FilterProduct(product: $0) }
	
    var body: some View {
        NavigationView {
            List {
                ForEach(products) { product in
                    FilterCell(product: product)
                }
            }
            .navigationBarTitle(.filterTitle)
			.navigationBarItems(trailing: VStack() {
				Button(action: {
					self.show.toggle()
				}) {
					Text("Fertig")
				}
			})
        }
		.navigationViewStyle(StackNavigationViewStyle())
        .onDisappear {
            NotificationCenter.default.post(name: .reloadShops, object: nil)
        }
    }
}

struct FilterCell: View {
    @ObservedObject var product: FilterProduct
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .stroke(Color.accent, lineWidth: 2)
                .modifier(GlowModifier())
                .overlay(
                    Circle()
                        .fill(Color.accent)
                        .modifier(GlowModifier())
                        .padding(3)
                        .opacity(product.isSelected ? 1 : 0)
                    
            )
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 16)
            Text(product.product.emoji)
                .font(.system(size: 21, weight: .medium, design: .default))
            Text(product.product.name)
                .font(.system(size: 21, weight: .medium, design: .default))
                .lineLimit(1)
                .layoutPriority(2)
            Color.white.opacity(0.001)
        }
        .padding(8)
        .onTapGesture {
            withAnimation {
                self.product.isSelected.toggle()
            }
        }
        
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
		FilterView(show: .constant(true))
    }
}