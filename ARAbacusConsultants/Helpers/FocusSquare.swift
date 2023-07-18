//
//  FocusSquare.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/13/22.
//

import Foundation
import SceneKit

class FocusSquare: SCNNode {
    override init() {
        super.init()
        let plane = SCNPlane(width: 0.1, height: 0.1)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "target")
        plane.firstMaterial?.isDoubleSided = true
        geometry = plane
        eulerAngles.x = GLKMathDegreesToRadians(-90)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
