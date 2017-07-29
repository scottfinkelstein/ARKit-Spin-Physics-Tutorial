//
//  ViewController.swift
//  TorqueSpin
//
//  Created by Scott Finkelstein on 7/29/17.
//  Copyright © 2017 Scott Finkelstein. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        let marsNode=SCNNode(geometry: SCNSphere(radius: 0.1))
        
        marsNode.geometry?.materials.first?.diffuse.contents = UIImage(named: "mars_material")
        
        marsNode.position = SCNVector3(0, 0, -0.5)
        marsNode.name = "mars"
        
        marsNode.physicsBody=SCNPhysicsBody(type: .dynamic, shape: nil)
        marsNode.physicsBody?.isAffectedByGravity = false
        marsNode.physicsBody?.mass = 200
        
        
        scene.rootNode.addChildNode(marsNode)
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Set up a pan gesture recognizer and add to the sceneView.
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(didPan))
        sceneView.addGestureRecognizer(pan)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
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
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
