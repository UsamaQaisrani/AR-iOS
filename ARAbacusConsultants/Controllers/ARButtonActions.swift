//
//  ARButtonActions.swift
//  ARAbacusConsultants
//
//  Created by Muhammad Usama on 12/15/22.
//

import Foundation
import SceneKit

extension ViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        if(touch.view == self.sceneView){
            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            
            if result.node == startButtonNode {
                print("START")
                setupHomeScene()
                focusSquare?.removeFromParentNode()
                statusView.isHidden = true
            }
        }
    }
}
