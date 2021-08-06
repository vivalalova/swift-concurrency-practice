//
//  ContentView.swift
//  swift-concurrency
//
//  Created by Lova on 2021/8/6.
//

import Combine
import SwiftUI

struct ContentView: View {
    @StateObject var model = ViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(self.model.users) { user in
                    NavigationLink {
                        // next page
                        Text(user.name)
                    } label: {
                        UserListCell(user: user)
                    }
                }
            }.refreshable {
                self.model.fetchUsers()
            }
            .onAppear {
                self.model.fetchUsers()
            }
            .navigationTitle("hihi")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var users: [User] = []

        func fetchUsers() {
            Task(priority: .medium) {
                let results: [User] = await Fetch.request(from: "https://jsonplaceholder.typicode.com/users")

                DispatchQueue.main.async {
                    self.users = results
                }
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
}

struct UserListCell: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .fontWeight(.semibold)
            Text(user.website)
                .foregroundColor(.gray)
        }
    }
}
