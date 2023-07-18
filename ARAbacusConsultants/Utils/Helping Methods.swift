//
//  Helping Methods.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/9/22.
//

import Foundation
import ARKit

public func getModel(named name: String) -> SCNNode? {
    let scene = SCNScene(named: "art.scnassets/\(name).scn")
    guard let model = scene?.rootNode.childNode(withName: name, recursively: false) else { return nil }
    model.name = name
    return model
}
