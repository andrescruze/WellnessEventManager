import Foundation
import Observation

@Observable
class AuthViewModel {
    var currentUser: User?
    var isLoggedIn: Bool = false
    var errorMessage: String = ""

    private(set) var users: [User] = []

    private let sessionKey = "currentUserSession"
    private let allUsersKey = "allUsersStore"

    init() {
        loadUsers()
        loadSession()
    }

    private func loadUsers() {
        if let data = UserDefaults.standard.data(forKey: allUsersKey),
           let saved = try? JSONDecoder().decode([User].self, from: data) {
            users = saved
        } else {
            users = [MockData.organizer1, MockData.organizer2, MockData.attendee1]
            saveUsers()
        }
    }

    private func saveUsers() {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: allUsersKey)
        }
    }

    private func loadSession() {
        if let data = UserDefaults.standard.data(forKey: sessionKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
            isLoggedIn = true
        }
    }

    private func saveSession() {
        guard let user = currentUser,
              let data = try? JSONEncoder().encode(user) else { return }
        UserDefaults.standard.set(data, forKey: sessionKey)
    }

    @discardableResult
    func login(email: String, password: String) -> Bool {
        errorMessage = ""
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        if let user = users.first(where: {
            $0.email.lowercased() == email.lowercased() && $0.password == password
        }) {
            currentUser = user
            isLoggedIn = true
            saveSession()
            return true
        }
        errorMessage = "Invalid email or password."
        return false
    }

    @discardableResult
    func signUp(name: String, email: String, password: String, role: UserRole) -> Bool {
        errorMessage = ""
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        guard !users.contains(where: { $0.email.lowercased() == email.lowercased() }) else {
            errorMessage = "An account with this email already exists."
            return false
        }
        let newUser = User(name: name, email: email, password: password, role: role)
        users.append(newUser)
        saveUsers()
        currentUser = newUser
        isLoggedIn = true
        saveSession()
        return true
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        errorMessage = ""
        UserDefaults.standard.removeObject(forKey: sessionKey)
    }
}
