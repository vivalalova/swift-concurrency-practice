//
//  Fetch.swift
//  Fetch
//
//  Created by Lova on 2021/8/6.
//

import Foundation

enum Fetch {
    enum FetchError: Error {
        case notUrl
    }

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

    static func request<T: Codable>(from urlString: String) async -> Result<[T], Error> {
        guard let url = URL(string: urlString) else {
            return .failure(FetchError.notUrl)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let users = try JSONDecoder().decode([T].self, from: data)
            return .success(users)
        } catch {
            return .failure(error)
        }
    }
}
