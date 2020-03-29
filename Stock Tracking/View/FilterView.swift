import SwiftUI
import SwiftUIX

class FilterProduct: ObservableObject, Identifiable {
    @Published var isSelected: Bool
    
    func toggle() {
        self.isSelected.toggle()
        UserDefaults.standard.set(self.isSelected, forKey: "filter_\(self.id)")
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
    @Environment(\.presentationMode) var presentationMode
    
    @State var products: [FilterProduct] = []
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                List {
                    ForEach(self.products) { product in
                        VStack {
                            FilterCell(product: product)
                            if product.id == self.products.last?.id {
                                Spacer(minLength: 20)
                            }
                        }
                        
                    }
                }
                .frame(minHeight: proxy.size.height)
                .padding(.bottom, -40)
            }
            VStack(spacing: 20) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text(.filterButton)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .cornerRadius(10)
                        .animation(nil)
                }
                Button(action: {
                    withAnimation {
                        self.products.forEach {
                            if $0.isSelected {
                                $0.toggle()
                            }
                        }
                    }
                }) {
                    Text(.filterClear)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Color.secondary)
                }
            }
            .padding(.horizontal)
            .padding()
            .padding(.top, 10)
            .background(
                VStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [Color.systemBackground.opacity(0), .systemBackground]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                        .frame(height: 20)
                    Color.systemBackground.edgesIgnoringSafeArea(.all)
                }
            )
                .onAppear {
                                UIScrollView.appearance().backgroundColor = UIColor.systemBackground
            }
                .onDisappear {
                    NotificationCenter.default.post(name: .reloadShops, object: nil)
            }
            .onReceive(API.allProducts
            .replaceError(with: [])
            .receive(on: RunLoop.main)) { all in
                if self.products.isEmpty {
                    self.products = all.map { FilterProduct(product: ProductModel(product: $0, shopId: 0)) }
                }
            }
        }
        .navigationBarTitle(.filterTitle)
        .navigated()
    }
}

struct FilterCell: View {
    @ObservedObject var product: FilterProduct
    
    var body: some View {
        HStack(spacing: 16) {
            Text(product.product.emoji)
                .font(.system(size: 21, weight: .medium, design: .default))
            Text(product.product.name)
                .font(.system(size: 21, weight: .medium, design: .default))
                .lineLimit(1)
                .layoutPriority(2)
            Color.white.opacity(0.001)
            Checkbox(isOn: $product.isSelected)
                .modifier(CheckboxEffect(offset: product.isSelected ? 1 : 0))
        }
        .padding(12)
        .onTapGesture {
            withAnimation {
                self.product.toggle()
            }
        }
        
    }
}

struct CheckboxEffect: GeometryEffect {
    var offset: Double
    
    var animatableData: Double {
        get { offset }
        set { offset = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let effectValue = abs(sin(offset*Double.pi))
        let scale = CGFloat(1+0.3*effectValue)
        
        let affineTransform = CGAffineTransform.identity
            .translatedBy(x: size.width/2, y: size.height/2)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: -size.width/2, y: -size.height/2)
        return ProjectionTransform(affineTransform)
    }
}

struct Checkbox: View {
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            if isOn {
                Image(systemName: "checkmark.square.fill")
            }
            if !isOn {
                Image(systemName: "square")
            }
        }
        .font(.system(size: 20, weight: .medium, design: .default))
        .foregroundColor(Color.secondary)
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
