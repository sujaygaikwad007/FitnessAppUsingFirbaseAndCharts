import SwiftUI
struct TopBar:View {
    var onBellTapped: () -> Void
    var onMenuTapped: () -> Void
    var body: some View {
        HStack{
            Text("Dashboard")
                .font(.Montserrat_Bold30px)
                .foregroundColor(Color.white)
                .padding(.leading,20)
            Spacer()
            
            Button(action: {
                onBellTapped()
            }, label: {
                Image(systemName: "bell.badge")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30,height: 30)
                    .foregroundColor(.white)
            })
            
            Button(action: {
                onMenuTapped()
            }, label: {
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30,height: 35)
                    .foregroundColor(.white)
            })
                .padding(.trailing)
                .padding(.leading,10)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .frame(height: 80)
        .background(Color.primaryBG)
        
    }
}
