import SceneKit
import UIKit

final class Tree: SCNNode {
    
    enum TreeKind {
        case pine, palm, leaf
    }
    
    var point: CGPoint
    
    init(kind: TreeKind, position: SCNVector3) {
        
        point = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
        
        super.init()
        
        self.position = position
        
        switch kind {
        case .pine:
            setupPine()
        case .palm:
            setupPalm()
        case .leaf:
            setupLeaf()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPine() {
        let trunkHeight: CGFloat = 8
        let trunk = SCNNode(geometry: SCNCylinder(radius: 1.5, height: trunkHeight, color: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)))
        trunk.position = SCNVector3(0, 0, -trunkHeight / 2)
        trunk.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        addChildNode(trunk)
        
        let height = CGFloat.random(in: 14...28)
        let cone = SCNNode(geometry: SCNCone(topRadius: 0, bottomRadius: 4, height: height, color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)))
        cone.position = SCNVector3(0, 0, -trunkHeight - height / 2)
        cone.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        addChildNode(cone)
    }
    
    private func setupPalm() {
        let height = CGFloat.random(in: 14...20)
        let trunk = SCNNode(geometry: SCNCylinder(radius: 1.5, height: height, color: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)))
        trunk.position = SCNVector3(0, 0, -height / 2)
        trunk.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        addChildNode(trunk)
        
        let cone = SCNNode(geometry: SCNCylinder(radius: 5, height: 2, color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
        cone.position = SCNVector3(0, 0, -height - 1)
        cone.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        addChildNode(cone)
    }
    
    private func setupLeaf() {
        let trunkHeight: CGFloat = 11
        let trunk = SCNNode(geometry: SCNCylinder(radius: 1.5, height: trunkHeight, color: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)))
        trunk.position = SCNVector3(0, 0, -trunkHeight / 2)
        trunk.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        addChildNode(trunk)
        
        let radius = CGFloat.random(in: 4...6)
        let cone = SCNNode(geometry: SCNSphere(radius: radius, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
        cone.position = SCNVector3(0, 0, -trunkHeight - radius / 2 - 1)
        cone.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        addChildNode(cone)
    }
    
    func appear() {
        runAction(.group([.fadeIn(duration: 1), .scale(to: 1, duration: 1)]))
    }
    
}
