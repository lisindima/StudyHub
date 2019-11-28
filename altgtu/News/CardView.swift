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
    let noImageUrl = "https://icon-library.net/images/no-image-icon/no-image-icon-13.jpg"
    
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
