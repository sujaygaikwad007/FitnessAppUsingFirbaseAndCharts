import SwiftUI

enum SideMenuRowType: Int, CaseIterable {
    case home = 0
    case favorite
    case chat
    case profile
    case signOut

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .favorite:
            return "Favorite"
        case .chat:
            return "Chat"
        case .profile:
            return "Profile"
        case .signOut:
            return "Sign out"
        }
    }

    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .favorite:
            return "heart"
        case .chat:
            return "mail"
        case .profile:
            return "person"
        case .signOut:
            return "arrow.right.square"
        }
    }
}

struct SideMenuView: View {
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @Binding var isSignOut: Bool
    @State var Fname = UserDefaults.standard.string(forKey: "Fname") ?? ""
    @State var Lname = UserDefaults.standard.string(forKey: "Lname") ?? ""
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 270)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)

                    VStack(alignment: .leading, spacing: 0) {
                        ProfileImageView()
                            .frame(height: 140)
                            .padding(.bottom, 30)

                        ForEach(SideMenuRowType.allCases, id: \.self) { row in
                            if row == .signOut {
                                RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                                    selectedSideMenuTab = row.rawValue
                                    isSignOut = false
                                    isSignOut.toggle()
                                    UserDefaults.standard.removeObject(forKey: "accessToken")
                                    UserDefaults.standard.removeObject(forKey: "Fname")
                                    UserDefaults.standard.removeObject(forKey: "Lname")
                                    presentSideMenu.toggle()
                                    let token =  UserDefaults.standard.string(forKey: "accessToken")
                                    print("Userdefaulttokenin---\(String(describing: token))")
                                }
                            } else {
                                RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                                    selectedSideMenuTab = row.rawValue
                                    presentSideMenu.toggle()
                                }
                            }
                        }

                        Spacer()
                    }
                    .padding(.top, 100)
                    .frame(width: 270)
                    .background(Color.primaryBG)
                }
            }
            .background(Color.clear)
            .ignoresSafeArea()
           
        }
    }

    func ProfileImageView() -> some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.PrimaryColor, lineWidth: 5)
                    )
                    .cornerRadius(50)
                Spacer()
            }
            VStack(spacing: 10) {
                Text("\(Fname)")
                    .font(.Montserrat_Bold16px)
                    .foregroundColor(.primaryTextColor)

                Text("iOS Developer")
                    .font(.Montserrat_Medium14px)
                    .foregroundColor(.primaryTextColor)
            }
            .padding(.top, 10)
        }
    }

    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (() -> ())) -> some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Image(systemName: imageName)
                        .renderingMode(.template)
                        .foregroundColor(isSelected ? .black : .gray)
                        .frame(width: 30, height: 30)

                    Text(title)
                        .font(.Montserrat_Regular16px)
                        .foregroundColor(isSelected ? .black : .white)
                    Spacer()
                }
                .padding(.leading, 5)
            }
        }
        .frame(height: 50)
        .background(
            LinearGradient(colors: [isSelected ? .PrimaryColor : .clear, .clear], startPoint: .leading, endPoint: .trailing)
        )
    }
}
