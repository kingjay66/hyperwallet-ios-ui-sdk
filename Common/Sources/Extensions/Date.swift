//
// Copyright 2018 - Present Hyperwallet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

/// The Date extension
public extension Date {
    /// The Date type format
    ///
    /// - date: The yMMMd format
    /// - dateTime: The yMMMEdjm format
    enum DateFormatMode {
        /// - date: The yMMMd format
        case date
        /// - dateTime: The yMMMEdjm format
        case dateTime
    }

    /// Formats date to string
    ///
    /// - Parameter dateFormat: format of the date
    /// - Returns: formatted date in string
    func formatDateToString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }

    /// Returns 1st day of the month
    ///
    /// - Returns: 1st day of the month
    func firstDayOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }

    /// Format date
    ///
    /// - Parameter formatMode: format date/datetime
    /// - Returns: formatted date
    func format(for formatMode: DateFormatMode) -> String {
        switch formatMode {
        case .date:
            return Date.dateFormatterOnlyDate.string(from: self)

        case .dateTime:
            return Date.dateFormatterDateAndTime.string(from: self)
        }
    }

    private static let dateFormatterOnlyDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yMMMd")
        formatter.formattingContext = .beginningOfSentence
        return formatter
    }()

    private static let dateFormatterDateAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yMMMEdjm")
        formatter.formattingContext = .beginningOfSentence
        return formatter
    }()
}
