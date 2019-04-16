import SceneKit
import UIKit

final class WorldScene : SCNScene {
    
    let worldMapNode = SCNNode()
    let tappableItemsNode = SCNNode()
    
    private var waterColor = #colorLiteral(red: 0.2732537091, green: 0.613705039, blue: 0.6768248677, alpha: 1)
    
    private let game: Bool
    private var airTraffic = 0, shipTraffic = 0, cloudTraffic = 0, birdTraffic: Float = 1
    private let options: [String: Any]
    private var pollution, pollutionBefore: Int
    
    private let treeLine: CGFloat = 360
    private let mountainElevation: CGFloat = 4
    private let cityHeight: CGFloat = -12
    private let birdHeight: Float = -26
    private let airplaneStartHeight: CGFloat = -20
    private let airplaneHeight: CGFloat = -48
    private let cloudsHeight: CGFloat = -62
    private let airplaneSpeed: Double = 80
    private let shipSpeed: Double = 20
    
    private var cityNodes = [CityNode]()
    private var activeFlights = Set<CityPair>()
    private var activeCruises = Set<CityPair>()
    private var treeNodes = Set<Tree>()
    private var windTurbineNodes = [WindTurbine]()
    private var madagascarTree: Tree?
    
    private var won = false
    private var trashCollected = 0, windTurbines = 0
    private var ticks = 0, nextAirplane = 0, nextShip = 0, nextCloud = 0, nextTrash = 0, nextFireworks = -1
    private var tickTimer: Timer!
    
