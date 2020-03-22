import SwiftUI

struct LandingView: View {
    
    @State private var index = 0
    
    @EnvironmentObject var sceneDelegate: SceneDelegate

    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            if self.index == 0 {
                self.title
            }
            if self.index == 1 {
                self.title
            }
            if self.index == 2 {
                self.title
            }
//            Spacer()
            
            VStack(spacing: 0) {
                PageView(pageIndex: $index) {
                    IntroView(title: "See what’s still in stock before leaving your home",
                              image: "onboarding1")
                    
                    IntroView(title: "Avoid unnecessary trips to the supermarkt to limit your social contact",
                              image: "onboarding2")
                    
                    IntroView(title: "Confirm and update the stock of the store and help others stay health",
                              image: "onboarding3")
                    
                }
                
                PageDots(numberOfPages: 3, currentPage: $index)
            }
            
            Button(action: {
                if self.index < 2 {
                    withAnimation {
                        self.index += 1
                    }
                } else {
                    self.sceneDelegate.showMain()
                }
            }) {
                Text(self.buttonText)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .animation(nil)
                    .background(Color.accent)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    var buttonText: String {
        switch self.index {
        case 0, 1:
            return "Continue"
        case 2:
            return "Start Exploring"
        default:
            return ""
        }
    }
    
    var title: some View {
        let title: String
        switch self.index {
        case 0:
            title = "What’s left?"
        case 1:
            title = "Stay Safe!"
        case 2:
            title = "Help others!"
        default:
            title = ""
        }
        
        return Text(title)
            .foregroundColor(.accent)
            .font(.system(size: 45, weight: .bold, design: .rounded))
            .transition(.opacity)
    }
}

struct IntroView: View {
    let title: String
    let image: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(self.title)
                .foregroundColor(.secondary)
                .font(.system(size: 24, weight: .regular, design: .default))
                .multilineTextAlignment(.center)
            
            Image(self.image)
                .frame(maxHeight: 250)
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
