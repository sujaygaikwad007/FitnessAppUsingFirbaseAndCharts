import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var manager : HealthManager
    
    @State var loggedUserName =  "User"
    
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators:false) {
                NavTitleView(navTitle: "My Activity", imageName: "list.star")
                
                Text("Welcome \(loggedUserName)")
                    .font(.caption)
                    .foregroundColor(Color.theme.accent)
                
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 2), spacing: 20) {
                    
                    ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }),
                            id: \.key) { item in
                        StatCard(activity: item.value)
                    }
                }
                .padding(.horizontal)
                
               
            }
            .navigationBarHidden(true)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let healthManager = HealthManager()
        HomeView()
            .environmentObject(healthManager)
    }
}
