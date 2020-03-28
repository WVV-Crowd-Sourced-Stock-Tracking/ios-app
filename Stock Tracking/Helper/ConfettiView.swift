import UIKit
import SwiftUI

private let kAnimationLayerKey = "com.nshipster.animationLayer"

public struct ConfettiView: UIViewRepresentable {
    /// Content to be emitted as confetti
    public enum Content {
        /// Confetti shapes
        public enum Shape {
            /// A circle.
            case circle

            /// A triangle.
            case triangle

            /// A square.
            case square

            // A custom shape.
            case custom(CGPath)
        }

        /// A shape with a particular color.
        case shape(Shape, UIColor)

        /// An image with an optional tint color.
        case image(UIImage, UIColor?)

        /// A string of characters.
        case text(String)
    }
    
    let contents: [Content]
    let duration: TimeInterval = 3.0
    
    @Binding var isEmitting: Bool
    
    public func makeUIView(context: Context) -> UIConfettiView {
        let view = UIConfettiView()
        view.coordinator = self.makeCoordinator()
        return view
    }
    
    public func updateUIView(_ uiView: UIConfettiView, context: Context) {
        if self.isEmitting {
            uiView.emit(with: self.contents,
                        for: self.duration)
        }
    }
    
    public typealias UIViewType = UIConfettiView
    
    public func makeCoordinator() -> ConfettiCoordinator {
        ConfettiCoordinator(isEmitting: self.$isEmitting)
    }
    
    
}


public class ConfettiCoordinator {
    @Binding var isEmitting: Bool
    
    init(isEmitting: Binding<Bool>) {
        self._isEmitting = isEmitting
    }
}

/// A view that emits confetti.
public final class UIConfettiView: UIView {
    public init() {
        super.init(frame: .zero)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        isUserInteractionEnabled = false
    }
    
    var coordinator: ConfettiCoordinator?

    // MARK: -

    /**
     Emits the provided confetti content for a specified duration.

     - Parameters:
        - contents: The contents to be emitted as confetti.
        - duration: The amount of time in seconds to emit confetti before fading out;
                    3.0 seconds by default.
    */
    public func emit(with contents: [ConfettiView.Content],
                     for duration: TimeInterval = 3.0)
    {
        let layer = Layer()
        layer.configure(with: contents)
        layer.frame = self.bounds
        layer.needsDisplayOnBoundsChange = true
        self.layer.addSublayer(layer)

        guard duration.isFinite else { return }

        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .forwards
        animation.values = [1, 0, 0]
        animation.keyTimes = [0, 0.5, 1]
        animation.isRemovedOnCompletion = false

        layer.beginTime = CACurrentMediaTime()
        layer.birthRate = 1.0

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let transition = CATransition()
            transition.delegate = self
            transition.type = .fade
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.setValue(layer, forKey: kAnimationLayerKey)
            transition.isRemovedOnCompletion = false

            layer.add(transition, forKey: nil)

            layer.opacity = 0
        }
        layer.add(animation, forKey: nil)
        CATransaction.commit()
    }

    // MARK: UIView

    override public func willMove(toSuperview newSuperview: UIView?) {
        guard let superview = newSuperview else { return }
        frame = superview.bounds
        isUserInteractionEnabled = false
    }

    // MARK: -

    // MARK: -

    private final class Layer: CAEmitterLayer {
        func configure(with contents: [ConfettiView.Content]) {
            emitterCells = contents.map { content in
                let cell = CAEmitterCell()

                cell.birthRate = 20.0
                cell.lifetime = 1.5
                cell.velocity = 500
                cell.velocityRange = cell.velocity / 1.5
                cell.emissionLongitude = .pi * 2
                cell.emissionRange = .pi / 8
//                cell.spinRange = .pi * 8
                cell.scaleRange = 0.25
                cell.scale = 1.0 - cell.scaleRange
                cell.contents = content.image.cgImage
                cell.alphaSpeed = 1
                cell.alphaRange = 1
                if let color = content.color {
                    cell.color = color.cgColor
                }

                return cell
            }
        }

        // MARK: CALayer

        override func layoutSublayers() {
            super.layoutSublayers()

            emitterMode = .outline
            emitterShape = .line
            emitterSize = CGSize(width: frame.size.width, height: 1.0)
            emitterPosition = CGPoint(x: frame.size.width / 2.0, y: frame.size.height)
        }
    }
}

// MARK: - CAAnimationDelegate

extension UIConfettiView: CAAnimationDelegate {
    public func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        if let layer = animation.value(forKey: kAnimationLayerKey) as? CALayer {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        print("animation end")
        self.coordinator?.isEmitting = false
    }
}

// MARK: -

fileprivate extension ConfettiView.Content.Shape {
    func path(in rect: CGRect) -> CGPath {
        switch self {
        case .circle:
            return CGPath(ellipseIn: rect, transform: nil)
        case .triangle:
            let path = CGMutablePath()
            path.addLines(between: [
                CGPoint(x: rect.midX, y: 0),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.midX, y: 0)
            ])

            return path
        case .square:
            return CGPath(rect: rect, transform: nil)
        case .custom(let path):
            return path
        }
    }

    func image(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: CGSize(width: 12.0, height: 12.0))
        return UIGraphicsImageRenderer(size: rect.size).image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.addPath(path(in: rect))
            context.cgContext.fillPath()
        }
    }
}

fileprivate extension ConfettiView.Content {
    var color: UIColor? {
        switch self {
        case let .image(_, color?),
             let .shape(_, color):
            return color
        default:
            return nil
        }
    }

    var image: UIImage {
        switch self {
        case let .shape(shape, _):
            return shape.image(with: .white)
        case let .image(image, _):
            return image
        case let .text(string):
            let defaultAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16.0)
            ]

            return NSAttributedString(string: "\(string)", attributes: defaultAttributes).image()
        }
    }
}

fileprivate extension NSAttributedString {
    func image() -> UIImage {
        return UIGraphicsImageRenderer(size: size()).image { _ in
            self.draw(at: .zero)
        }
    }
}

struct ConfettiView_Previews: PreviewProvider {
    struct Preview: View {
        @State var isEmitting: Bool = false
        var body: some View {
            VStack {
                Spacer()
                ConfettiView(contents: [
                    .image(UIImage(named: "heart")!, UIColor.empty),
                    .image(UIImage(named: "heart")!, UIColor.mid),
                    .image(UIImage(named: "heart")!, UIColor.accent),
                    .image(UIImage(named: "heart")!, UIColor.full),

                ], isEmitting: $isEmitting)
                    .background(Color.red)
                    .frame(maxWidth: .infinity, maxHeight: 100)
                Button(action: {
                    self.isEmitting = true
                }) {
                    Text("Start")
                }
            }
        }
    }
    static var previews: some View {
        Preview()
    }
}
