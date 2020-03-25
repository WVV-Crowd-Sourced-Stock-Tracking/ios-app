//
//  LocationErrorCell.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 22.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct LocationErrorView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("location")
                .resizable()
                .scaledToFit()
//                .frame(maxHeight: 200)
            Text(.locationErrorTitle)
                .font(.system(size: 21, weight: .bold, design: .default))
                .foregroundColor(.primary)
            Text(.locationErrorBody)
                .font(.body)
                .foregroundColor(.secondary)
            Button(action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }) {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(.locationErrorButton)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accent)
                .cornerRadius(10)
            }
        }
        .padding(30)
        .frame(maxHeight: 400)
    }
}

struct LocationErrorCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationErrorView()
    }
}
