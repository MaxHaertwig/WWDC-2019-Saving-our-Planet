import SceneKit
import UIKit

final class OilSpill: SCNNode {
    
    var trashNodes = [Trash]()
    
    private let oilColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    
    override init() {
        
        super.init()
        
        opacity = 0
        scale = SCNVector3(0, 0, 0)
        
        let bigSpill = Trash()
        bigSpill.addChildNode(SCNNode(geometry: SCNShape(path: UIBezierPath(ovalOf: CGSize(width: 26, height: CGFloat.random(in: 26...34))), extrusionDepth: 0.5, color: oilColor)))
        trashNodes.append(bigSpill)
        addChildNode(bigSpill)
        
        for _ in 1...4 {
            let smallSpill = Trash()
            smallSpill.addChildNode(SCNNode(geometry: SCNShape(path: UIBezierPath(ovalOf: CGSize(width: 16, height: CGFloat.random(in: 18...24))), extrusionDepth: 0.5, color: oilColor)))
            let x = CGFloat.random(in: 5...15)
            let y = CGFloat.random(in: 5...15)
            smallSpill.position = SCNVector3(Bool.random() ? x : -x, Bool.random() ? y : -y, 0)
            trashNodes.append(smallSpill)
            addChildNode(smallSpill)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
