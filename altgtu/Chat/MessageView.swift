//
//  MessageView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import URLImage

struct MessageView: View {
    var message: String
    var sender: String
    var timeMsg: String
    @EnvironmentObject var session: SessionStore
    @State var accentColor: Color = .gray
    @State var messageColor: Color = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.7)

    var body: some View {
        VStack(alignment: .leading) {
                HStack {
                    URLImage(URL(string:"\(session.url ?? "")")!, incremental : true, expireAfter : Date ( timeIntervalSinceNow : 31_556_926.0 ), placeholder: {
                    ProgressView($0) { progress in
                        ZStack {
                            if progress > 0.0 {
                                CircleProgressView(progress).stroke(lineWidth: 8.0)
                            }
                            else {
                                CircleActivityView().stroke(lineWidth: 50.0)
                            }
                        }
                    }.frame(width: 50, height: 50)
                }) { proxy in
                        proxy.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .clipped()
                            .shadow(radius: 5)
                            .frame(width: 50, height: 50)
                }
            
                VStack {
                HStack {
                    Text(sender.uppercased())
                        .foregroundColor(accentColor)
                        .font(.footnote)
                        .padding(.bottom, 0)
                        Spacer()
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(message)
                            .padding(.all, 10)
                            .background(messageColor)
                            .font(.body)
                            .cornerRadius(5)
                    }.padding(.bottom, 5)
                        Spacer()
                    }
                    HStack {
                        Text(timeMsg)
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Spacer()
                    }.padding(.leading, 3)
                }
            }
        }.padding(.leading)
    .padding(.trailing, 30)
    }
}

struct MessageView1: View {
    var message: String
    var sender: String
    @EnvironmentObject var session: SessionStore
    @State var accentColor: Color = .gray
    @State var messageColor: Color = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.7)

    var body: some View {
            VStack(alignment: .leading) {
                HStack {
            
                VStack {
                HStack {
                    Spacer()
                    Text(sender.uppercased())
                        .foregroundColor(accentColor)
                        .font(.footnote)
                        .padding(.bottom, 0)
                }
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(message)
                            .padding(.all, 10)
                            .background(messageColor)
                            .font(.body)
                            .cornerRadius(5)
                    }.padding(.bottom, 5)

        
                    }
                }
                URLImage(URL(string:"\(session.url ?? "")")!, incremental : true, expireAfter : Date ( timeIntervalSinceNow : 31_556_926.0 ), placeholder: {
                    ProgressView($0) { progress in
                        ZStack {
                            if progress > 0.0 {
                                CircleProgressView(progress).stroke(lineWidth: 8.0)
                            }
                            else {
                                CircleActivityView().stroke(lineWidth: 50.0)
                            }
                        }
                    }.frame(width: 50, height: 50)
                }) { proxy in
                        proxy.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .clipped()
                            .shadow(radius: 5)
                            .frame(width: 50, height: 50)
                }
            }
        }.padding(.trailing)
    .padding(.leading, 30)
    }
}
