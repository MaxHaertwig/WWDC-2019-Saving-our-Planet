import SceneKit
import UIKit

final class Bird: SCNNode {
    
    enum FlyState {
        case start, fly, land
    }
    
    private let birdColor = UIColor.white
    private let landHeight, flyHeight: Float
    private let maxLife = Int.random(in: 14...18)
    
    private var rightWing, leftWing: SCNNode!
    private var angle: Float = 0
    private var lifetime = 0
    
    init(position: SCNVector3, flyHeight: Float) {
        
        landHeight = position.z
        self.flyHeight = flyHeight
        
        super.init()
        
        self.position = position
        geometry = SCNBox(width: 20, height: 20, length: 20, color: .clear)
        
        angle = Float.random(in: 0 ... 2 * Float.pi)
        rotation = SCNVector4(0, 0, 1, angle)
        
        let bodyPath = UIBezierPath()
        bodyPath.move(to: CGPoint(x: 0, y: 5))
        bodyPath.addLine(to: CGPoint(x: 1, y: 3))
        bodyPath.addLine(to: CGPoint(x: 1, y: -3))
        bodyPath.addLine(to: CGPoint(x: 2, y: -6))
        bodyPath.addLine(to: CGPoint(x: 0, y: -5.5))
        bodyPath.addLine(to: CGPoint(x: -2, y: -6))
        bodyPath.addLine(to: CGPoint(x: -1, y: -3))
        bodyPath.addLine(to: CGPoint(x: -1, y: 3))
        bodyPath.close()
        
        let body = SCNNode(geometry: SCNShape(path: bodyPath, extrusionDepth: 1, color: birdColor))
        addChildNode(body)
        
        let rightWingPath = UIBezierPath()
        rightWingPath.move(to: CGPoint(x: 1, y: 2))
        rightWingPath.addLine(to: CGPoint(x: 4, y: 3))
        rightWingPath.addLine(to: CGPoint(x: 12, y: -1))
        rightWingPath.addLine(to: CGPoint(x: 4, y: 0))
        rightWingPath.addLine(to: CGPoint(x: 1, y: -1))
        rightWingPath.close()
        
        rightWing = SCNNode(geometry: SCNShape(path: rightWingPath, extrusionDepth: 1, color: birdColor))
        rightWing.position = SCNVector3(0, -0.5, 0)
        addChildNode(rightWing)
        
        let leftWingPath = UIBezierPath()
        leftWingPath.move(to: CGPoint(x: -1, y: 2))
        leftWingPath.addLine(to: CGPoint(x: -4, y: 3))
        leftWingPath.addLine(to: CGPoint(x: -12, y: -1))
        leftWingPath.addLine(to: CGPoint(x: -4, y: 0))
        leftWingPath.addLine(to: CGPoint(x: -1, y: -1))
        leftWingPath.close()
        
        leftWing = SCNNode(geometry: SCNShape(path: leftWingPath, extrusionDepth: 1, color: birdColor))
        leftWing.position = SCNVector3(0, -0.5, 0)
        addChildNode(leftWing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startFlying() {
        let waitDuration = TimeInterval.random(in: 0...2)
        let rightFlap = SCNAction.sequence([
            .rotateBy(x: 0, y: 0.5, z: 0, duration: 0.25),
            .rotateBy(x: 0, y: -1, z: 0, duration: 0.5),
            .rotateBy(x: 0, y: 0.5, z: 0, duration: 0.25)
        ])
        let leftFlap = SCNAction.sequence([
            .rotateBy(x: 0, y: -0.5, z: 0, duration: 0.25),
            .rotateBy(x: 0, y: 1, z: 0, duration: 0.5),
            .rotateBy(x: 0, y: -0.5, z: 0, duration: 0.25)
        ])
        rightWing.runAction(flyingAction(flapAction: rightFlap, waitDuration: waitDuration))
        leftWing.runAction(flyingAction(flapAction: leftFlap, waitDuration: waitDuration))
        nextPart(state: .start)
    }
    
    private func flyingAction(flapAction: SCNAction, waitDuration: TimeInterval) -> SCNAction {
        return SCNAction.sequence([
            .wait(duration: waitDuration),
            .repeatForever(.sequence([
                .repeat(flapAction, count: 8),
                .wait(duration: 4)
            ]))
        ])
    }
    
    private func nextPart(state: FlyState) {
        
        let nextLength = Float.random(in: 6...8)
        let a = Float.random(in: 0.2 ... 0.5)
        let nextAngle = state == .start ? angle : angle + (Bool.random() ? a : -a)
        let duration = TimeInterval(nextLength / 7)
        let height = state == .start ? flyHeight : state == .fly ? position.z : landHeight
        
        let rotateAction = SCNAction.rotateTo(x: 0, y: 0, z: CGFloat(-nextAngle), duration: 1)
        let moveAction = SCNAction.move(to: SCNVector3(position.x + sin(nextAngle) * nextLength, position.y + cos(nextAngle) * nextLength, height), duration: duration)
        let action: SCNAction
        if state == .start {
            action = .group([rotateAction, moveAction, .fadeIn(duration: duration), .scale(to: 1, duration: duration)])
        } else if state == .fly {
            action = .group([rotateAction, moveAction])
        } else {
            action = .sequence([.group([rotateAction, moveAction, .group([.fadeOut(duration: duration), .scale(to: 0.5, duration: duration)])]), .removeFromParentNode()])
        }
        runAction(action) {
            self.lifetime += 1
            self.nextPart(state: self.lifetime >= self.maxLife ? .land : .fly)
        }
        
        angle = nextAngle
    }
    
}
