import SceneKit
import UIKit

final class WindTurbine: SCNNode {
    
    var built = false
    let point: CGPoint
    
    private let bodyColor = #colorLiteral(red: 0.9198423028, green: 0.9198423028, blue: 0.9198423028, alpha: 1)
    private let rotor = SCNNode()
    
    init(position: SCNVector3) {
        
        point = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
        
        super.init()
        
        self.position = position
        opacity = 1 / 3
        scale = SCNVector3(1.2, 1.2, 1.2)
        rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        
        let bladeWidth: CGFloat = 16
        let height: CGFloat = 30
        geometry = SCNBox(width: bladeWidth, height: height + bladeWidth / 2, length: bladeWidth, color: .clear)
        
        let tower = SCNNode(geometry: SCNCylinder(radius: 1.75, height: height, color: bodyColor))
        tower.position = SCNVector3(0, height / 2, 0)
        addChildNode(tower)
        
        let top = SCNNode(geometry: SCNCapsule(capRadius: 2.125, height: 3, color: bodyColor))
        top.position = SCNVector3(0, height, 0.5)
        top.scale = SCNVector3(1, 3, 1)
        top.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        addChildNode(top)
        
        let bladePath = UIBezierPath()
        bladePath.move(to: .zero)
        bladePath.addLine(to: CGPoint(x: -1.25, y: 0))
        bladePath.addLine(to: CGPoint(x: 0, y: bladeWidth))
        bladePath.addLine(to: CGPoint(x: 1.25, y: 0))
        bladePath.close()
        
        let bladeShape = SCNShape(path: bladePath, extrusionDepth: 1, color: bodyColor)
        let blade1 = SCNNode(geometry: bladeShape)
        rotor.addChildNode(blade1)
        
        let blade2 = SCNNode(geometry: bladeShape)
        blade2.rotation = SCNVector4(0, 0, 1, 2/3 * Float.pi)
        rotor.addChildNode(blade2)
        
        let blade3 = SCNNode(geometry: bladeShape)
        blade3.rotation = SCNVector4(0, 0, 1, 2/3 * -Float.pi)
        rotor.addChildNode(blade3)
        
        rotor.position = SCNVector3(0, top.position.y, 3.25)
        addChildNode(rotor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build() {
        built = true
        runAction(.fadeIn(duration: 0.25))
        rotor.runAction(.repeatForever(.rotateBy(x: 0, y: 0, z: -.pi, duration: 1)))
    }
    
}
