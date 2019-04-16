import SceneKit
import UIKit

class Trash: SCNNode {
    
    override init() {
        super.init()
        geometry = SCNBox(width: 20, height: 20, length: 20, color: .clear)
    }
    
    init(position: SCNVector3) {
        super.init()
        self.position = position
        geometry = SCNBox(width: 20, height: 20, length: 20, color: .clear)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
