//
//  HTTPDownloader.swift
//
//
//  Created by Fazliddinov Iskandar on 30/08/24.
//

import Foundation



public protocol HTTPDataDownloader {
    func httpData(for request: URLRequest) async throws -> Data
}

extension URLSession: HTTPDataDownloader {
    public func httpData(for request: URLRequest) async throws -> Data {
        let (data, response) = try await self.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200 ... 299:
            return data
            
        default:
            throw APIError.statusCode(httpResponse.statusCode)
        }
    }
}
