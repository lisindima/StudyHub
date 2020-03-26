//
//  ImageCacheStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 22.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Combine
import SPAlert
import Kingfisher

class ImageCacheStore: ObservableObject {

    @Published var sizeImageCache: Int = 0
    @Published var sizeLimitImageCache: Int = 0
    
    static let shared = ImageCacheStore()
    
    func calculateImageCache() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                self.sizeImageCache = Int(size) / 1024 / 1024
            case .failure(let error):
                print(error)
            }
        }
    }

    func setCacheSizeLimit() {
        ImageCache.default.diskStorage.config.sizeLimit = 350 * 1024 * 1024
        self.sizeLimitImageCache = Int(ImageCache.default.diskStorage.config.sizeLimit / 1024 / 1024)
    }

    func clearImageCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            self.calculateImageCache()
            SPAlert.present(title: "Кэш фотографий успешно очищен.", preset: .done)
        }
    }
}