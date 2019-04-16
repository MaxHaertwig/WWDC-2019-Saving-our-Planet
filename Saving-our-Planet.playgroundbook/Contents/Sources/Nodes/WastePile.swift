import SceneKit
import UIKit

final class WastePile: Trash {
    
    let trashColor = #colorLiteral(red: 0.2853264213, green: 0.1731368601, blue: 0.1068866774, alpha: 1)
    
    override init(position: SCNVector3) {
        
        super.init(position: position)
        
        let body = SCNNode(geometry: SCNSphere(radius: 5, color: trashColor))
        body.scale = SCNVector3(1, CGFloat.random(in: 1 ... 1.3), 0.8)
//        body.scale = SCNVector3(10, 20, 30)
        addChildNode(body)
        
//        for _ in 1...5 {
//            let pile = SCNNode(geometry: SCNSphere(radius: 2, color: trashColor))
//            pile.position = SCNVector3(CGFloat.random(in: -3...3), 0, CGFloat.random(in: -3...3))
//            pile.scale = SCNVector3(CGFloat.random(in: 1...2), 1, CGFloat.random(in: 1...2))
//            body.addChildNode(pile)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
