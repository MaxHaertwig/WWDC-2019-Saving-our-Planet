import UIKit

typealias WaterRoute = (path: UIBezierPath, destination: City)

enum City: Int, CaseIterable {
    
    case lagos, london, moscow, newYork, rio, sanFrancisco, shanghai, sydney
    
    static var coastalCities: [City] {
        return [.lagos, .london, .newYork, .rio, .sanFrancisco, .shanghai, .sydney]
    }
    
    static var inlandCities: [City] {
        return [.moscow]
    }
    
    static func randomCity() -> City {
        return allCases.randomElement()!
    }
    
    static func randomCoastalCity() -> City {
        return coastalCities.randomElement()!
    }
    
    var index: Int {
        return City.allCases.firstIndex(of: self)!
    }
    
    var path: UIBezierPath {
        return MapPaths.cities[index]
    }
    
    var waterRoutes: [WaterRoute] {
        return MapPaths.waterRoutes.filter({$0.1 == self || $0.2 == self}).map {
            return $0.1 == self ? ($0.0, $0.2) : ($0.0.reversing(), $0.1)
        }
    }
    
    var continent: Continent {
        switch self {
        case .sanFrancisco, .newYork, .rio:
            return .america
        case .london, .moscow, .shanghai:
            return .eurasia
        case .lagos:
            return .africa
        case .sydney:
            return .australia
        }
    }
    
    func randomOtherCity() -> City {
        return City.allCases.filter({$0 != self}).randomElement()!
    }
    
    func randomOtherCostalCity() -> City {
        return City.coastalCities.filter({$0 != self}).randomElement()!
    }
    
}

struct CityPair: Hashable {
    var first, second: City
}
