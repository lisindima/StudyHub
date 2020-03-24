//
//  DetailsNews.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 20.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

extension Font {
    static func avenirNext(size: Int) -> Font {
        return Font.custom("Avenir Next", size: CGFloat(size))
    }
    
    static func avenirNextRegular(size: Int) -> Font {
        return Font.custom("AvenirNext-Regular", size: CGFloat(size))
    }
}

struct DetailsNews: View {
    private let imageHeight: CGFloat = 300
    private let collapsedImageHeight: CGFloat = 75
    
    @ObservedObject var articleContent: ViewFrame = ViewFrame()
    @State private var titleRect: CGRect = .zero
    @State private var headerImageRect: CGRect = .zero
    
    let article: Articles
    let noImageUrl = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2Fplaceholder.jpeg?alt=media&token=8f554741-2bfb-41ef-82b0-fbc64f0ffdf6"
    
    func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = imageHeight - collapsedImageHeight
        if offset < -sizeOffScreen {
            let imageOffset = abs(min(-sizeOffScreen, offset))
            return imageOffset - sizeOffScreen
        }
        if offset > 0 {
            return -offset
        }
        return 0
    }
    
    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        if offset > 0 {
            return imageHeight + offset
        }
        return imageHeight
    }
    
    func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height
        return blur * 6
    }
    
    private func getHeaderTitleOffset() -> CGFloat {
        let currentYPos = titleRect.midY
        if currentYPos < headerImageRect.maxY {
            let minYValue: CGFloat = 50.0
            let maxYValue: CGFloat = collapsedImageHeight
            let currentYValue = currentYPos
            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue))
            let finalOffset: CGFloat = -30.0
            return 20 - (percentage * finalOffset)
        }
        return .infinity
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image("altIconApp")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                        VStack(alignment: .leading) {
                            Text("Статья написана:")
                                .font(.avenirNext(size: 12))
                                .foregroundColor(.secondary)
                            Text(article.source?.name ?? "")
                                .font(.avenirNext(size: 17))
                        }
                    }
                    Text("\(article.publishedAt ?? "02 January 2019") • Читать 5 мин.")
                        .font(.avenirNextRegular(size: 12))
                        .foregroundColor(.secondary)
                    Text(article.title)
                        .font(.avenirNext(size: 28))
                        .background(GeometryGetter(rect: self.$titleRect))
                    Text(article.description ?? loremIpsum)
                        .lineLimit(nil)
                        .font(.avenirNextRegular(size: 17))
                }
                .padding(.horizontal)
                .padding(.top, 16.0)
            }
            .offset(y: imageHeight + 16)
            .background(GeometryGetter(rect: $articleContent.frame))
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    KFImage(URL(string: self.article.urlToImage ?? self.noImageUrl)!)
                        .placeholder { ActivityIndicator(styleSpinner: .medium) }
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                        .blur(radius: self.getBlurRadiusForImage(geometry))
                        .clipped()
                        .background(GeometryGetter(rect: self.$headerImageRect))
                    Text(self.article.title)
                        .font(.avenirNext(size: 17))
                        .foregroundColor(.primary)
                        .offset(x: 0, y: self.getHeaderTitleOffset())
                }
                .clipped()
                .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }
            .frame(height: imageHeight)
            .offset(x: 0, y: -(articleContent.startingRect?.maxY ?? UIScreen.main.bounds.height))
        }.edgesIgnoringSafeArea(.all)
    }
}

let loremIpsum = """
Lorem ipsum dolor sit amet consectetur adipiscing elit donec, gravida commodo hac non mattis augue duis vitae inceptos, laoreet taciti at vehicula cum arcu dictum. Cras netus vivamus sociis pulvinar est erat, quisque imperdiet velit a justo maecenas, pretium gravida ut himenaeos nam. Tellus quis libero sociis class nec hendrerit, id proin facilisis praesent bibendum vehicula tristique, fringilla augue vitae primis turpis.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
"""

class ViewFrame: ObservableObject {
    
    var startingRect: CGRect?
    
    @Published var frame: CGRect {
        willSet {
            if startingRect == nil {
                startingRect = newValue
            }
        }
    }
    
    init() {
        self.frame = .zero
    }
}

struct GeometryGetter: View {
    
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: .global))
        }.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
            self.rect = value
        }
    }
}

struct RectanglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
