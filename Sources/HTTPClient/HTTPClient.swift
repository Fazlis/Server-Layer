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

    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970
        return aDecoder
    }()

    public init(downloader: any HTTPDataDownloader = URLSession.shared, requestBuilder: RequestBuilder = .init()) {
        self.downloader = downloader
        self.requestBuilder = requestBuilder
    }
}

extension HTTPClient {
    @discardableResult
    public func data(from endpoint: Endpoint) async throws -> Data {
        let request = try requestBuilder.makeRequest(from: endpoint)
        
        logRequset(request)
        
        let data = try await downloader.httpData(for: request)
        
        logResponse(data)
        
        return data
    }

    public func data<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        let request = try requestBuilder.makeRequest(from: endpoint)
        
        logRequset(request)
        
        let data = try await downloader.httpData(for: request)
        
        logResponse(data)
        
        return try decoder.decode(from: data)
    }
    
    private func logRequset(_ request: URLRequest) {
        debugPrint("🔽🔽🔽")
        
        debugPrint("🌐 Request URL: \(request.url?.absoluteString ?? "No URL")")
        
        debugPrint("💻 HTTP Method: \(request.httpMethod ?? "No Method")")
        
        if let headers = request.allHTTPHeaderFields {
            debugPrint("🎩 Headers: \(headers)")
        }
        
        if let body = request.httpBody,
           let json = try? JSON(data: body) {
            debugPrint("👤 Body: \(json)")
        }
        
        debugPrint("🔼🔼🔼")
    }
    
    private func logResponse(_ data: Data) {
        let json = try? JSON(data: data)
        
        var symbol = json != nil ? "✅✅✅" : "❌❌❌"
        
        var response = json != nil ? "📲 Response JSON: \n\(json)" : "Invalid JSON"
        
        debugPrint(symbol)
        
        debugPrint(response)
        
        debugPrint(symbol)
    }
}
