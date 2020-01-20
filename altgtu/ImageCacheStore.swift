//
//  ImageCacheStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 20.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Kingfisher

class ImageCacheStore: ObservableObject {
    
    @Published var sizeImageCache: Int = 0
    
    func calculateImageCache() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                self.sizeImageCache = Int(size)
                print("Disk cache size: \(Double(size) / 1024 / 1024) MB")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func clearImageCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            self.calculateImageCache()
            print("Кэш очищен")
        }
    }
}
