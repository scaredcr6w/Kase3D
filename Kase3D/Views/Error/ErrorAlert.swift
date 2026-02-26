//
//  ErrorAlert.swift
//  Kase3D
//
//  Created by Anda Levente on 2026. 02. 26..
//

import SwiftUI

struct ErrorAlert: View {
    let message: String
    let retry: (() -> Void)?
    let dismiss: () -> Void
    
    var body: some View {
        VStack (spacing: 16) {
            Text(message)
                .font(.headline)
            HStack {
                Button("OK", action: dismiss)
                
                if let retry {
                    Button(String(localized: "Retry"), action: retry)
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 20)
    }
}

#Preview {
    ErrorAlert(message: "Halloo", retry: { }, dismiss: { })
}
