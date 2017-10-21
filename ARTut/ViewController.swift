//
//  ViewController.swift
//  ARTut
//
//  Created by Dwayne Langley on 10/16/17.
//  Copyright © 2017 Dwayne Langley. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBox()
        addTapGestureToSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        sceneView.scene = scene
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(with:)))
            sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(with recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            
            if let newPoint = hitTestResultsWithFeaturePoints.first {
                let translation = newPoint.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            
            return
        }
        node.removeFromParentNode()
    }
}

extension float4x4 {
    var translation : float3 {
        let calculation = self.columns.3
        return float3(calculation.x, calculation.y, calculation.z)
    }
}
