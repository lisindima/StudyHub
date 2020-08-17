//
//  String+Emoji.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 20.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        return unicodeScalars.count == 1 &&
            (firstProperties.isEmojiPresentation ||
                firstProperties.generalCategory == .otherSymbol)
    }

    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 &&
            unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }

    var isEmoji: Bool {
        isSimpleEmoji || isCombinedIntoEmoji
    }
}

extension String {
    var isSingleEmoji: Bool {
        count == 1 && containsEmoji
    }

    var containsEmoji: Bool {
        contains { $0.isEmoji }
    }

    var containsOnlyEmoji: Bool {
        !isEmpty && !contains { !$0.isEmoji }
    }

    var emojiString: String {
        emojis.map { String($0) }.reduce("", +)
    }

    var emojis: [Character] {
        filter { $0.isEmoji }
    }

    var emojiScalars: [UnicodeScalar] {
        filter { $0.isEmoji }.flatMap(\.unicodeScalars)
    }
}
