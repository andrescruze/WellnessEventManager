import SwiftUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Profile header
                        VStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: [Color.appMint, Color.appBlue.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 90, height: 90)

                                Text(String(authViewModel.currentUser?.name.prefix(1) ?? "?"))
                                    .font(.system(size: 38, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .shadow(color: Color.appMint.opacity(0.4), radius: 10)

                            VStack(spacing: 4) {
                                Text(authViewModel.currentUser?.name ?? "")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.appDarkText)

                                Text(authViewModel.currentUser?.email ?? "")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                HStack(spacing: 6) {
                                    Image(systemName: rolIcon)
                                        .font(.caption)
                                    Text(authViewModel.currentUser?.role.displayName ?? "")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(roleColor)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(roleColor.opacity(0.15))
                                .clipShape(Capsule())
                                .padding(.top, 4)
                            }
                        }
                        .padding(.top, 20)

                        // Info cards
                        VStack(spacing: 12) {
                            ProfileInfoRow(icon: "calendar", label: "Member Since", value: joinDateString)
                            ProfileInfoRow(icon: "person.badge.key", label: "Account Type", value: authViewModel.currentUser?.role.displayName ?? "")
                            if let bio = authViewModel.currentUser?.bio, !bio.isEmpty {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "quote.bubble").foregroundStyle(Color.appBlue)
                                        Text("Bio").font(.subheadline).fontWeight(.medium).foregroundStyle(.secondary)
                                    }
                                    Text(bio)
                                        .font(.subheadline)
                                        .foregroundStyle(Color.appDarkText)
                                        .lineSpacing(3)
                                }
                                .padding(16)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.horizontal)

                        // Quick links (organizer only)
                        if authViewModel.currentUser?.role == .organizer {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Organizer Tools")
                                    .font(.headline)
                                    .foregroundStyle(Color.appBlue)
                                    .padding(.horizontal)

                                QuickLinkRow(icon: "calendar.badge.plus", label: "Create New Event", color: Color.appMint) {}
                                QuickLinkRow(icon: "chart.bar", label: "View Analytics", color: Color.appBlue) {}
                            }
                        }

                        // App info
                        VStack(spacing: 10) {
                            Text("About")
                                .font(.headline)
                                .foregroundStyle(Color.appBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)

                            QuickLinkRow(icon: "leaf.fill", label: "WellnessEvents v1.0", color: Color.appMint) {}
                            QuickLinkRow(icon: "shield.fill", label: "Privacy Policy", color: Color.appLavender) {}
                            QuickLinkRow(icon: "envelope.fill", label: "Contact Support", color: Color.appBlue) {}
                        }

                        // Logout
                        Button {
                            showLogoutAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Log Out")
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(Color(hex: "C0392B"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "C0392B").opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Profile")
            .alert("Log Out?", isPresented: $showLogoutAlert) {
                Button("Log Out", role: .destructive) { authViewModel.logout() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You'll need to sign in again to access your account.")
            }
        }
    }

    private var joinDateString: String {
        let date = authViewModel.currentUser?.joinDate ?? Date()
        return date.formatted(.dateTime.month().year())
    }

    private var rolIcon: String {
        authViewModel.currentUser?.role == .organizer ? "star.fill" : "figure.yoga"
    }

    private var roleColor: Color {
        authViewModel.currentUser?.role == .organizer ? Color.appLavender : Color.appMint
    }
}

private struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Color.appBlue)
                .frame(width: 22)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.appDarkText)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct QuickLinkRow: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(color)
                }
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(Color.appDarkText)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView()
        .environment(AuthViewModel())
}
