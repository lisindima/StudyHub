//
//  CardView.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import KingfisherSwiftUI
import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showImage: Bool = true

    let article: Articles
    let noImageUrl = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2Fplaceholder.jpeg?alt=media&token=8f554741-2bfb-41ef-82b0-fbc64f0ffdf6"

    var body: some View {
        VStack {
            if showImage {
                KFImage(URL(string: article.urlToImage ?? noImageUrl))
                    .renderingMode(.original)
                    .placeholder { ProgressView() }
                    .onFailure { _ in
                        showImage = false
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(article.source?.name?.uppercased() ?? "Источник отсутствует".uppercased())
                        .font(.custom("HelveticaNeue-Bold", size: 12))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                    Text(article.title)
                        .foregroundColor(.primary)
                        .fontWeight(.heavy)
                        .lineLimit(4)
                        .padding(.bottom, 8)
                }.layoutPriority(100)
                Spacer()
            }.padding()
        }
        .background(Color.secondarySystemBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        .padding()
    }
}
