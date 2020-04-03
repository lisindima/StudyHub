//
//  CalenderTimeSinceNow.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 03.04.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Foundation

extension Date {
    
    func calenderTimeSinceNow() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        
        if years > 0 {
            if years > 4 {
                return "\(years) лет назад"
            } else {
                return years == 1 ? "1 год назад" : "\(years) года назад"
            }
        } else if months > 0 {
            if months > 4 {
                return "\(months) месяцев назад"
            } else {
                return months == 1 ? "1 месяц назад" : "\(months) месяца назад"
            }
        } else if days >= 7 {
            let weeks = days / 7
            if weeks > 4 {
                return "\(weeks) недель назад"
            } else {
                return weeks == 1 ? "1 неделя назад" : "\(weeks) недели назад"
            }
        } else if days > 0 {
            if days > 4 {
                return "\(days) дней назад"
            } else {
                return days == 1 ? "1 день назад" : "\(days) дня назад"
            }
        } else if hours > 0 {
            if hours > 4 {
                return "\(hours) часов назад"
            } else {
                return hours == 1 ? "1 час назад" : "\(hours) часа назад"
            }
        } else if minutes > 0 {
            if minutes > 4 {
                return "\(minutes) минут назад"
            } else {
                return minutes == 1 ? "1 минута назад" : "\(minutes) минуты назад"
            }
        } else {
            if seconds > 4 {
                return "\(seconds) секунд назад"
            } else {
                return seconds == 1 ? "1 секунда назад" : "\(seconds) секунды назад"
            }
        }
    }
}
