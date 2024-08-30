//
//  File.swift
//  
//
//  Created by Fazliddinov Iskandar on 30/08/24.
//

import Foundation


extension JSONDecoder {
    func decode<T: Decodable>(from data: Data) throws -> T {
        do {
            return try self.decode(T.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            debugPrint(context)
            throw APIError.decoding
        } catch let DecodingError.keyNotFound(key, context) {
            debugPrint("Key '\(key)' not found:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
            throw APIError.decoding
        } catch let DecodingError.valueNotFound(value, context) {
            debugPrint("Value '\(value)' not found:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
            throw APIError.decoding
        } catch let DecodingError.typeMismatch(type, context) {
            debugPrint("Type '\(type)' mismatch:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
            throw APIError.decoding
        } catch {
            debugPrint("error: ", error)
            throw APIError.decoding
        }
    }
}


func debugPrint(_ any: Any) {
#if DEBUG
print(any)
#endif
}
