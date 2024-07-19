//
//  MainDashboardVie.swift
//  FitnessApp
//
//  Created by Sachin Patil on 11/07/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    @State var loggedUserName = "User"
    @State private var selectedActivity: ActivityModel? = nil
    let days = ["Today","Week","Month","3 Month","6 Month","8 Month","Year"]
    @State private var selectedDay: String? = "Today"
    @State var selectedTab = 2
    @State var selectedSidemenuTab = 0
    @State var isSideMenuShow = false
    @State var isSignOut = false
    var body: some View {
        ZStack{
            VStack(spacing:0){
                TopBar(onBellTapped: {}, onMenuTapped: {
                    isSideMenuShow = false
                    isSideMenuShow.toggle()
                })
                .padding(.top,50)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(days,id: \.self) { day in
                            Button(action: {
                                withAnimation{
                                    selectedDay = day
                                }
                            }, label: {
                                VStack(spacing:4){
                                    Text(day)
                                        .font(.Montserrat_SemiBold16px)
                                        .foregroundColor(selectedDay == day ? .white:.gray)
                                    Circle()
                                        .frame(width: 7,height: 7)
                                        .foregroundColor(selectedDay == day ? .PrimaryColor:.clear)
                                }
                            })
                        }
                        .frame(width: 100, height: 40, alignment: .center)
                    }
                    
                }
                .frame(height: 30)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 2), spacing: 20) {
                        ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            StatCard(activity: item.value)
                                .transition(.scale)
                                .onTapGesture {
                                    withAnimation{
                                        selectedActivity = item.value
                                    }
                                }
                            
                        }
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                    //.animation(.bouncy)
                }
                .padding(.top)
                BottomTabBar(selection: $selectedTab)
                    .frame(maxWidth: .infinity,alignment:.bottom)
                
            }
            .frame(maxWidth: .infinity,maxHeight:.infinity,alignment:.topLeading)
            .navigationBarHidden(true)
            
            NavigationLink(
                destination: selectedActivity.map {
                    ActivityChartView(
                        healthManager: manager,
                        activity: $0,
                        selectedActivity: $selectedActivity
                    )
                },
                isActive: .constant(selectedActivity != nil),
                label: { EmptyView() }
            )
            SideMenu(isShowing: $isSideMenuShow, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSidemenuTab, presentSideMenu: $isSideMenuShow, isSignOut: $isSignOut)))
            
            NavigationLink(destination: WelcomeView(), isActive: $isSignOut) {
                EmptyView()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.primaryBG)
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
        .onAppear(perform: {
            let token =  UserDefaults.standard.string(forKey: "accessToken")
            print("Userdefaulttoken---\(String(describing: token))")
            manager.startHealthDataFetching()
        })
        
    }
}
