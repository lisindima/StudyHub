//
//  SplashScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    
    @Binding var dismissSheet: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Spacer()
                TitleView()
                    .padding(.bottom)
                InformationContainerView()
                Spacer(minLength: 30)
                NavigationLink(destination: PrivacySplashScreen(dismissSheet: $dismissSheet)) {
                    Text("Продолжить")
                        .customButton()
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Расписание", subTitle: "Просмотр расписания всех факультетов и групп университета.", imageName: "calendar")
            InformationDetailView(title: "Общение", subTitle: "Начните общаться со своими одногруппниками используя удобный чат со сквозным шифрованием.", imageName: "bubble.left")
            InformationDetailView(title: "Новости", subTitle: "Узнавайте все новости из мира и жизни университета.", imageName: "doc.richtext")
        }
        .padding(.horizontal)
    }
}

struct InformationDetailView: View {
    
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .frame(width: 30)
                .foregroundColor(.defaultColorApp)
                .padding()
                .accessibility(hidden: true)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)
                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct TitleView: View {
    var body: some View {
        VStack {
            Image("infoApp")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .cornerRadius(30)
                .shadow(radius: 10)
            Text("Личный кабинет")
                .customTitleText()
            Text("АлтГТУ")
                .customTitleText()
        }
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.defaultColorApp))
            .padding(.bottom)
    }
}

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

extension Text {
    func customTitleText() -> Text {
        self
            .fontWeight(.black)
            .font(.system(size: 28))
    }
}

extension Color {
    static var defaultColorApp = Color(UIColor.systemIndigo)
}
