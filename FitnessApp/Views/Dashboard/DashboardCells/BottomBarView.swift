
import SwiftUI

struct BottomTabBar: View {
    @Binding var selection: Int
    var body: some View {
        VStack{
            HStack(alignment:.center) {
                Spacer()
                
                Button(action: {
                    withAnimation{
                        self.selection = 4
                    }
                }, label: {
                    VStack{
                        Image("squares")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20, alignment: .center)
                            .padding()
                            .foregroundColor(selection == 4 ? Color.black: Color.gray)
                            .background(selection == 4 ? Color.PrimaryColor: Color.clear)
                            .clipShape(Circle())
                            .padding(.top,selection == 4 ? -30:0)
                    }
                })
                Spacer()
                
                // Second Tab Button
                Button(action: {
                    withAnimation{
                        self.selection = 5
                    }
                }, label: {
                    Image("signal")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding()
                        .foregroundColor(selection == 5 ? Color.black: Color.gray)
                        .background(selection == 5 ? Color.PrimaryColor: Color.clear)
                        .clipShape(Circle())
                        .padding(.top,selection == 5 ? -30:0)
                })
                
                Spacer()
                
                // Third Tab Button
                Button(action: {
                    withAnimation{
                        self.selection = 2
                    }
                }, label: {
                    Image(systemName:"plus")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding()
                        .foregroundColor(selection == 2 ? Color.black: Color.gray)
                        .background(selection == 2 ? Color.PrimaryColor: Color.clear)
                        .clipShape(Circle())
                        .padding(.top,selection == 2 ? -30:0)
                })
                Spacer()
                
                //fourth Tab Button
                Button(action: {
                    withAnimation{
                        self.selection = 6
                    }
                }, label: {
                    Image("dumbbell")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding()
                        .foregroundColor(selection == 6 ? Color.black: Color.gray)
                        .background(selection == 6 ? Color.PrimaryColor: Color.clear)
                        .clipShape(Circle())
                        .padding(.top,selection == 6 ? -30:0)
                })
                Spacer()
                
                //Fifth button
                Button(action: {
                    withAnimation{
                        self.selection = 7
                    }
                }, label: {
                    Image("person")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding()
                        .foregroundColor(selection == 7 ? Color.black: Color.gray)
                        .background(selection == 7 ? Color.PrimaryColor: Color.clear)
                        .clipShape(Circle())
                        .padding(.top,selection == 7 ? -30:0)
                    
                })
               // Spacer()
            }
        }
        .frame(height: 60)
        .background(Color.CustomGray)
    }
}

