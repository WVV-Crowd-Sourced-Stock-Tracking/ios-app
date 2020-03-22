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
            
            VStack(spacing: 0) {
                PageView(pageIndex: $index) {
                    IntroView(title: .onboarding1Subtitle,
                              image: "onboarding1")
                    
                    IntroView(title: .onboarding2Subtitle,
                              image: "onboarding2")
                    
                    IntroView(title: .onboarding3Subtitle,
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
                    UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
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
    
    var buttonText: LocalizedStringKey {
        switch self.index {
        case 0, 1:
            return .onboardingContinue
        case 2:
            return .onboardingStart
        default:
            return ""
        }
    }
    
    var title: some View {
        let title: LocalizedStringKey
        switch self.index {
        case 0:
            title = .onboarding1Title
        case 1:
            title = .onboarding2Title
        case 2:
            title = .onboarding3Title
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
    let title: LocalizedStringKey
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
