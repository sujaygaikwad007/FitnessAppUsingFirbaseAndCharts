import SwiftUI

struct CircularProgressView: View {
    var progress: Double
    var unit: String
    var value: Any
    
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
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.theme.caloriesProgress)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)
                    .frame(width: circleSize, height: circleSize)
                
                VStack(spacing:0) {
                    Text("\(stringValue())")
                        .fontWeight(.bold)
                    Text("\(self.unit)")
                        .fontWeight(.bold)
                }
                .font(.subheadline)
                .foregroundColor(Color.white)
            }
            .padding(5)
        }
    }
    
    private func stringValue() -> String {
        if let intValue = value as? Int {
            return "\(intValue)"
        } else if let doubleValue = value as? Double {
            return "\(doubleValue)"
        } else {
            return ""
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.2, unit: "%", value: 20)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
