import SceneKit
import UIKit

class Vehicle: SCNNode {
    
    private let fadeDuration: TimeInterval = 0.4
    
    func startRoute(travelAction: SCNAction) {
        opacity = 0
        runAction(.group([
            .fadeIn(duration: fadeDuration),
            travelAction,
            .sequence([
                .wait(duration: travelAction.duration - fadeDuration),
                .fadeOut(duration: fadeDuration),
                .removeFromParentNode()
            ])
        ]))
    }
    
}
