import SceneKit
import UIKit

final class Bottle: Trash {
    
    private let bottleColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    private let capColors = [#colorLiteral(red: 0.8992936644, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.7135545807, alpha: 1), #colorLiteral(red: 0, green: 0.5, blue: 0.3188166618, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)]
    
    override init(position: SCNVector3) {
        
        super.init(position: position)
        
        rotation = SCNVector4(0, 0, 1, CGFloat.random(in: 0...2 * CGFloat.pi))
        
        let radius: CGFloat = 1.5
        let height: CGFloat = 8
        let bottom = SCNNode(geometry: SCNCylinder(radius: radius, height: height, color: bottleColor))
        bottom.opacity = 0.5
        
        let head = SCNNode(geometry: SCNCone(topRadius: radius / 3, bottomRadius: radius, height: radius, color: bottleColor))
        head.position = SCNVector3(0, height / 2 + radius / 2, 0)
        head.opacity = 0.5
        
        let cap = SCNNode(geometry: SCNCylinder(radius: radius / 3 + 0.25, height: 0.7, color: capColors.randomElement()!))
        cap.position = SCNVector3(0, height / 2 + radius + 0.7 / 2, 0)
        
        let intermediate = SCNNode()
        intermediate.scale = SCNVector3(1.5, 1.5, 1.5)
        intermediate.rotation = SCNVector4(1, 0, 0, -.pi * 0.3)
        intermediate.addChildNode(head)
        intermediate.addChildNode(bottom)
        intermediate.addChildNode(cap)
        addChildNode(intermediate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