    init(options: [String: Any]) {
        
        self.options = options
        
        if let game = options["game"] as? Bool {
            self.game = game
        } else {
            game = false
        }
        
        if let waterColor = options["waterColor"] as? UIColor {
            self.waterColor = waterColor
        }
        
        if let pollution = options["pollution"] as? Int {
            self.pollution = pollution.clamped(min: 1, max: 100)
        } else {
            pollution = game ? 50 : 0
        }
        
        pollutionBefore = pollution
        
        if let airTraffic = options["airTraffic"] as? String {
            if airTraffic == "low" {
                self.airTraffic += 1
            } else if airTraffic == "high" {
                self.airTraffic -= 1
            }
        }
        
        if let shipTraffic = options["shipTraffic"] as? String {
            if shipTraffic == "low" {
                self.shipTraffic += 2
            } else if shipTraffic == "high" {
                self.shipTraffic -= 2
            }
        }
        
        if let cloudTraffic = options["clouds"] as? String {
            if cloudTraffic == "low" {
                self.cloudTraffic += 2
            } else if cloudTraffic == "high" {
                self.cloudTraffic -= 2
            }
        }
        
        if let birdTraffic = options["birds"] as? String {
            if birdTraffic == "low" {
                self.birdTraffic = 0.75
            } else if birdTraffic == "high" {
                self.birdTraffic = 1.75
            }
        }
        
        super.init()
        
        let water = SCNNode(geometry: SCNPlane(width: 1000 * 2, height: 600 * 2, color: waterColor))
        water.position = SCNVector3(x: 0, y: 0, z: 0)
        rootNode.addChildNode(water)
        
        let camera = SCNCamera()
        camera.zFar = 1000
        camera.focalLength = 25
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(0, -270, 650)
        cameraNode.camera = camera
        cameraNode.look(at: SCNVector3(0, -15, 0))
        rootNode.addChildNode(cameraNode)
        
        worldMapNode.pivot = SCNMatrix4MakeTranslation(500, 300, 0)
        worldMapNode.rotation = SCNVector4(1, 0, 0, CGFloat.pi)
        worldMapNode.addChildNode(tappableItemsNode)
        
        setupLight()
        
        if options["empty"] == nil {
            Continent.allCases.forEach {setupContinent($0)}
            if options["hideGreenland"] == nil {
                setupIce()
            }
            setupMountains()
            setupCities()
            setupTimer()
            
            if let windTurbines = options["windTurbines"] as? Int {
                let number = windTurbines.clamped(min: 0, max: 10)
                if number > 0 { createWindTurbine(on: .eurasia) }
                if number > 1 { createWindTurbine(on: .america) }
                if number > 2 { createWindTurbine(on: .africa) }
                if number > 3 { createWindTurbine(on: .australia) }
                if number > 4 { createWindTurbine(on: .eurasia) }
                if number > 5 { createWindTurbine(on: .america) }
                if number > 6 { createWindTurbine(on: .africa) }
                if number > 7 { createWindTurbine(on: .australia) }
                if number > 8 { createWindTurbine(on: .eurasia) }
                if number > 9 { createWindTurbine(on: .america) }
            }
        }
        
        rootNode.addChildNode(worldMapNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLight() {
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 80
        worldMapNode.light = ambientLight
        
        let light = SCNLight()
        light.type = .spot
        light.spotInnerAngle = 30
        light.spotOuterAngle = 130
        light.castsShadow = true
        light.shadowMode = .forward
        light.shadowSampleCount = 8
        light.shadowMapSize = CGSize(width: 2048, height: 2048)
        light.zFar = 1000
        let sun = SCNNode()
        sun.position = SCNVector3(320, 200, 600)
        sun.light = light
        sun.constraints = [SCNLookAtConstraint(target: worldMapNode)]
        rootNode.addChildNode(sun)
    }
    
    private func setupContinent(_ continent: Continent) {
        if (continent == .greenland && options["hideGreenland"] != nil) || (continent == .madagascar && options["hideMadagascar"] != nil) {
            return
        }
        createFlatNode(path: continent.path, depth: 6, chamferRadius: 0, color: continent.groundColor, position: SCNVector3(0, 0, -3))
        createFlatNode(path: continent.path, depth: 6, chamferRadius: 2, color: continent.surfaceColor, position: SCNVector3(0, 0, -9))
        for _ in 0..<continent.trees * (100 - pollution) / 100 {
            createTree(on: continent)
        }
        if continent == .madagascar {
            madagascarTree = createTree(on: .madagascar, persistent: true)
        }
    }
    
    @discardableResult private func createTree(on continent: Continent, persistent: Bool = false) -> Tree{
        var position: CGPoint!
        repeat {
            position = continent.path.randomPoint(inset: 10)
        } while continent.cities.contains(where: {$0.path.contains(position)}) || windTurbineNodes.contains(where: {$0.point.distance(to: position) < 10})
        let treeKind: Tree.TreeKind
        let mountains: [UIBezierPath]
        if continent == .australia {
            treeKind = .leaf
            mountains = MapPaths.australiaMountains
        } else {
            treeKind = continent.path.bounds.minY + position.y < treeLine ? .pine : .palm
            mountains = continent == .africa ? MapPaths.africaMountains : MapPaths.greenMountains
        }
        let adjustment: CGFloat = mountains.contains(where: {$0.contains(position)}) ? -mountainElevation : 0
        let nodePosition = SCNVector3(position.x, position.y, cityHeight + adjustment)
        let tree = Tree(kind: treeKind, position: nodePosition)
        if !persistent {
            treeNodes.insert(tree)
        }
        worldMapNode.addChildNode(tree)
        return tree
    }
    
    private func setupIce() {
        for path in MapPaths.ice {
            createFlatNode(path: path, depth: 8, chamferRadius: 4, color: #colorLiteral(red: 0.9962759614, green: 0.9800544381, blue: 0.9929981828, alpha: 1), position: SCNVector3(0, 0, cityHeight - 4))
        }
    }
    
    private func setupMountains() {
        let position = SCNVector3(0, 0, cityHeight - 2)
        for path in MapPaths.greenMountains {
            createFlatNode(path: path, depth: mountainElevation, chamferRadius: 2, color: Continent.eurasia.surfaceColor, position: position)
        }
        for path in MapPaths.africaMountains {
            createFlatNode(path: path, depth: mountainElevation, chamferRadius: 2, color: Continent.africa.surfaceColor, position: position)
        }
        for path in MapPaths.australiaMountains {
            createFlatNode(path: path, depth: mountainElevation, chamferRadius: 2, color: Continent.australia.surfaceColor, position: position)
        }
    }
    
    private func createFlatNode(path: UIBezierPath, depth: CGFloat, chamferRadius: CGFloat, color: UIColor, position: SCNVector3) {
        let geometry = SCNShape(path: path, extrusionDepth: depth)
        if chamferRadius > 0 {
            geometry.chamferMode = .back
            geometry.chamferRadius = chamferRadius
            geometry.chamferProfile = UIBezierPath(from: CGPoint(x: 0, y: 1), to: CGPoint(x: 1, y: 0))
        }
        geometry.materials = [SCNMaterial(color: color)]
        let node = SCNNode(geometry: geometry)
        node.position = position
        worldMapNode.addChildNode(node)
    }
    
    private func setupCities() {
        for city in City.allCases {
            let cityNode = CityNode(path: city.path, positionZ: cityHeight)
            worldMapNode.addChildNode(cityNode)
            cityNodes.append(cityNode)
        }
    }
    
    private func setupTimer() {
        startAirplane()
        startShip()
        for _ in 1...4 {
            startCloud(skipFadeIn: true)
        }
        if !game {
            if options["windTurbines"] == nil {
                createWindTurbine(on: .america)
                createWindTurbine(on: .america)
                createWindTurbine(on: .eurasia)
                createWindTurbine(on: .eurasia)
                createWindTurbine(on: .africa)
                createWindTurbine(on: .australia)
            }
        } else if pollution > 0 {
            for _ in 1..<pollution + 10 {
                placeTrash(skipFadeIn: true)
            }
        }
        for _ in 1 ... (100 - pollution) / 6 {
            startBird()
        }
        tickTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in self.tick() })
    }
    
    private func tick() {
        
        print(pollution)
        
        if ticks == nextAirplane {
            startAirplane()
            nextAirplane = ticks + airTraffic + Int.random(in: 2...3)
        }
        
        if ticks == nextShip  {
            startShip()
            nextShip = ticks + shipTraffic + Int.random(in: 4...7)
        }
        
        if ticks == nextCloud {
            startCloud(skipFadeIn: false)
            nextCloud = ticks + cloudTraffic + Int.random(in: 5...6)
        }
        
        if pollution < 100 && Float.random(in: 0..<1) * birdTraffic < (100 - Float(pollution)) / 100 {
            startBird()
        }
        
        print("won \(won) poll \(pollution) turb \(windTurbines)")
        
        if won {
            if ticks == nextFireworks {
                cityNodes.forEach {$0.launchFireworks()}
                nextFireworks = ticks + 7
            }
        } else if game {
            if ticks == nextTrash {
                pollution += 1
                placeTrash(skipFadeIn: false)
                if windTurbines >= 5 {
                    nextTrash = ticks + 1
                } else {
                    nextTrash = ticks + 1 + (Int.random(in: 1 ... 5 - windTurbines) == 1 ? 1 : 0)
                }
            }
            if windTurbines >= 5 && pollution < 20 - windTurbines {
                victory()
            }
        }
        
        let difference = (pollution.clamped(min: 0, max: 100) - pollutionBefore.clamped(min: 0, max: 100)) * 2
        if difference < 0 {
            for _ in 1 ... -difference {
                createTreeAtRandomLocation()
            }
        } else if difference > 0 {
            for _ in 1...difference {
                removeRandomTree()
            }
        }
        
        if options["hideMadagascar"] == nil {
            handleMadagascarTree()
        }
        
        pollutionBefore = pollution
        ticks += 1
    }
    
    private func startAirplane() {
        var city, otherCity: City!
        var cityPair: CityPair!
        var tries = 0
        repeat {
            tries += 1
            if tries == 100 {
                return
            }
            city = City.randomCity()
            otherCity = city.randomOtherCity()
            cityPair = CityPair(first: city, second: otherCity)
        } while activeFlights.contains {$0 == cityPair || $0 == CityPair(first: otherCity, second: city)}
        activeFlights.insert(cityPair)
        
        let origin = city.path.center
        let destination = otherCity.path.center
        let duration = Double(origin.distance(to: destination)) / airplaneSpeed
        
        let airplane = Airplane(position: SCNVector3(origin.x, origin.y, airplaneStartHeight))
        worldMapNode.addChildNode(airplane)
        airplane.rotation = SCNVector4(0, 0, 1, origin.angle(to: destination))
        airplane.startRoute(travelAction: .sequence([
            .move(to: SCNVector3(origin.x + (destination.x - origin.x) * 0.25, origin.y + (destination.y - origin.y) * 0.25, airplaneHeight), duration: duration * 0.25),
            .move(to: SCNVector3(origin.x + (destination.x - origin.x) * 0.75, origin.y + (destination.y - origin.y) * 0.75, airplaneHeight), duration: duration * 0.5),
            .move(to: SCNVector3(destination.x, destination.y, airplaneStartHeight), duration: duration * 0.25)
        ]))
        delay(duration) {
            self.activeFlights.remove(cityPair)
        }
    }
    
    private func startShip() {
        var city: City!
        var waterRoute: WaterRoute!
        var cityPair: CityPair!
        var tries = 0
        repeat {
            tries += 1
            if tries == 100 {
                return
            }
            city = City.randomCoastalCity()
            waterRoute = city.waterRoutes.randomElement()!
            cityPair = CityPair(first: city, second: waterRoute.destination)
        } while activeCruises.contains {$0 == cityPair || $0 == CityPair(first: waterRoute.destination, second: city)}
        activeCruises.insert(cityPair)
        
        let ship = Ship()
        worldMapNode.addChildNode(ship)
        let travelAction = SCNAction.moveAlong(path: waterRoute.path, z: -2, speed: shipSpeed)
        let accident = game && !won && Int.random(in: 1...20) == 1
        if accident {
            pollution += 5
            tappableItemsNode.addChildNode(ship.getOilSpill)
        }
        ship.startRoute(travelAction: travelAction, accident: accident)
        delay(travelAction.duration) {
            self.activeCruises.remove(cityPair)
        }
    }
    
    private func startCloud(skipFadeIn: Bool) {
        let origin = CGPoint(x: CGFloat.random(in: 0...1000), y: CGFloat.random(in: 80...520))
        let cloud = Cloud(position: SCNVector3(origin.x, origin.y, cloudsHeight), pollution: pollution)
        let destinationX = origin.x + (Bool.random() || origin.x > 750 ? CGFloat.random(in: -600 ... -200) : CGFloat.random(in: 200...600))
        let destinationY = origin.y + CGFloat.random(in: 0...100)
        cloud.run(to: SCNVector3(destinationX, destinationY, cloudsHeight), duration: TimeInterval.random(in: 30...40), skipFadeIn: skipFadeIn)
        worldMapNode.addChildNode(cloud)
    }
    
    private func placeTrash(skipFadeIn: Bool) {
        let position = CGPoint(x: CGFloat.random(in: 100...895), y: CGFloat.random(in: 70...520))
        let onLand = MapPaths.continents.contains {$0.contains(position)}
        let trash: Trash
        if onLand {
            let height = cityHeight + (MapPaths.mountains.contains(where: {$0.contains(position)}) ? -mountainElevation : 0)
            trash = WastePile(position: SCNVector3(position.x, position.y, height))
        } else {
            trash = Bottle(position: SCNVector3(position.x, position.y, 0))
        }
        
        tappableItemsNode.addChildNode(trash)
        
        if !skipFadeIn {
            trash.opacity = 0
            trash.scale = SCNVector3(0, 0, 0)
            trash.runAction(.group([.fadeIn(duration: 1), .scale(to: 1, duration: 1)]))
        }
    }
    
    private func createTreeAtRandomLocation() {
        var x = Int.random(in: 1...Continent.treeCount)
        for continent in Continent.treeContinents {
            if x < continent.trees {
                let tree = createTree(on: continent)
                tree.opacity = 0
                tree.scale = SCNVector3(0, 0, 0)
                tree.appear()
                break
            }
            x -= continent.trees
        }
    }
    
    private func startBird() {
        let bird = Bird(position: SCNVector3(CGFloat.random(in: 100...900), CGFloat.random(in: 100...500), cityHeight - 5), flyHeight: birdHeight)
        bird.opacity = 0
        bird.scale = SCNVector3(0.5, 0.5, 0.5)
        tappableItemsNode.addChildNode(bird)
        bird.startFlying()
    }
    
    private func removeRandomTree() {
        if let tree = treeNodes.randomElement() {
            treeNodes.remove(tree)
            tree.fadeOutShrinkAndRemove(duration: 1)
        }
    }
    
    func handleTap(on nodes: [SCNNode]) {
        for node in nodes {
            if let trash = node as? Trash {
                pollution -= 1
                trashCollected += 1
                if trashCollected % 25 == 0 {
                    createWindTurbine(on: nil)
                }
                trash.fadeOutShrinkAndRemove(duration: 0.25)
                break
            } else if let bird = node as? Bird {
                pollution += 1
                bird.fadeOutShrinkAndRemove(duration: 0.25)
                placeTrash(skipFadeIn: false)
            } else if let windTurbine = node as? WindTurbine, !windTurbine.built {
                windTurbines += 1
                windTurbine.build()
                break
            }
        }
    }
    
    private func createWindTurbine(on continent: Continent?) {
        
        var position: CGPoint!
        repeat {
            if let continent = continent {
                position = continent.path.randomPoint(inset: 7)
            } else {
                position = CGPoint(x: CGFloat.random(in: 0...1000), y: CGFloat.random(in: 0...600))
            }
        } while !Continent.treeContinents.contains(where: {$0.path.contains(position)}) ||
            windTurbineNodes.contains(where: {$0.point.distance(to: position) < 50}) ||
            City.allCases.contains(where: {$0.path.center.distance(to: position) < 30}) ||
            treeNodes.contains(where: {$0.point.distance(to: position) < 10})
        
        let windTurbine = WindTurbine(position: SCNVector3(position.x, position.y, cityHeight))
        if continent == nil {
            tappableItemsNode.addChildNode(windTurbine)
        } else {
            worldMapNode.addChildNode(windTurbine)
            windTurbine.build()
        }
        windTurbineNodes.append(windTurbine)
        
        if game && windTurbines >= 5 && pollution < 20 - windTurbines {
            victory()
        }
    }
    
    private func handleMadagascarTree() {
        if pollution >= 100, let madagascarTree = madagascarTree {
            madagascarTree.fadeOutShrinkAndRemove(duration: 1)
            self.madagascarTree = nil
        } else if pollution < 100, madagascarTree == nil {
            madagascarTree = createTree(on: .madagascar, persistent: true)
            madagascarTree!.opacity = 0
            madagascarTree!.scale = SCNVector3(0, 0, 0)
            madagascarTree!.appear()
        }
    }
    
    private func victory() {
        if !won {
            won = true
            cityNodes.forEach {$0.launchFireworks()}
            nextFireworks = ticks + 7
            startVictoryAirplane()
        }
    }
    
    private func startVictoryAirplane() {
        
        let text = SCNText(string: "Congratulations, you saved the planet!", extrusionDepth: 1/3)
        text.materials = [SCNMaterial(color: .black)]
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(10, 2, 0.1)
        textNode.scale = SCNVector3(2.8, 2.8, 2.8)
        
        let bannerPath = UIBezierPath()
        bannerPath.move(to: .zero)
        bannerPath.addLine(to: CGPoint(x: 650, y: 0))
        bannerPath.addLine(to: CGPoint(x: 630, y: 20))
        bannerPath.addLine(to: CGPoint(x: 650, y: 40))
        bannerPath.addLine(to: CGPoint(x: 0, y: 40))
        bannerPath.close()
        
        let banner = SCNNode(geometry: SCNShape(path: bannerPath, extrusionDepth: 1, color: Continent.north.surfaceColor))
        banner.position = SCNVector3(1200, 300, -100)
        banner.rotation = SCNVector4(1, 0, 0, Float.pi)
        banner.addChildNode(textNode)
        
        let rope = SCNNode(geometry: SCNBox(width: 20, height: 1, length: 1, color: .black))
        rope.position = SCNVector3(-10, 20, 0)
        banner.addChildNode(rope)
        
        let airplane = Airplane(position: SCNVector3(50, -20, 0))
        airplane.scale = SCNVector3(3, 3, 3)
        airplane.rotation = SCNVector4(1, 0, 0, Float.pi)
        
        let intermediate = SCNNode()
        intermediate.rotation = SCNVector4(0, 0, 1, Float.pi)
        intermediate.addChildNode(airplane)
        banner.addChildNode(intermediate)
        
        worldMapNode.addChildNode(banner)
        
        banner.runAction(.sequence([.moveBy(x: -2500, y: 0, z: 0, duration: 25), .removeFromParentNode()]))
    }
    
}
