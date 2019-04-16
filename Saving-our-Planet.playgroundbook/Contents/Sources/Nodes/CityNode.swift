import SceneKit
import UIKit

final class CityNode: SCNNode {
    
    init(path: UIBezierPath, positionZ: CGFloat) {
        super.init()
        self.position = SCNVector3(path.center.x, path.center.y, positionZ)
        for _ in 1...18 {
            createBuilding(position: path.randomPointNormalized(inset: 7))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBuilding(position: CGPoint) {
        let width = CGFloat.random(in: 4...6)
        let height = CGFloat.random(in: 4...6)
        let length = CGFloat.random(in: 0...1) > 0.95 ? CGFloat.random(in: 30...50) : Bool.random() ? CGFloat.random(in: 10...14) : CGFloat.random(in: 14...20)
        let building = SCNNode(geometry: SCNBox(width: width, height: height, length: length, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        building.position = SCNVector3(position.x, position.y, 0)
        addChildNode(building)
    }
    
    func launchFireworks() {
        let fireworks = Fireworks()
        self.addChildNode(fireworks)
        fireworks.launch()
    }
    
}
