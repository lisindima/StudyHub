//
//  FirebaseErrorTranslate.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 08.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Foundation
import Firebase

extension AuthErrorCode {
    var description: String? {
        switch self {
            case .emailAlreadyInUse:
                return "Этот адрес электронной почты уже используется другим пользователем."
            case .userDisabled:
                return "Этот пользователь был отключен."
            case .operationNotAllowed:
                return "Операция не разрешена."
            case .invalidEmail:
                return "Адрес электронной почты имеет неправильный формат."
            case .wrongPassword:
                return "Пароль неверен или у пользователя нет пароля."
            case .userNotFound:
                return "Учетная запись пользователя не найдена с указанным адресом электронной почты."
            case .networkError:
                return "Проблема при попытке подключения к серверу."
            case .weakPassword:
                return "Очень слабый или неверный пароль."
            case .missingEmail:
                return "Вам необходимо зарегистрировать электронную почту."
            case .internalError:
                return "Внутренняя ошибка."
            case .invalidCustomToken:
                return "Неверный пользовательский токен."
            case .tooManyRequests:
                return "Слишком много запросов отправлены на сервер, повторите попытку позже."
            default:
                return nil
        }
    }
}

extension FirestoreErrorCode {
    var description: String? {
        switch self {
            case .cancelled:
                return "Операция отменена."
            case .unknown:
                return "Неизвестная ошибка."
            case .invalidArgument:
                return "Неверный аргумент."
            case .notFound:
                return "Документ не был внедрен."
            case .alreadyExists:
                return "Документ, который вы намереваетесь создать, уже существует."
            case .permissionDenied:
                return "У вас нет прав для выполнения этой операции."
            case .aborted:
                return "Операция прервана."
            case .outOfRange:
                return "Выход за пределы."
            case .unimplemented:
                return "Эта операция не была реализована или пока не поддерживается."
            case .internal:
                return "Внутренняя ошибка."
            case .unavailable:
                return "На данный момент услуга недоступна, попробуйте позже."
            case .unauthenticated:
                return "Неаутентифицированный пользователь."
            default:
                return nil
        }
    }
}

extension StorageErrorCode {
    var description: String? {
        switch self {
            case .unknown:
                return "Неизвестная ошибка."
            case .quotaExceeded:
                return "Пространство для сохранения файлов было превышено."
            case .unauthenticated:
                return "Неаутентифицированный пользователь."
            case .unauthorized:
                return "Пользователь не авторизован для выполнения этой операции."
            case .retryLimitExceeded:
                return "Превышен тайм-аут. Пожалуйста, попробуйте еще раз."
            case .downloadSizeExceeded:
                return "Размер загрузки превышает объем памяти."
            case .cancelled:
                return "Операция отменена."
            default:
                return nil
        }
    }
}

public extension Error {
    var localizedDescription: String {
        let error = self as NSError
        if error.domain == AuthErrorDomain {
            if let code = AuthErrorCode(rawValue: error.code) {
                if let errorString = code.description {
                    return errorString
                }
            }
        } else if error.domain == FirestoreErrorDomain {
            if let code = FirestoreErrorCode(rawValue: error.code) {
                if let errorString = code.description {
                   return errorString
                }
            }
        } else if error.domain == StorageErrorDomain {
            if let code = StorageErrorCode(rawValue: error.code) {
                if let errorString = code.description {
                    return errorString
                }
            }
        }
        return error.localizedDescription
    }
}
