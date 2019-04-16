import SceneKit
import UIKit

final class Ship: Vehicle {
    
    private let containerColors = [#colorLiteral(red: 0.8992936644, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.7135545807, alpha: 1), #colorLiteral(red: 0, green: 0.5, blue: 0.3188166618, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)]
    
    private let halfWidth: CGFloat = 4
    private let halfLength: CGFloat = 12
    private var hullPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -halfWidth, y: -halfLength))
        path.addLine(to: CGPoint(x: -halfWidth, y: halfLength - 6))
        path.addLine(to: CGPoint(x: 0, y: halfLength))
        path.addLine(to: CGPoint(x: halfWidth, y: halfLength - 6))
        path.addLine(to: CGPoint(x: halfWidth, y: -halfLength))
        path.close()
        return path
    }
    
    var oilSpill: OilSpill?
    
    override init() {
        super.init()
        
        let hull = SCNNode(geometry: SCNShape(path: hullPath, extrusionDepth: 4, color: #colorLiteral(red: 0.349999994, green: 0.349999994, blue: 0.349999994, alpha: 1)))
        
        let tower = SCNNode(geometry: SCNBox(width: 6, height: 2, length: 4, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
        tower.position = SCNVector3(0, -4, -4)
        
        let towerTop = SCNNode(geometry: SCNBox(width: 8, height: 1, length: 1, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
        towerTop.position = SCNVector3(0, 0, -2)
        tower.addChildNode(towerTop)
        
        let backContainer = SCNNode(geometry: SCNBox(width: 7.5, height: 6.5, length: 3, color: containerColors.randomElement()!))
        backContainer.position = SCNVector3(0, -8.5, -3.5)
        
        let middleContainer = SCNNode(geometry: SCNBox(width: 7, height: 5, length: 2, color: containerColors.randomElement()!))
        middleContainer.position = SCNVector3(0, -0.25, -3)
        
        let frontContainer = SCNNode(geometry: SCNBox(width: 5, height: 5, length: 2, color: containerColors.randomElement()!))
        frontContainer.position = SCNVector3(0, 5.25, -3)
        
        let intermediate = SCNNode()
        intermediate.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 0, 0, 1)
        [hull, tower, backContainer, middleContainer, frontContainer].forEach {intermediate.addChildNode($0)}
        addChildNode(intermediate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startRoute(travelAction: SCNAction, accident: Bool) {
        super.startRoute(travelAction: travelAction)
        if accident {
            delay(travelAction.duration * Double.random(in: 0.25 ... 0.75)) {
                self.isPaused = true
                self.spillOil()
                delay(7) {
                    self.isPaused = false
                }
            }
        }
    }
    
    var getOilSpill: OilSpill {
        if oilSpill == nil {
            oilSpill = OilSpill()
        }
        return oilSpill!
    }
    
    private func spillOil() {
        guard let oilSpill = oilSpill else {return}
        oilSpill.position = SCNVector3(position.x, position.y, -0.25)
        oilSpill.runAction(.sequence([
            .group([SCNAction.fadeIn(duration: 8), .scale(to: 0.8, duration: 8)]),
            .scale(to: 1, duration: 4)
        ]))
    }
    
}
