//
//  ContentView.swift
//  ARkit-1
//
//  Created by skrjs on 2022/11/29.
//

import SwiftUI
import RealityKit


struct ContentView : View {
    var body: some View {
        ZStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)
//            Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
//            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//            }
        }
    }
}

class CustomSpotLight: Entity, HasSpotLight {
    required init() {
        super.init()
        self.light = SpotLightComponent(color: .white,
                                    intensity: 250000,
                          innerAngleInDegrees: 70,
                          outerAngleInDegrees: 120,
                            attenuationRadius: 9.0)
        self.shadow = SpotLightComponent.Shadow()
        self.position.y = 5.0
        self.orientation = simd_quatf(angle: -.pi/1.5,
                                       axis: [1,0,0])
    }
}


struct ARViewContainer: UIViewRepresentable {
    let roboAnchor = try! One.loadMainScene()
    let ttgAnchor = try! One.loadTtgScene()
    let dsgAnchor = try! One.loadDsgScene()
//    let roboAnchor = try! Warehouse.loadMainScene()
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        if let tst = roboAnchor.tst {
            if let tst = tst as? Entity & HasCollision {
                tst.generateCollisionShapes(recursive: true)
                arView.installGestures(.all, for: tst)
            }
            }
            
        if let ttg = ttgAnchor.ttg {
            if let ttg = ttg as? Entity & HasCollision {
                ttg.generateCollisionShapes(recursive: true)
                arView.installGestures(.all, for: ttg)
            }
        }
        
        if let dsg = dsgAnchor.dsg {
            if let dsg = dsg as? Entity & HasCollision {
                dsg.generateCollisionShapes(recursive: true)
                arView.installGestures(.all, for: dsg)
            }
        }
        
        arView.scene.anchors.append(roboAnchor)
        
        let dLight = CustomSpotLight()
        let directLightAnchor = AnchorEntity()
        directLightAnchor.addChild(dLight)
        arView.scene.anchors.append(directLightAnchor)
        
        let skyboxName = "belfast_sunset_puresky_1k"
        let skyboxResource = try! EnvironmentResource.load(named: skyboxName)
        arView.environment.lighting.resource = skyboxResource
 
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}





#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
