//
//  HTTPClient.swift
//
//
//  Created by Fazliddinov Iskandar on 30/08/24.
//

import Foundation
import SwiftyJSON


final public class HTTPClient {
    private let downloader: any HTTPDataDownloader
    private let requestBuilder: RequestBuilder
    private let networkMonitor: NetworkMonitor

    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970
        return aDecoder
    }()

    public init(
            downloader: any HTTPDataDownloader = URLSession.shared,
            requestBuilder: RequestBuilder = .init(),
            networkMonitor: NetworkMonitor = .shared
        ) {
            self.downloader = downloader
            self.requestBuilder = requestBuilder
            self.networkMonitor = networkMonitor
        }
}

extension HTTPClient {
    @discardableResult
    public func data(from endpoint: Endpoint) async throws -> Data {
        
        guard networkMonitor.isInternetAvailable() else {
            throw APIError.noInternetConnection
        }

        let request = try requestBuilder.makeRequest(from: endpoint)
        
        logRequset(request)
        
        let data = try await downloader.httpData(for: request)
        
        logResponse(data, request)
        
        return data
    }

    public func data<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        guard networkMonitor.isInternetAvailable() else {
            throw APIError.noInternetConnection
        }

        let request = try requestBuilder.makeRequest(from: endpoint)
        
        logRequset(request)
        
        let data = try await downloader.httpData(for: request)
        
        logResponse(data, request)
        
        return try decoder.decode(from: data)
    }
    
    private func logRequset(_ request: URLRequest) {
        var debugingPrint = "🔽🔽🔽\n"
        debugingPrint += "🌐 Request URL: \(request.url?.absoluteString ?? "No URL")\n"
        debugingPrint += "💻 HTTP Method: \(request.httpMethod ?? "No Method")\n"

        if let headers = request.allHTTPHeaderFields {
            debugingPrint += "🎩 Headers: \(headers)\n"
        }

        if let body = request.httpBody,
           let json = try? JSONSerialization.jsonObject(with: body, options: []) {
            debugingPrint += "👤 Body: \(json)\n"
        }

        debugingPrint += "🔼🔼🔼"

        debugPrint(debugingPrint)
    }
    
    private func logResponse(_ data: Data, _ request: URLRequest) {
        var symbol = data != nil ? "✅✅✅" : "❌❌❌"
        
        let json = try? JSONDecoder().decode(JSON.self, from: data)
        
        let jsonString = json?.rawString(.utf8, options: .prettyPrinted) ?? ""
        
        debugPrint("""
        \(symbol)⬇️
        URL: \(request.url?.absoluteString ?? "No URL");
        JSON: \(jsonString)
        ⬆️\(symbol)
        """)
    }
    
    private func logErrorResponse(_ request: URLRequest) {
        var symbol = "❌❌❌"
        debugPrint("""
        \(symbol)⬇️
        URL: \(request.url?.absoluteString ?? "No URL");
        ⬆️\(symbol)
        """)
    }
}
