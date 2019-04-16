import PlaygroundSupport
import SceneKit
import UIKit

public final class WorldViewController: UIViewController {

    private var worldScene: WorldScene
    private var scnView: SCNView!
    
    public init(options: [String: Any]) {
        worldScene = WorldScene(options: options)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.2732537091, green: 0.613705039, blue: 0.6768248677, alpha: 1)
        
        scnView = SCNView()
        scnView.scene = worldScene
        scnView.autoenablesDefaultLighting = false
        
        scnView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scnView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[scnView]-0-|", options: [], metrics: nil, views: ["scnView": scnView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[scnView]-0-|", options: [], metrics: nil, views: ["scnView": scnView]))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        scnView.gestureRecognizers = [tapGestureRecognizer]
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: scnView)
        let results = scnView.hitTest(location, options: [.rootNode: worldScene.tappableItemsNode, .boundingBoxOnly: true])
        worldScene.handleTap(on: results.map({$0.node}))
    }
    
    override public var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override public var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }

}
