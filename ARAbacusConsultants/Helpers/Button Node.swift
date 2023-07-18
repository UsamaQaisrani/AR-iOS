//
//  Button Node.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/13/22.
//

import Foundation
import SceneKit

func getButtonPlaceHolderNode() -> SCNNode {
    let shape = SCNBox(width: Constants.buttonWidth / 2, height: Constants.buttonHeight, length: 0.01, chamferRadius: 1)
    let node = SCNNode(geometry: shape)
    let material = SCNMaterial()
    material.lightingModel = .constant
    node.geometry?.materials = [material]
    
    return node
}

//Adding Text to  AR Buttons
func addTextToButtonAt(position: Double, with name: String, for button: SCNNode, color: UIColor = UIColor.black) {
    let node = SCNNode.text(withString: name, color: color, fontSize: Constants.descriptionFontSize)
    node.position = SCNVector3(0, 0, 0.01)
//    let rotateAction = SCNAction.rotateBy(x: CGFloat(.pi), y: 0, z: 0, duration: 0.0)
    button.addChildNode(node)
//    node.runAction(rotateAction)
}
