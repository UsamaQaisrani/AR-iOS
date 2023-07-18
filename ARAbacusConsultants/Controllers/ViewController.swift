//
//  ViewController.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/8/22.
//

import UIKit
import SceneKit
import ARKit

enum Status: String {
    case finding = "Finding surface"
    case found = "Surface found"
    case notFound = "No surface found"
    case placed = "Experience started"
}

class ViewController: BaseViewController {
    
    //MARK: Class Properties
    var screenCenter: CGPoint!
    var focusSquare: FocusSquare?
    let coachingOverlay = ARCoachingOverlayView()
    var wTransform: simd_float4x4!
    var status: Status = .finding {
        didSet {
            statusLabel.text = status.rawValue
        }
    }
    
    ///SCNNodes
    var startButtonNode: SCNNode = SCNNode()
    var buildingNode: SCNNode = SCNNode()
    var listPlaceHolderNode: SCNNode = SCNNode()
    
    //MARK: IBOutlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var restartExperienceButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusBar: UIView!
    
    //MARK: Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }    
}


//MARK: Class Methods
extension ViewController {
    fileprivate func initialSetup() {
        setupSceneView()
        setupCoachingOverlay()
        screenCenter = view.center
        
        statusView.layer.cornerRadius = 5
        statusView.layer.opacity = 0.8
    }
    
    func setupSceneView() {
        sceneView.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    func updateFocusSquare() {
        guard let localFocusSquare = focusSquare else { return }
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        
        if let hitTestResult = hitTest.first {
            status = .found
            focusSquare?.isHidden = false
        }
        else {
            status = .finding
            focusSquare?.isHidden = true
        }
    }    
}

//MARK: IBActions
extension ViewController {
    @IBAction func restartExperienceButtonAction(_ sender: Any) {
        buildingNode.removeFromParentNode()
        sceneView.scene.rootNode.addChildNode(focusSquare!)
        status = .finding
        statusView.isHidden = false
    }
}

//MARK: SceneView Delegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let localFocusSquare = focusSquare else { return  }
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlane)
        let hitTestResult = hitTest.first
        guard let worldTransform = hitTestResult?.worldTransform else { return }
        let worldTransformColumn3 = worldTransform.columns.3
        wTransform = worldTransform
        localFocusSquare.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        //Adding Focus Square To Scene
        guard focusSquare == nil else { return }
        let localFocusSquare = FocusSquare()
        self.sceneView.scene.rootNode.addChildNode(localFocusSquare)
        self.focusSquare = localFocusSquare
        
        //Adding Start Button On Top Of Focus Square
        startButtonNode = focusSquare!.place(node: Nodes.shared.startButtonNode, in: sceneView)
    }
}

//MARK: ARCoachingOverlayViewDelegate
extension ViewController: ARCoachingOverlayViewDelegate {
    func setupCoachingOverlay() {
        // Set up coaching view
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        setActivatesAutomatically()
        setGoal()
    }
    
    func setActivatesAutomatically() {
        coachingOverlay.activatesAutomatically = true
    }
    
    func setGoal() {
        coachingOverlay.goal = .horizontalPlane
    }
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        DispatchQueue.main.async {
            self.focusSquare?.isHidden = true
            self.status = .notFound
        }
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        DispatchQueue.main.async {
            self.focusSquare?.isHidden = false
            self.status = .finding
        }
    }
}
