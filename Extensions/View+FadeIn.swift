import SwiftUI

struct FadeInModifier: ViewModifier {
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 15)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    appeared = true
                }
            }
    }
}

extension View {
    func fadeInOnAppear() -> some View {
        modifier(FadeInModifier())
    }
}
