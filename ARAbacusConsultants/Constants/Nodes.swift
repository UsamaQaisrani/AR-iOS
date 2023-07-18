//
//  Nodes.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/13/22.
//

import Foundation
import SceneKit

class Nodes {
    static let shared = Nodes()
    
    //FIXED NODES
    var startButtonNode = Model(shouldChangeEulerAngle: true,
                                shouldPlaceInCenter: true,
                                shouldEnableGimbalLock: true,
                                eulerAngle: EulerAngle(axis: .X, byAngle: .pi / 2),
                                modelName: "StartButton",
                                position: SCNVector3(0, 0, 0.04))
}
