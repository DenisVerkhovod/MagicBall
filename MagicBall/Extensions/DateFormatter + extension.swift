//
//  DateFormatter + extension.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 14.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

extension DateFormatter {

    static var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"

        return formatter
    }

}
