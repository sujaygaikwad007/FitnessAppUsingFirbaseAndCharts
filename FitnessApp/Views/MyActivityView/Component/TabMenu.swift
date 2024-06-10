import SwiftUI

struct TabMenu: View {
    var body: some View {
        HStack {
            Button(action: {
                // Action for watch button
            }) {
                Image(systemName: "applewatch")
                    .padding()
                    .background(Circle().fill(Color.white))
                    .shadow(radius: 3)
            }

            Spacer()

            Button(action: {
                // Action for plus button
            }) {
                Image(systemName: "plus")
                    .padding()
                    .background(Circle().fill(Color.white))
                    .shadow(radius: 3)
            }

            Spacer()

            Button(action: {
                // Action for figure.walk button
            }) {
                Image(systemName: "figure.walk")
                    .padding()
                    .background(Circle().fill(Color.white))
                    .shadow(radius: 3)
            }
        }
        .padding(.horizontal,20)
        .frame(maxWidth: .infinity) // Ensures it fits the screen width
       // .background(Color.gray.opacity(0.2)) // Optional: background color to see the frame
    }
}

struct TabMenu_Previews: PreviewProvider {
    static var previews: some View {
        TabMenu()
            .previewLayout(.sizeThatFits) // Ensures it fits nicely in preview
    }
}


