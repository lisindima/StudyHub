//
//  BERT.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 03.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import CoreML

class BERT {
    let bertModel = BERTSQUADFP16()

    func findAnswer(for question: String, in document: String) -> Substring {
        let bertInput = BERTInput(documentString: document, questionString: question)
        guard bertInput.totalTokenSize <= BERTInput.maxTokens else {
            var message = "Text and question are too long"
            message += " (\(bertInput.totalTokenSize) tokens)"
            message += " for the BERT model's \(BERTInput.maxTokens) token limit."
            return Substring(message)
        }
        
        let modelInput = bertInput.modelInput!
        
        guard let prediction = try? bertModel.prediction(input: modelInput) else {
            return "The BERT model is unable to make a prediction."
        }
        
        guard let bestLogitIndices = bestLogitsIndices(from: prediction,
                                                       in: bertInput.documentRange) else {
            return "Couldn't find a valid answer. Please try again."
        }

        let documentTokens = bertInput.document.tokens
        let answerStart = documentTokens[bestLogitIndices.start].startIndex
        let answerEnd = documentTokens[bestLogitIndices.end].endIndex
        let originalText = bertInput.document.original
        return originalText[answerStart..<answerEnd]
    }
}
