import SceneKit
import UIKit

final class Airplane: Vehicle {
    
    private let color = #colorLiteral(red: 0.878935039, green: 0.878935039, blue: 0.878935039, alpha: 1)
    private let wingLength: CGFloat = 12
    private var wingsPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 6))
        path.addLine(to: CGPoint(x: wingLength, y: 0))
        path.addLine(to: CGPoint(x: wingLength, y: -2))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -wingLength, y: -2))
        path.addLine(to: CGPoint(x: -wingLength, y: 0))
        path.close()
        return path
    }
    private var wingletsPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 3))
        path.addLine(to: CGPoint(x: wingLength / 3, y: 0))
        path.addLine(to: CGPoint(x: wingLength / 3, y: -2))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: -wingLength / 3, y: -2))
        path.addLine(to: CGPoint(x: -wingLength / 3, y: 0))
        path.close()
        return path
    }
    
    init(position: SCNVector3) {
        super.init()
        self.position = position
        
        let body = SCNNode(geometry: SCNSphere(radius: 0.5, color: color))
        body.scale = SCNVector3(3, 20, 3)
        
        let wings = SCNNode(geometry: SCNShape(path: wingsPath, extrusionDepth: 1, color: color))
        wings.position = SCNVector3(0, -3, 0)
        
        let winglets = SCNNode(geometry: SCNShape(path: wingletsPath, extrusionDepth: 1, color: color))
        winglets.position = SCNVector3(0, -10, 0)
        
        let cockpit = SCNNode(geometry: SCNSphere(radius: 0.5, color: .black))
        cockpit.scale = SCNVector3(2, 10, 1)
        cockpit.position = SCNVector3(0, 4.5, -0.5)
        
        let intermediate = SCNNode()
        intermediate.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 0, 0, 1)
        [body, wings, winglets, cockpit].forEach {intermediate.addChildNode($0)}
        addChildNode(intermediate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
