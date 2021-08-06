//
//  MainView.swift
//  MainView
//
//  Created by Lova on 2021/8/6.
//

import SwiftUI

struct MainView: View {
    @StateObject var model = ViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(self.model.users) { user in
                    NavigationLink {
                        // next page
                        Text(user.name)
                            .navigationTitle(user.name)
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        @Published var users: [User] = []

        @Published var onError: Error?

        func fetchUsers() {
            Task(priority: .medium) {
                let results: Result<[User], Error> = await Fetch.request(from: "https://jsonplaceholder.typicode.com/users")

                DispatchQueue.main.async {
                    switch results {
                    case let .success(users):
                        self.users = users
                    case let .failure(err):
                        self.onError = err
                        return
                    }
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
