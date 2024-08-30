//
//  EndPoint.swift
//
//
//  Created by Fazliddinov Iskandar on 30/08/24.
//

import Foundation


public protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any]? { get }
}
