//
//  PageDots.swift
//  Today
//
//  Created by Leo Mehlig on 04.03.20.
//  Copyright © 2020 Leo Mehlig. All rights reserved.
//

import SwiftUI

struct PageDots: UIViewRepresentable {
    let numberOfPages: Int
    
    @Binding var currentPage: Int
    
    func makeUIView(context: UIViewRepresentableContext<PageDots>) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = self.numberOfPages
        control.pageIndicatorTintColor = UIColor.secondaryLabel
        control.currentPageIndicatorTintColor = UIColor(named: "accent")
        return control
    }
    
    func updateUIView(_ control: UIPageControl, context: UIViewRepresentableContext<PageDots>) {
        control.currentPage = currentPage
    }
    
}

struct PageDots_Previews: PreviewProvider {
    static var previews: some View {
        PageDots(numberOfPages: 2, currentPage: .constant(1))
    }
}
