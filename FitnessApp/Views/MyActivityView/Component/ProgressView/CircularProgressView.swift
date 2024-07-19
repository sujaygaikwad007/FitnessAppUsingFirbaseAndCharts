import SwiftUI

struct CircularProgressView: View {
    var progress: Double
    var unit: String
    var value: String

    @State private var animatedProgress: Double = 0.0 // Control variable for animation

    private let circleSize: CGFloat = 100

    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                    .frame(width: circleSize, height: circleSize)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(animatedProgress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.PrimaryColor) 
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5))
                    .onAppear {
                        animatedProgress = progress
                    }
                    .frame(width: circleSize, height: circleSize)

                VStack(spacing: 0) {
                    Text(self.value)
                        .font(.Montserrat_SemiBold16px)
                    Text(self.unit)
                        .font(.Montserrat_Regular10px)
                        .foregroundColor(Color.PrimaryColor)
                }
                .font(.subheadline)
                .foregroundColor(.primaryTextColor)
            }
            .padding(5)
        }
    }
}
