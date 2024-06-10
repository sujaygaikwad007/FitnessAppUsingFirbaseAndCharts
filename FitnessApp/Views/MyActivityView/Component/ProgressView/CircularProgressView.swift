import SwiftUI

struct CircularProgressView: View {
    var progress: Double
    var unit: String
    var value: String
    var tintColor: Color

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
                    .foregroundColor(Color.theme.caloriesProgress) 
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5))
                    .onAppear {
                        animatedProgress = progress
                    }
                    .frame(width: circleSize, height: circleSize)

                VStack(spacing: 0) {
                    Text(self.value)
                        .fontWeight(.bold)
                    Text(self.unit)
                        .fontWeight(.bold)
                }
                .font(.subheadline)
                .foregroundColor(tintColor)
            }
            .padding(5)
        }
    }
}
