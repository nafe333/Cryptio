//
//  CircleButtonAnimation.swift
//  Crypto
//
//  Created by Nafea Elkassas on 21/03/2026.
//

import SwiftUI

struct CircleButtonAnimation: View {
    @Binding var animate: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? nil : .easeOut(duration: 1.0), value: animate)
    }
}

#Preview {
    CircleButtonAnimation(animate: .constant(false))
}
