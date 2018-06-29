//
//  ViewController.swift
//  GiftCards
//
//  Created by Mohammed Ibrahim on 2018-06-26.
//  Copyright © 2018 Mohammed Ibrahim. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let balanceView = Balance()
    
    let cineplexBalanceView = Balance()
    let optimumBalanceView = Balance()
    
    var balanceHeight: CGFloat = 0.0
    var balanceWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        balanceHeight = balanceView.frame.height
        balanceWidth = balanceView.frame.width
        
        optimumBalanceView.setImageTo(.Optimum)
        cineplexBalanceView.setImageTo(.Cineplex)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: Bundle.main) else {
            showAlert(message: "Failed to load AR Reference Images for your app.")
            return
        }
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 2

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - Alert function
    func showAlert(title: String = "Alert", message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Anchor Method
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let width: CGFloat = 0.05
            let height: CGFloat = width * (balanceHeight/balanceWidth)
            
            let plane = SCNPlane(width: width, height: height)
            
            if imageAnchor.referenceImage.name == "optimum" {
                DispatchQueue.main.async {
                    plane.firstMaterial?.diffuse.contents = self.optimumBalanceView.view
                }
            } else {
                DispatchQueue.main.async {
                    plane.firstMaterial?.diffuse.contents = self.cineplexBalanceView.view
                }
            }
            
            DispatchQueue.main.async {
                self.balanceView.view.frame.size.width = 100
            }
            
            plane.width = plane.height
            
            plane.cornerRadius = width/18
            
            let initialXPosition = -(imageAnchor.referenceImage.physicalSize.width / 2) + (plane.width / 2)
            
            let finalXPosition = -(width / 2) + 0.002
            let finalZPosition = (imageAnchor.referenceImage.physicalSize.height / 2) + (height / 2) + 0.002
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            
            planeNode.position.x = Float(initialXPosition)
            planeNode.position.z = Float(-finalZPosition)
            
            // Create animation to expand balance view plane
            let widthAnimation = CABasicAnimation(keyPath: "width")
            widthAnimation.fromValue = plane.height
            widthAnimation.toValue = width
            widthAnimation.autoreverses = false
            widthAnimation.repeatCount = 0
            widthAnimation.fillMode = .forwards
            widthAnimation.isRemovedOnCompletion = false
            widthAnimation.duration = 0.3
            
            let positionAnimation = CABasicAnimation(keyPath: "position.x")
            positionAnimation.fromValue = Float(initialXPosition)
            positionAnimation.toValue = Float(finalXPosition)
            positionAnimation.autoreverses = false
            positionAnimation.repeatCount = 0
            positionAnimation.fillMode = .forwards
            positionAnimation.isRemovedOnCompletion = false
            positionAnimation.duration = 0.3
            
            if imageAnchor.referenceImage.name == "optimum" {
                DispatchQueue.main.async {
                     self.optimumBalanceView.changeToOriginalSize()
                }
            } else {
                DispatchQueue.main.async {
                     self.cineplexBalanceView.changeToOriginalSize()
                }
            }
            
            // Add animation to the plane
            plane.addAnimation(widthAnimation, forKey: nil)
            planeNode.addAnimation(positionAnimation, forKey: nil)
            
            
            node.addChildNode(planeNode)
            
        }
        
        return node
        
    }
}
