//
//  CustomTabBar.swift
//  MaterialCurvedTabBar
//
//  Created by Sopnil Sohan on 12/6/22.
//

import SwiftUI

struct CustomTabBar: View {
    @State var currentTab: Tab = .Home
    
    //Hiding native one
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    //Matched Geometry effect
    @Namespace var animation
    
    @State var currentXValue: CGFloat = 0
    
    var body: some View {
        TabView(selection: $currentTab) {
            SampleCard(color: .cyan.opacity(0.7), count: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.1).ignoresSafeArea())
                .tag(Tab.Home)
            
            Text("Search")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.1).ignoresSafeArea())
                .tag(Tab.Search)
            
            Text("Notification")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.1).ignoresSafeArea())
                .tag(Tab.Notifications)
           
            Text("Profile")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.1).ignoresSafeArea())
                .tag(Tab.Account)
        }
        //MARK: Curved Tab Bar
        .overlay(alignment: .bottom) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue){ tab in
                    TabButton(tab: tab)
                }
            }
            .padding(.vertical)
            .padding(.bottom, getSafeArea().bottom == 0 ? 10 : (getSafeArea().bottom - 10))
            .background(
                MaterialEffect(style: .systemThinMaterialDark)
                    .clipShape(BottomCurve(currentXValue: currentXValue))
            )
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .preferredColorScheme(.dark)
    }
    @ViewBuilder
    func SampleCard(color: Color, count: Int) -> some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(1...count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(color)
                            .frame(height: 250)
                    }
                }
                .padding()
                .padding(.bottom, 60)
                .padding(.bottom, getSafeArea().bottom == 0 ? 15 : getSafeArea().bottom)
            }
            .navigationTitle("Home")
        }
    }
    //MARK: Tab Button
    @ViewBuilder
    func TabButton(tab: Tab)->some View {
      //scince we need XAxis value for curve..
        GeometryReader { proxy in
            Button {
                withAnimation(.spring()) {
                    currentTab = tab
                    //updating value
                    currentXValue = proxy.frame(in: .global).midX
                }
            } label: {
                
                //Moving button up for current tab
                Image(systemName: tab.rawValue)
                //scince we need perfect value for curve..
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(currentTab == tab ? 15 : 0)
                    .contentShape(Rectangle())
                    .background(
                        ZStack {
                            if currentTab == tab {
                                MaterialEffect(style: .systemChromeMaterialDark)
                                    .clipShape(Circle())
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .offset(y: currentTab == tab ? -50 : 0)
            }
            .onAppear {
                if tab == Tab.allCases.first && currentXValue == 0 {
                    currentXValue = proxy.frame(in: .global).midX
                }
            }
        }
        .frame(height: 30)
        //max size
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
    }
}

//For Iterate
//Enum for tab
enum Tab: String,CaseIterable {
    case Home = "house.fill"
    case Search = "magnifyingglass"
    case Notifications = "bell.fill"
    case Account = "person.fill"
}

extension View {
    func getSafeArea()-> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}
