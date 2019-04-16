//#-hidden-code
import PlaygroundSupport

var greenland = 0, madagascar = 0

func addNorthAmerica() {}
func addSouthAmerica() {}
func addEuropeAndAsia() {}
func addAfrica() {}
func addAustralia() {}
func addNorthPole() {}
func addAntarctica() {}
func addGreenland() {
    greenland += 1
}
func addMadagascar() {
    madagascar += 1
}
//#-end-hidden-code
/*:
  _Hint:_ This playground is intended be be experiences in _portrait orientation_. You can also rotate your iPad to landscape orientation and drag the border between the editor and the world map to the left to see it in _full-screen mode_.
 
 
   # Introduction
 
   Press __Run My Code__. Welcome, this is planet __Earth__, our planet. As you can see, there's a lot going on. _Trees_ are growing, _birds_ fly around and _clouds_ float across the sky. You'll also notice the creations of mankind. We've built _cities_ all across the planet, _wind turbines_ to power them and use _airplanes_ and _ships_ for the delivery of goods as well as traveling.
 
  Wait, isn't something missing? Of course, __Greenland__ and __Madagascar__ are nowhere to be found. Please add them to the map using the code editor below.
*/
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, addGreenland(), addMadagascar())
func setupWorldMap() {
    addNorthAmerica()
    addSouthAmerica()
    addEuropeAndAsia()
    addAfrica()
    addAustralia()
    addNorthPole()
    addAntarctica()
    //#-editable-code
    //#-end-editable-code
}
setupWorldMap()
//#-hidden-code
var options = [String: Any]()
if greenland == 0 {
    options["hideGreenland"] = true
}
if madagascar == 0 {
    options["hideMadagascar"] = true
}
let page = PlaygroundPage.current
page.liveView = WorldViewController(options: options)

let solution = "`addGreenland()`\n\n`addMadagascar()`"
if greenland == 0 && madagascar == 0 {
    page.assessmentStatus = .fail(hints: ["It looks like Greenland and Madagascar are still missing."], solution: solution)
} else if greenland == 0 {
    page.assessmentStatus = .fail(hints: ["It looks like Greenland is still missing."], solution: solution)
} else if madagascar == 0 {
    page.assessmentStatus = .fail(hints: ["It looks like Madagascar is still missing."], solution: solution)
} else if greenland > 1 {
    page.assessmentStatus = .fail(hints: ["Greenland should only be added once."], solution: solution)
} else if madagascar > 1 {
    page.assessmentStatus = .fail(hints: ["Madagascar should only be added once."], solution: solution)
} else {
    page.assessmentStatus = .pass(message: "Great, you did it! The world map is complete now.\n\nUnfortunately, this is not the world we live in. Find out why on the [next page](@next).")
}
//#-end-hidden-code
