import SwiftUI
import UIKit

extension Collection {
    func safe(at index: Index) -> Iterator.Element? {
        guard index >= self.startIndex && index < self.endIndex else {
            return nil
        }
        return self[index]
    }
}


class Coordinator: NSObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    @Binding var page: Int
    
    let controllers: [UIViewController]

    init(page: Binding<Int>, controllers: [UIViewController]) {
        self._page = page
        self.controllers = controllers
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
            let controller = pageViewController.viewControllers?.first,
            let index = self.controllers.firstIndex(of: controller) {
            withAnimation {
                self.page = index
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController),
            let before = self.controllers.safe(at: index - 1) {
            return before
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController),
            let before = self.controllers.safe(at: index + 1) {
            return before
        }
        return nil
    }
}

struct PageView: UIViewControllerRepresentable {
    
    @Binding var currentPage: Int
    
    let pages: [AnyView]
    
    init(pageIndex: Binding<Int>, pages: [AnyView]) {
        self._currentPage = pageIndex
        self.pages = pages
    }
    
    init<A: View>(pageIndex: Binding<Int>, @ViewBuilder pages: () -> A) {
        self.init(pageIndex: pageIndex, pages: [AnyView(pages())])
    }
    
    init<A: View, B: View>(pageIndex: Binding<Int>, @ViewBuilder pages: () -> TupleView<(A, B)>) {
        let views = pages().value
        self.init(pageIndex: pageIndex, pages: [AnyView(views.0), AnyView(views.1)])
    }
    
    init<A: View, B: View, C: View>(pageIndex: Binding<Int>, @ViewBuilder pages: () -> TupleView<(A, B, C)>) {
        let views = pages().value
        self.init(pageIndex: pageIndex,
                  pages: [AnyView(views.0), AnyView(views.1), AnyView(views.2)])
    }
    
    init<A: View, B: View, C: View, D: View>(pageIndex: Binding<Int>, @ViewBuilder pages: () -> TupleView<(A, B, C, D)>) {
        let views = pages().value
        self.init(pageIndex: pageIndex,
                  pages: [AnyView(views.0), AnyView(views.1), AnyView(views.2), AnyView(views.3)    ])
    }
    
    init<A: View, B: View, C: View, D: View, E: View>(pageIndex: Binding<Int>, @ViewBuilder pages: () -> TupleView<(A, B, C, D, E)>) {
        let views = pages().value
        self.init(pageIndex: pageIndex,
                  pages: [
                    AnyView(views.0),
                    AnyView(views.1),
                    AnyView(views.2),
                    AnyView(views.3),
                    AnyView(views.4)
        ])
    }
    
    init<A: View, B: View, C: View, D: View, E: View, F: View>(pageIndex: Binding<Int>, @ViewBuilder pages: () -> TupleView<(A, B, C, D, E, F)>) {
        let views = pages().value
        self.init(pageIndex: pageIndex,
                  pages: [
                    AnyView(views.0),
                    AnyView(views.1),
                    AnyView(views.2),
                    AnyView(views.3),
                    AnyView(views.4),
                    AnyView(views.5),
        ])
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(page: $currentPage,
                           controllers: pages.map { UIHostingController(rootView: $0) })
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PageView>) -> UIPageViewController {
        
        let controller = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal)
        
        controller.dataSource = context.coordinator
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ controller: UIPageViewController,
                                context: UIViewControllerRepresentableContext<PageView>) {
        controller.setViewControllers([context.coordinator.controllers[self.currentPage]],
                                      direction: .forward,
                                      animated: true)
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(pageIndex: .constant(0), pages: [])
    }
}
