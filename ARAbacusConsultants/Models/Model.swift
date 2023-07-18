//
//  Model.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/13/22.
//

import Foundation
import SceneKit

class Model {
    var eulerAngle: EulerAngle?
    var shouldChangeEulerAngle: Bool?
    var modelName: String?
    var position: SCNVector3?
    var shouldEnableGimbalLock: Bool?
    var imageName: String?
    var shouldPlaceInCenter: Bool?
    var shouldRunAction: Bool?
    var action: CustomAction?
    
    init(shouldChangeEulerAngle: Bool = false,
         shouldPlaceInCenter: Bool = false,
         shouldRunAction: Bool = false,
         shouldEnableGimbalLock: Bool = false,
         eulerAngle: EulerAngle = EulerAngle(),
         modelName: String,
         position: SCNVector3,
         imageName: String = "",
         action: CustomAction = CustomAction()) {
        
        self.shouldChangeEulerAngle = shouldChangeEulerAngle
        self.eulerAngle = eulerAngle
        self.modelName = modelName
        self.position = position
        self.shouldEnableGimbalLock = shouldEnableGimbalLock
        self.imageName = imageName
        self.shouldPlaceInCenter = shouldPlaceInCenter
        self.shouldRunAction = shouldRunAction
        self.action = action
    }
    
    init() {  }
}

class EulerAngle {
    var axis: EulerAngleState?
    var byAngle: Float?
    
    init(axis: EulerAngleState, byAngle: Float) {
        self.axis = axis
        self.byAngle = byAngle
    }
    
    init() {  }
}

class CustomAction {
    var action: ActionState?
    
    init(action: ActionState) {
        self.action = action
    }
    
    init() {  }
}

enum EulerAngleState {
    case X
    case Y
    case Z
}

enum ActionState {
    case rotate(x: CGFloat, y: CGFloat, z: CGFloat, time: Double)
    case scale(by: CGFloat, time: Double)
    case move(to: SCNVector3, time: Double)
    case fadeIn(time: Double)
    case fadeOut(time: Double)
}
