//
//  BottomAlertModifier.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 08.10.2024.
//

import Foundation
import SwiftUI

struct BottomAlertModifier: ViewModifier {
    @Binding var isVisible: Bool
    var message: String

    func body(content: Content) -> some View {
        ZStack {
            content

            if isVisible {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: isVisible)
                }
            }
        }
        .onChange(of: isVisible) {
            if isVisible {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
        }
    }
}

extension View {
    func bottomAlert(isVisible: Binding<Bool>, message: String) -> some View {
        self.modifier(BottomAlertModifier(isVisible: isVisible, message: message))
    }
}
