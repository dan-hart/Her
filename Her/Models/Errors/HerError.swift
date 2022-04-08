//
//  HerError.swift
//  Her
//
//  Created by Dan Hart on 4/4/22.
//

import Foundation

enum HerError: String, Error {
    case nilKey = "Empty Key"
    case nilConfiguration = "Invalid Configuration"
    case invalidToken = "Provided Token is invalid"
    case notAuthenticated = "Not Authenticated"

    // MARK: - Data

    case couldNotFetchData = "Could not get data. Check your network connection."
}
