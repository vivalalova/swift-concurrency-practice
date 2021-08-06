//
//  ContentView.swift
//  swift-concurrency
//
//  Created by Lova on 2021/8/6.
//

import Combine
import SwiftUI

struct ContentView: View {
    class ViewModel: ObservableObject {
        @Published var users: [User] = []

        func fetchUsers() {
            Task(priority: .medium) {
                self.users = await Fetch.request(from: "https://jsonplaceholder.typicode.com/users")
            }
        }

        private func fetch<T: Codable>(from urlString: String) async -> [T] {
            guard let url = URL(string: urlString) else {
                return []
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let results = try JSONDecoder().decode([T].self, from: data)
                return results
            } catch {
                return []
            }
        }
    }

    @StateObject var model = ViewModel()

    var body: some View {
        List {
            ForEach(self.model.users) { user in
                Text(user.name)
            }
        }
        .onAppear {
            self.model.fetchUsers()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
