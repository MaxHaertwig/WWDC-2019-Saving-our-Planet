import SceneKit
import UIKit

func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}

extension Comparable {
    
    public func clamped(min minNum: Self, max maxNum: Self) -> Self {
        return max(minNum, min(self, maxNum))
    }
}

extension CGPoint {
    
    func distance(to other: CGPoint) -> CGFloat {
        return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
    
    func angle(to point: CGPoint) -> CGFloat {
        return atan2(point.y - y, point.x - x)
    }
}

extension UIBezierPath {
    
    convenience init(from: CGPoint, to: CGPoint) {
        self.init()
        move(to: from)
        addLine(to: to)
    }
    
    convenience init(ovalOf size: CGSize) {
        self.init(ovalIn: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size))
    }
    
    var center: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    var points: [CGPoint] {
        var points = [CGPoint]()
        withUnsafeMutablePointer(to: &points) { pointsPointer in
            cgPath.apply(info: pointsPointer) { userInfo, nextElementPointer in
                let element = nextElementPointer.pointee
                var point = CGPoint.zero
                switch element.type {
                case .moveToPoint: point = element.points[0]
                case .addLineToPoint: point = element.points[0]
                default: break
                }
                let elementsPointer = userInfo!.assumingMemoryBound(to: [CGPoint].self)
                elementsPointer.pointee.append(point)
            }
        }
        return points
    }
    
    func randomPoint(inset: CGFloat) -> CGPoint {
        var position: CGPoint!
        repeat {
            let x = CGFloat.random(in: bounds.origin.x + inset ... bounds.origin.x + bounds.size.width - inset)
            let y = CGFloat.random(in: bounds.origin.y + inset ... bounds.origin.y + bounds.size.height - inset)
            position = CGPoint(x: x, y: y)
        } while (!contains(position))
        return position
    }
    
    func randomPointNormalized(inset: CGFloat) -> CGPoint {
        let point = randomPoint(inset: inset)
        return CGPoint(x: point.x - bounds.origin.x - bounds.size.width / 2, y: point.y - bounds.origin.y - bounds.size.height / 2)
    }
    
}

enum PathElement {
    
    case moveToPoint(CGPoint)
    case addLineToPoint(CGPoint)
    case addQuadCurveToPoint(CGPoint, CGPoint)
    case addCurveToPoint(CGPoint, CGPoint, CGPoint)
    case closeSubpath
    
    init(element: CGPathElement) {
        switch element.type {
        case .moveToPoint: self = .moveToPoint(element.points[0])
        case .addLineToPoint: self = .addLineToPoint(element.points[0])
        case .addQuadCurveToPoint: self = .addQuadCurveToPoint(element.points[0], element.points[1])
        case .addCurveToPoint: self = .addCurveToPoint(element.points[0], element.points[1], element.points[2])
        case .closeSubpath: self = .closeSubpath
        }
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
    
    func blend(with color: UIColor, intensity: CGFloat) -> UIColor {
        let l1 = intensity
        let l2 = 1 - intensity
        guard l1 > 0 else { return color}
        guard l2 > 0 else { return self}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: l1 * r1 + l2 * r2, green: l1 * g1 + l2 * g2, blue: l1 * b1 + l2 * b2, alpha: l1 * a1 + l2 * a2)
    }
    
    func increaseBrightness(_ increase: CGFloat) -> UIColor {
        var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: max(0, min(b + increase, 1)), alpha: a)
    }
}

extension SCNNode {
    
    func fadeOutShrinkAndRemove(duration: TimeInterval) {
        runAction(.fadeOutShrinkAndRemoveFromParent(duration: duration))
    }
}

extension SCNMaterial {
    
    convenience init(color: UIColor) {
        self.init()
        diffuse.contents = color
    }
}

extension SCNAction {
    
    class func fadeOutShrinkAndRemoveFromParent(duration: TimeInterval) -> SCNAction {
        return SCNAction.sequence([
            .group([.fadeOut(duration: duration), .scale(to: 0, duration: duration)]),
            .removeFromParentNode()
        ])
    }
    
    class func moveAlong(path: UIBezierPath, z: CGFloat, speed: Double) -> SCNAction {
        let points = path.points
        var lastPoint = points.first!
        var lastAngle = lastPoint.angle(to: points[1])
        var actions = [SCNAction.rotateTo(x: 0, y: 0, z: lastAngle, duration: 0), SCNAction.move(to: SCNVector3(lastPoint.x, lastPoint.y, z), duration: 0)]
        
        for point in points[1...] {
            let duration = Double(point.distance(to: lastPoint)) / speed
            var angle = lastPoint.angle(to: point)
            if abs(angle - lastAngle) > .pi {
                if angle > 0 {
                    angle -= 2 * .pi
                } else {
                    angle += 2 * .pi
                }
            }
            actions.append(SCNAction.group([
                SCNAction.move(to: SCNVector3(point.x, point.y, z), duration: duration),
                SCNAction.rotateTo(x: 0, y: 0, z: angle, duration: duration / 3)
            ]))
            lastPoint = point
            lastAngle = angle
        }
        return SCNAction.sequence(actions)
    }
    
}

extension SCNSphere {
    
    convenience init(radius: CGFloat, color: UIColor) {
        self.init(radius: radius)
        materials = [SCNMaterial(color: color)]
    }
}

extension SCNPlane {
    
    convenience init(width: CGFloat, height: CGFloat, color: UIColor) {
        self.init(width: width, height: height)
        materials = [SCNMaterial(color: color)]
    }
}

extension SCNBox {
    
    convenience init(width: CGFloat, height: CGFloat, length: CGFloat, color: UIColor) {
        self.init(width: width, height: height, length: length, chamferRadius: 0)
        materials = [SCNMaterial(color: color)]
    }
}

extension SCNShape {
    
    convenience init(path: UIBezierPath, extrusionDepth: CGFloat, color: UIColor) {
        self.init(path: path, extrusionDepth: extrusionDepth)
        materials = [SCNMaterial(color: color)]
    }
}

extension SCNCylinder {
    
    convenience init(radius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(radius: radius, height: height)
        materials = [SCNMaterial(color: color)]
    }
}

extension SCNCone {
    
    convenience init(topRadius: CGFloat, bottomRadius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(topRadius: topRadius, bottomRadius: bottomRadius, height: height)
        materials = [SCNMaterial(color: color)]
    }
}

extension SCNCapsule {
    
    convenience init(capRadius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(capRadius: capRadius, height: height)
        materials = [SCNMaterial(color: color)]
    }
}
