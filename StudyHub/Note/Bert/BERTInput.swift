//
//  BERTInput.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 03.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import CoreML

struct BERTInput {
    
    static let maxTokens = 384
    static private let documentTokenOverhead = 2
    static private let totalTokenOverhead = 3
    
    var modelInput: BERTSQUADFP16Input?
    
    let question: TokenizedString
    let document: TokenizedString
    
    private let documentOffset: Int

    var documentRange: Range<Int> {
        return documentOffset..<documentOffset + document.tokens.count
    }
    
    var totalTokenSize: Int {
        return BERTInput.totalTokenOverhead + document.tokens.count + question.tokens.count
    }
    
    init(documentString: String, questionString: String) {
        document = TokenizedString(documentString)
        question = TokenizedString(questionString)
        documentOffset = BERTInput.documentTokenOverhead + question.tokens.count
        
        guard totalTokenSize < BERTInput.maxTokens else {
            return
        }
        
        var wordIDs = [BERTVocabulary.classifyStartTokenID]
        
        wordIDs += question.tokenIDs
        wordIDs += [BERTVocabulary.separatorTokenID]
        wordIDs += document.tokenIDs
        wordIDs += [BERTVocabulary.separatorTokenID]
        
        let tokenIDPadding = BERTInput.maxTokens - wordIDs.count
        wordIDs += Array(repeating: BERTVocabulary.paddingTokenID, count: tokenIDPadding)

        guard wordIDs.count == BERTInput.maxTokens else {
            fatalError("`wordIDs` array size isn't the right size.")
        }
        
        var wordTypes = Array(repeating: 0.0, count: documentOffset)
        wordTypes += Array(repeating: 1.0, count: document.tokens.count)
        
        let tokenTypePadding = BERTInput.maxTokens - wordTypes.count
        wordTypes += Array(repeating: 0.0, count: tokenTypePadding)

        guard wordTypes.count == BERTInput.maxTokens else {
            fatalError("`wordTypes` array size isn't the right size.")
        }
        
        let inputShape = [1, NSNumber(value: BERTInput.maxTokens)]
        let tokenIDMultiArray = try? MLMultiArray(shape: inputShape, dataType: .double)
        let wordTypesMultiArray = try? MLMultiArray(shape: inputShape, dataType: .double)
        
        guard let tokenIDInput = tokenIDMultiArray else {
            fatalError("Couldn't create wordID MLMultiArray input")
        }
        
        guard let tokenTypeInput = wordTypesMultiArray else {
            fatalError("Couldn't create wordType MLMultiArray input")
        }
        
        for (index, identifier) in wordIDs.enumerated() {
            tokenIDInput[index] = NSNumber(value: identifier)
        }

        for (index, type) in wordTypes.enumerated() {
            tokenTypeInput[index] = NSNumber(value: type)
        }
        
        let modelInput = BERTSQUADFP16Input(wordIDs: tokenIDInput, wordTypes: tokenTypeInput)
        self.modelInput = modelInput
    }
}

