//
//  HomeScene.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/15/22.
//

import Foundation
import SceneKit

extension ViewController {
    
    func setupHomeScene() {
        placeBuilding()
        addAlKabirLogo()
        createListPlaceHolder()
        populateListNode()
    }
    
    func placeBuilding() {
        guard let buildingModel = getModel(named: "Building") else { return }
        buildingNode = buildingModel
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        guard let worldTransform = hitTest.first?.worldTransform else { return }
        buildingNode.position = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
        
        guard let camera = sceneView.session.currentFrame?.camera else { return }
        let transform = SCNMatrix4.init(worldTransform)
        let vector = SCNVector3Make(transform.m41, transform.m42, transform.m43)
        
        buildingNode.position = vector
        buildingNode.eulerAngles.y = camera.eulerAngles.y
        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 0.0)
        
        sceneView.scene.rootNode.addChildNode(buildingNode)
        buildingNode.runAction(rotateAction)
    }
    
    func addAlKabirLogo() {
        guard let camera = sceneView.session.currentFrame?.camera else { return }
        let node = getModel(named: "al_kabir2")
        let position = buildingNode.convertPosition(SCNVector3(0,3.5,1.02), to: node?.parent)
        node!.eulerAngles.y = camera.eulerAngles.y
        node?.position = position
        self.sceneView.scene.rootNode.addChildNode(node!)
    }
    
    func createListPlaceHolder() {
        let shape = SCNBox(width: Constants.listWidth * 2, height: Constants.listHeight * 1.7, length: 0.007, chamferRadius: 0.002)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.paperColor
        material.lightingModel = .constant
        shape.materials = [material]
        
        let node = SCNNode(geometry: shape)
        guard let camera = sceneView.session.currentFrame?.camera else { return }
        node.eulerAngles.y = camera.eulerAngles.y
        let position = buildingNode.convertPosition(SCNVector3(3,1.6,0), to: node.parent)
        node.position = position
        
        listPlaceHolderNode = node
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func addButtonPlaceHolder(position: Double, color: UIColor) -> SCNNode {
        let shape = SCNBox(width: Constants.buttonWidth, height: Constants.buttonHeight, length: 0.003, chamferRadius: 1)
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.lightingModel = .constant
        shape.materials = [material]
        let node = SCNNode(geometry: shape)
        node.position = SCNVector3(0, position, 0.005)
        listPlaceHolderNode.addChildNode(node)
        return node
    }
    
    //Adding Text to  AR Buttons
    func addTextToButtonAt(position: Double, with name: String, for button: SCNNode, color: UIColor = UIColor.white) {
        let node = SCNNode.text(withString: name, color: color, fontSize: Constants.descriptionFontSize)
        node.position = SCNVector3(0, -0.01, 0.002)
        button.addChildNode(node)
    }
    
    func populateListNode() {
        
        let shape = SCNBox(width: Constants.buttonWidth, height: Constants.buttonHeight, length: 0.003, chamferRadius: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.abacusGreenDark
        material.lightingModel = .constant
        shape.materials = [material]
        let node = SCNNode(geometry: shape)
        
//        guard let camera = sceneView.session.currentFrame?.camera else { return }
//        node.eulerAngles.y = camera.eulerAngles.y
        
//        let position = listPlaceHolderNode.convertPosition(SCNVector3(0,1,1), to: node.parent)
        let position = SCNVector3(0, 0, 0.005)
        node.position = position
        listPlaceHolderNode.addChildNode(node)
    }
    
//    func populateListNode() {
//        var position = Constants.listHeight / 3
//
//        for item in Constants.townsList {
//            let button = addButtonPlaceHolder(position: position, color: .al_kabir_green)
//            addTextToButtonAt(position: position, with: item, for: button)
//            button.name = item
//            position = position - (Constants.buttonHeight / 1.2) - Constants.spacing
//            let model = VirtualObject(node: button, name: item)
//            townNodes.append(model)
//        }
//    }
}
