//
//  Fetch.swift
//  Fetch
//
//  Created by Lova on 2021/8/6.
//

import Foundation

enum Fetch {
    static func request<T: Codable>(from urlString: String) async -> T? {
        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }

    static func request<T: Codable>(from urlString: String) async -> [T] {
        guard let url = URL(string: urlString) else {
            return []
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            return []
        }
    }
}
