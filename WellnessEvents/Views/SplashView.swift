import SwiftUI

struct SplashView: View {
    @State private var opacity: Double = 0
    @State private var scale: Double = 0.8

    var body: some View {
        ZStack {
            Color.appBeige.ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.appMint)
                        .frame(width: 160, height: 160)
                        .shadow(color: Color.appMint.opacity(0.45), radius: 24, x: 0, y: 8)

                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                }

                Text("WellnessEvents")
                    .font(.system(.title2, design: .serif))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appBlue)
            }
            .opacity(opacity)
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                opacity = 1
                scale = 1
            }
        }
    }
}

#Preview {
    SplashView()
}
