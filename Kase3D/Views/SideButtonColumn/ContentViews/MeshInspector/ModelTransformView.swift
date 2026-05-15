//
//  ModelTransformView.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 05. 15..
//

import SwiftUI
import Kase3DEngine
import Kase3DCore

struct ModelTransformView: View {
    let sceneManager: SceneManager
    let title: String
    @Binding var x: String
    @Binding var y: String
    @Binding var z: String
    
    var setX: (ModelDescriptor, Float) -> Void
    var setY: (ModelDescriptor, Float) -> Void
    var setZ: (ModelDescriptor, Float) -> Void
    
    var body: some View {
        VStack {
            Text(title)
                .font(.callout)
                .fontWeight(.semibold)
            
            Form {
                VStack {
                    HStack {
                        TextField("X", text: $x, prompt: Text("X"))
                            .textFieldStyle(.roundedBorder)
                            .onSubmit {
                                for model in sceneManager.modelDescriptors where model.isSelected {
                                    switch validateInput(x) {
                                    case .success(let value):
                                        setX(model, value)
                                    case .failure(let error):
                                        ErrorManager.shared.present(error)
                                    }
                                }
                            }
                    }
                    
                    TextField("Y", text: $y, prompt: Text("Y"))
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            for model in sceneManager.modelDescriptors where model.isSelected {
                                switch validateInput(y) {
                                case .success(let value):
                                    setY(model, value)
                                case .failure(let error):
                                    ErrorManager.shared.present(error)
                                }
                            }
                        }
                    
                    TextField("Z", text: $z, prompt: Text("Z"))
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            for model in sceneManager.modelDescriptors where model.isSelected {
                                switch validateInput(z) {
                                case .success(let value):
                                    setZ(model, value)
                                    
                                case .failure(let error):
                                    ErrorManager.shared.present(error)
                                }
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func validateInput(_ input: String) -> Result<Float, ModelError> { // TODO: Create parser for handling - and + inputs
        if let floatValue = Float(input) {
            return .success(floatValue)
        }
        
        return .failure(.invalidDimension)
    }
}
