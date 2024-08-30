//
//  File.swift
//  
//
//  Created by Fazliddinov Iskandar on 30/08/24.
//

import Foundation


enum APIError: Error {
    case networkError(Error)
    case decoding
    case invalidUrl
    case invalidResponse
    case statusCode(Int)
    //case yourErrors...
}
