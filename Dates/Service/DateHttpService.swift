//
//  DateHttpService.swift
//  Dates
//
//  Created by Dirisu on 13/04/2023.
//

import Foundation

enum HttpError: Error {
    case notfound(message: String = "Resource not found")
    case error(message: String = "Unexpected error")
    case invalidurl(message: String = "Invalid URL");
}

extension HttpError {
    var message: String {
        switch(self) {
            case let .notfound(message):
                return message;
        case let .error(message):
                return message;
            case let .invalidurl(message):
                return message;

        }
    }
}

class DateHttpService {
    func getDate() async throws -> CurrentDate? {
        let baseUrl = Constants.BASE_URL;
        guard let url = URL(string: "\(baseUrl)/current-date") else {
            throw HttpError.invalidurl();
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try? JSONDecoder().decode(CurrentDate.self, from: data)
    }
}
