import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
            ScrollView {
                NavTitleView(navTitle: "My Activity", imageName: "list.star")
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 2), spacing: 20) {
                    StatCard(icon: "flame", title: .calories, value: 800, unit: "Kcal")
                    StatCard(icon: "moon", title: .sleep, value: 85, unit: "Score")
                    StatCard(icon: "drop", title: .water, value: 8.5, unit: "Liters")
                    StatCard(icon: "figure.walk", title: .walk, value: 4000, unit: "Steps")
                    StatCard(icon: "stopwatch", title: .training, value: 50, unit: " Mins")
                    StatCard(icon: "heart", title: .heart, value: 85, unit: " Score")
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
