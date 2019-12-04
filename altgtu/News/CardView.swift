//
//  CardView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import URLImage

struct CardView: View {
    
    let article: Articles
    let noImageUrl = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2Fplaceholder.jpeg?alt=media&token=8f554741-2bfb-41ef-82b0-fbc64f0ffdf6"
    
    var body: some View {
        VStack {
            URLImage(URL(string: article.urlToImage ?? noImageUrl)!, incremental : true, expireAfter : Date ( timeIntervalSinceNow : 31_556_926.0 ), placeholder: { _ in
                EmptyView()
            },
            content:
            { proxy in
                proxy.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
            HStack {
                VStack(alignment: .leading) {
                    Text(article.source?.name ?? "Источник отсутствует")
                        .font(.subheadline)
                        .padding(.bottom, 8)
                        .foregroundColor(.secondary)
                    Text(article.title)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .padding(.bottom, 8)
                    Text(article.author ?? "Автор отсутствует")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
            )
        .padding()
    }
}
