import SceneKit
import UIKit

final class Fireworks: SCNNode {
    
    private var particles = [SCNNode]()
    
    override init() {
        super.init()
        for _ in 1...80 {
            let particle = SCNNode(geometry: SCNBox(width: 2, height: 2, length: 2, color: UIColor.random()))
            particle.rotation = SCNVector4(CGFloat(Int.random(in: 0...1)), CGFloat(Int.random(in: 0...1)), CGFloat(Int.random(in: 0...1)), CGFloat.random(in: 0 ... .pi))
            particles.append(particle)
            addChildNode(particle)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func launch() {
        let launchDuration: TimeInterval = 1
        runAction(.sequence([
            .moveBy(x: CGFloat.random(in: 1...8), y: CGFloat.random(in: 1...8), z: -60, duration: launchDuration),
            .wait(duration: 2),
            .removeFromParentNode()
        ]))
        delay (launchDuration) {
            for particle in self.particles {
                let x = CGFloat.random(in: 10...30)
                let y = CGFloat.random(in: 10...30)
                let z = CGFloat.random(in: 10...30)
                let duration = TimeInterval.random(in: 1 ... 2)
                particle.runAction(.group([
                    .move(to: SCNVector3(Bool.random() ? x : -x, Bool.random() ? y : -y, Bool.random() ? z : -z), duration: duration),
                    .sequence([.wait(duration: duration * 0.85), .fadeOut(duration: duration * 0.15),])
                ]))
            }
        }
    }
    
}
