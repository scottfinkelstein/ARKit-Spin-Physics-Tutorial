#  ARKit Torque Physics Tutorial

A tutorial for demoing how to use simple physics to spin an object on it's axis. Here we have the planet Mars placed 0.5 meters in front of the camera. Here is what the final product will look like:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=HKnYzqgH-yM" target="_blank"><img src="http://img.youtube.com/vi/HKnYzqgH-yM/0.jpg" alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

```swift
let marsNode=SCNNode(geometry: SCNSphere(radius: 0.1))

marsNode.geometry?.materials.first?.diffuse.contents = UIImage(named: "mars_material")

marsNode.position = SCNVector3(0, 0, -0.5)
marsNode.name = "mars"
```

We then add the physics body. Play around with the mass value to determine how much force is needed to spin the object.

```swift
marsNode.physicsBody=SCNPhysicsBody(type: .dynamic, shape: nil)
marsNode.physicsBody?.isAffectedByGravity = false
marsNode.physicsBody?.mass = 200
```
Finally, in the Pan Gesture Recognizer method, we use a simple calculation based on the the velocity of the pan gesture to determine the amount of torque we want to apply to the object

```swift
@objc func didPan(_ sender: UIPanGestureRecognizer) {

    let tapPoint=sender.location(in: sceneView)
    guard let hit=sceneView.hitTest(tapPoint, options: nil).first else { return }
    let node = hit.node

    if node.name == "mars" {
        let velocity = sender.velocity(in: sceneView)
        let impulseFactor = velocity.x / 10000.0
        print("Factor: ", impulseFactor)

        node.physicsBody?.applyTorque(SCNVector4Make(0, 1, 0, Float(impulseFactor)), asImpulse: true)
    }
}
```
