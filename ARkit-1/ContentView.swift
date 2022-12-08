//
//  ContentView.swift
//  ARkit-1
//
//  Created by skrjs on 2022/11/29.
//

import SwiftUI
import RealityKit


class Lighting: Entity, HasDirectionalLight {
    
    required init() {
        super.init()
        
        self.light = DirectionalLightComponent(color: .white,
                                           intensity: 4000,
                                    isRealWorldProxy: true)
    }
}

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

var roboAnchor:One.MainScene!
struct ARViewContainer: UIViewRepresentable {
   
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        roboAnchor = try! One.loadMainScene()
//        roboAnchor.generateCollisionShapes(recursive: true)
        let dLight = Lighting()
        dLight.orientation = simd_quatf(angle: .pi/8,
                                                axis: [0, 1, 0])
        roboAnchor.addChild(dLight)
        if let dsg = roboAnchor.dsg {
            if let dsg = dsg as? Entity & HasCollision {
                dsg.generateCollisionShapes(recursive: true)
                arView.installGestures(.all, for: dsg)
            }
        }
        
        arView.scene.anchors.append(roboAnchor)
        
        
        
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
