//#-hidden-code
import UIKit
import PlaygroundSupport

struct World {
    init(name: String) {}
    var game: Bool!
    var waterColor: UIColor!
    var initialPollution: Int!
    var windTurbines: Int!
    var clouds: Number!
    var birds: Number!
    var airTraffic: TrafficVolume!
    var shipTraffic: TrafficVolume!
}
func simulateWorld(_ world: World) {}
//#-end-hidden-code
/*:
  # Experimentation
 
  __Congratulations!__ You saved the planet by making use of renewable energies and reducing the amount of trash and plastics. Did you see how the planet slowly recovered? As the pollution declines, trees and animals can thrive.
 
 This page is entirely __optional__. It allows you to play around with some parameters that can literally change the world. You can also turn off the game aspect and just watch.
 
 Press __Run My Code__ to see the results.
*/
//#-code-completion(everything, hide)
enum Number {
    case few, normal, many
}

enum TrafficVolume {
    case low, medium, high
}

var earth = World(name: "Earth")
earth.game = /*#-editable-code*/true/*#-end-editable-code*/
earth.waterColor = /*#-editable-code*/#colorLiteral(red: 0.2732537091, green: 0.613705039, blue: 0.6768248677, alpha: 1)/*#-end-editable-code*/
earth.initialPollution = /*#-editable-code*/50/*#-end-editable-code*/ // between 1 and 100
earth.windTurbines = /*#-editable-code*/2/*#-end-editable-code*/ // between 0 and 10
earth.clouds = /*#-editable-code*/.normal/*#-end-editable-code*/
earth.birds = /*#-editable-code*/.normal/*#-end-editable-code*/
earth.airTraffic = /*#-editable-code*/.medium/*#-end-editable-code*/
earth.shipTraffic = /*#-editable-code*/.medium/*#-end-editable-code*/
simulateWorld(earth)
//#-hidden-code
extension Number {
    var string: String {
        return self == .few ? "few" : self == .normal ? "normal" : "many"
    }
}
extension TrafficVolume {
    var string: String {
        return self == .low ? "low" : self == .medium ? "medium" : "high"
    }
}
PlaygroundPage.current.liveView = WorldViewController(options: [
    "game": earth.game,
    "waterColor": earth.waterColor,
    "pollution": earth.initialPollution,
    "windTurbines": earth.windTurbines,
    "clouds": earth.clouds.string,
    "birds": earth.birds.string,
    "airTraffic": earth.airTraffic.string,
    "shipTraffic": earth.shipTraffic.string
])
//#-end-hidden-code
