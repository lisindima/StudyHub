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
    @Published var sizeLimitImageCache: Int = 0
    
    func calculateImageCache() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                self.sizeImageCache = Int(size) / 1024 / 1024
                print("\(self.sizeImageCache) МБ")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setCacheSizeLimit() {
        ImageCache.default.diskStorage.config.sizeLimit = 350 * 1024 * 1024
        self.sizeLimitImageCache = Int(ImageCache.default.diskStorage.config.sizeLimit / 1024 / 1024)
        print("Лимит кэша изображений установлен на: \(ImageCache.default.diskStorage.config.sizeLimit / 1024 / 1024) МБ")
    }
    
    func clearImageCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            self.calculateImageCache()
            print("Кэш очищен")
        }
    }
}
