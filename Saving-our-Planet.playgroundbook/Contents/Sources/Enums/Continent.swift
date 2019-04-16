import UIKit

enum Continent: Int, CaseIterable {
    
    case america, eurasia, africa, australia, greenland, madagascar, north, antarctica
    
    static var treeContinents: [Continent] {
        return [.america, .eurasia, .africa, .australia]
    }
    
    static var treeCount: Int {
        return allCases.reduce(0) {$0 + $1.trees}
    }
    
    var surfaceColor: UIColor {
        switch self {
        case .america, .eurasia, .madagascar:
            return #colorLiteral(red: 0.8091787696, green: 0.8040195704, blue: 0.1944794357, alpha: 1)
        case .africa:
            return #colorLiteral(red: 0.9823870063, green: 0.7863020301, blue: 0.5182315111, alpha: 1)
        case .australia:
            return #colorLiteral(red: 0.9553127885, green: 0.5278289914, blue: 0.4032028317, alpha: 1)
        case .greenland, .north, .antarctica:
            return #colorLiteral(red: 0.9962759614, green: 0.9800544381, blue: 0.9929981828, alpha: 1)
        }
    }
    
    var groundColor: UIColor {
        switch self {
        case .america, .eurasia, .madagascar:
            return #colorLiteral(red: 0.5834521651, green: 0.234023273, blue: 0.06505288184, alpha: 1)
        case .africa:
            return #colorLiteral(red: 0.5834521651, green: 0.234023273, blue: 0.06505288184, alpha: 1)
        case .australia:
            return #colorLiteral(red: 0.5101964474, green: 0.2847049534, blue: 0.223058939, alpha: 1)
        case .greenland, .north, .antarctica:
            return #colorLiteral(red: 0.6183160543, green: 0.6962625384, blue: 0.7414649129, alpha: 1)
        }
    }
    
    var path: UIBezierPath {
        return MapPaths.path(for: self)
    }
    
    var cities: [City] {
        return City.allCases.filter {$0.continent == self}
    }
    
    var trees: Int {
        return [75, 78, 35, 12, 0, 0, 0, 0][rawValue]
    }
    
}
