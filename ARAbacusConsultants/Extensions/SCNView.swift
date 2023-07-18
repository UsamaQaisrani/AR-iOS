//
//  SCNView.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/19/22.
//

import UIKit
import SceneKit

extension SCNView {
    func place(node: Model, in sceneView: SCNView = SCNView()) -> SCNNode {
        let newNode = getModel(named: node.modelName ?? "MODEL NAME")
        
        newNode?.position = node.position!
        
        if node.shouldChangeEulerAngle! {
            switch node.eulerAngle?.axis {
            case .X:
                newNode?.eulerAngles.x = (node.eulerAngle?.byAngle)!
                break
            case .Y:
                newNode?.eulerAngles.y = (node.eulerAngle?.byAngle)!
                break
            case .Z:
                newNode?.eulerAngles.z = (node.eulerAngle?.byAngle)!
                break
            case .none:
                print("Should Not change euler axis")
            }
        }
        
        if node.shouldEnableGimbalLock! {
            let constraint = SCNLookAtConstraint(target:sceneView.pointOfView)
            constraint.isGimbalLockEnabled = true
            newNode?.constraints = [constraint]
        }
                
        if node.imageName != "" {
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: node.imageName!)
            newNode?.geometry?.materials = [material]
        }
        
        self.scene?.rootNode.addChildNode(newNode!)
        
        if node.shouldRunAction! {
            switch node.action?.action {
            case .fadeIn(let time):
                let action = SCNAction.fadeIn(duration: time)
                newNode?.runAction(action)
                break
            case .fadeOut(let time):
                let action = SCNAction.fadeOut(duration: time)
                newNode?.runAction(action)
                break
            case .move(let position, let time):
                let action = SCNAction.move(to: position, duration: time)
                newNode?.runAction(action)
                break
            case .rotate(let x, let y, let z, let time):
                let action = SCNAction.rotateBy(x: x, y: y, z: z, duration: time)
                newNode!.runAction(action)
                break
            case .scale(let multiplier, let time):
                let action = SCNAction.scale(to: multiplier, duration: time)
                newNode?.runAction(action)
                break
            case .none:
                print("No action needs to be performed")
                break
            }
        }
        return newNode ?? SCNNode()
    }
}
