import SceneKit
import UIKit

final class Cloud: SCNNode {
    
    private let smogColor = #colorLiteral(red: 0.8789585142, green: 0.6746066893, blue: 0.3599697721, alpha: 1)
    
    init(position: SCNVector3, pollution: Int) {
        super.init()
        self.position = position
        for i in 1...Int.random(in: 14...20) {
            let radius = CGFloat.random(in: 6...12) + CGFloat(i) / 10
            let color = smogColor.blend(with: #colorLiteral(red: 0.9499999881, green: 0.9499999881, blue: 0.9499999881, alpha: 1), intensity: CGFloat(pollution) / 100).increaseBrightness(CGFloat.random(in: 0 ... 0.3))
            let node = SCNNode(geometry: SCNSphere(radius: radius, color: color))
            let x = CGFloat.random(in: -30...30)
            let y = CGFloat.random(in: -11...11)
            let z = CGFloat.random(in: -11...11)
            let adjustment = pow(9 / radius, 1.5)
            node.position = SCNVector3(x * adjustment, y * adjustment, z * adjustment)
            addChildNode(node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func run(to destination: SCNVector3, duration: TimeInterval, skipFadeIn: Bool) {
        if !skipFadeIn {
            opacity = 0
            scale = SCNVector3(0, 0, 0)
        }
        let fadeDuration = 6.0
        let fadeInAction = SCNAction.group([
            SCNAction.fadeIn(duration: fadeDuration),
            SCNAction.scale(to: 1, duration: fadeDuration)
        ])
        let waitAction = SCNAction.wait(duration: duration - 2 * fadeDuration)
        let finalAction = SCNAction.fadeOutShrinkAndRemoveFromParent(duration: fadeDuration)
        let lifecycleSequence = skipFadeIn ? SCNAction.sequence([waitAction, finalAction]) : SCNAction.sequence([fadeInAction, waitAction, finalAction])
        runAction(.group([lifecycleSequence, .move(to: destination, duration: duration)]))
    }
    
}
