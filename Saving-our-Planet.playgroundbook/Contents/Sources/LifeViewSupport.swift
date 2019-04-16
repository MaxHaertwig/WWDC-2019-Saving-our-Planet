import PlaygroundSupport
import UIKit

public func instantiateLiveView() -> PlaygroundLiveViewable {
    return WorldViewController(options: ["game": true])
}

