//
//  SceneLighting.swift
//  Kase3DEngine
//
//  Created by Anda Levente on 2026. 01. 25..
//

import Foundation

struct SceneLighting {
    let sunLight: Light = {
        var light = Light()
        light.position = [1, 2, 2]
        light.color = [1, 1, 1]
        light.specularColor = [0.6, 0.6, 0.6]
        light.attenuation = [1, 0, 0]
        light.type = Sunlight
        return light
    }()
    
    var lights: [Light] = []
    
    init() {
        lights.append(sunLight)
    }
}
