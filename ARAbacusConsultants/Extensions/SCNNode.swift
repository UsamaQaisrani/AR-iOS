//
//  SCNNode.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/13/22.
//

import SceneKit

extension SCNNode {
    func rotateAntiClockwise() {
        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 1.0)
//        let position = SCNVector3(x: self.position.x + 0.05, y: self.position.y, z: self.position.z)
//        let moveAction = SCNAction.move(to: position, duration: 1)
//        self.runAction(moveAction)
        self.runAction(rotateAction)
    }
    
    func rotateClockwise() {
        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(-Float.pi), z: 0, duration: 1.0)
//        let position = SCNVector3(x: self.position.x - 0.05, y: self.position.y, z: self.position.z)
//        let moveAction = SCNAction.move(to: position, duration: 1)
//        self.runAction(moveAction)
        self.runAction(rotateAction)
    }
    
    static func text(
        withString string: String,
        color: UIColor,
        fontSize: Float,
        shouldLookAtNode lookAtNode: SCNNode? = nil,
        addAboveExistingNode existingNode: SCNNode? = nil) -> SCNNode {
            
            let text = SCNText(string: string, extrusionDepth: 0.1)
            text.font = UIFont.boldSystemFont(ofSize: 1.0)
            text.flatness = 0.01
            text.firstMaterial?.diffuse.contents = color
            
            let textNode = SCNNode(geometry: text)
            textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
            
            var pivotCorrection = SCNMatrix4Identity
            
            if let lookAtNode = lookAtNode {
                let constraint = SCNLookAtConstraint(target: lookAtNode)
                constraint.isGimbalLockEnabled = true
                textNode.constraints = [constraint]
                
                // Rotate the text 180 degrees around the Y axis so that it faces the lookAtNode
                pivotCorrection = SCNMatrix4Rotate(pivotCorrection, .pi, 0, 1, 0)
            }
            
            // Change the text node's pivot to be centred rather than bototm left
            let (min, max) = text.boundingBox
            pivotCorrection = SCNMatrix4Translate(pivotCorrection, (max.x - min.x) / 2, 0, 0)
            
            // Apply the pivot correction
            textNode.pivot = pivotCorrection
            
            if let existingNode = existingNode {
                // Add a 0.3m Y axis offset so the text floats above the node
                textNode.position = SCNVector3(0, 0.1, 0)
                
                //
                existingNode.addChildNode(textNode)
            }
            
            return textNode
        }
    
    static func paragraph(
        withString string: String,
        color: UIColor,
        fontSize: Float,
        shouldLookAtNode lookAtNode: SCNNode? = nil,
        addAboveExistingNode existingNode: SCNNode? = nil) -> SCNNode {
            
            let text = SCNText(string: string, extrusionDepth: 0.1)
            text.font = UIFont.boldSystemFont(ofSize: 1.0)
            text.flatness = 0.01
            text.firstMaterial?.diffuse.contents = color
            
            let textNode = SCNNode(geometry: text)
            textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
            
            var pivotCorrection = SCNMatrix4Identity
            
            if let lookAtNode = lookAtNode {
                let constraint = SCNLookAtConstraint(target: lookAtNode)
                constraint.isGimbalLockEnabled = true
                textNode.constraints = [constraint]
                
                // Rotate the text 180 degrees around the Y axis so that it faces the lookAtNode
                pivotCorrection = SCNMatrix4Rotate(pivotCorrection, .pi, 0, 1, 0)
            }
            
            // Change the text node's pivot to be centred rather than bototm left
            let (min, max) = text.boundingBox
            pivotCorrection = SCNMatrix4Translate(pivotCorrection, (max.x - min.x) / 2, 0, 0)
            
            // Apply the pivot correction
            textNode.pivot = pivotCorrection
            
            if let existingNode = existingNode {
                // Add a 0.3m Y axis offset so the text floats above the node
                textNode.position = SCNVector3(0, 0.1, 0)
                
                //
                existingNode.addChildNode(textNode)
            }
            
            return textNode
        }
}


extension SCNNode {
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
        
        self.addChildNode(newNode!)
        
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
