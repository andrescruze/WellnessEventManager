import SwiftUI

struct SignUpView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole: UserRole = .attendee
    @FocusState private var focusedField: Field?

    enum Field { case name, email, password }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.appMint)
                                .padding(.top, 20)

                            Text("Join the Community")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.appDarkText)

                            Text("Create your account to begin your wellness journey")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        // Role selection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("I am a...")
                                .font(.headline)
                                .foregroundStyle(Color.appBlue)
                                .padding(.horizontal, 24)

                            HStack(spacing: 12) {
                                RoleCard(
                                    role: .attendee,
                                    icon: "figure.yoga",
                                    title: "Attendee",
                                    subtitle: "Discover & book wellness events",
                                    isSelected: selectedRole == .attendee
                                ) { selectedRole = .attendee }

                                RoleCard(
                                    role: .organizer,
                                    icon: "calendar.badge.plus",
                                    title: "Organizer",
                                    subtitle: "Create & manage your events",
                                    isSelected: selectedRole == .organizer
                                ) { selectedRole = .organizer }
                            }
                            .padding(.horizontal, 24)
                        }

                        // Form fields
                        VStack(spacing: 16) {
                            FormField(
                                label: "Full Name",
                                icon: "person",
                                placeholder: "Your name",
                                text: $name,
                                field: .name,
                                focusedField: $focusedField
                            )

                            FormField(
                                label: "Email",
                                icon: "envelope",
                                placeholder: "you@example.com",
                                text: $email,
                                field: .email,
                                focusedField: $focusedField,
                                keyboardType: .emailAddress
                            )

                            VStack(alignment: .leading, spacing: 6) {
                                Label("Password", systemImage: "lock")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appBlue)
                                SecureField("Minimum 6 characters", text: $password)
                                    .focused($focusedField, equals: .password)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(focusedField == .password ? Color.appBlue : Color.appGray, lineWidth: 1.5)
                                    )
                            }

                            if !authViewModel.errorMessage.isEmpty {
                                HStack(spacing: 6) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                    Text(authViewModel.errorMessage)
                                        .font(.caption)
                                }
                                .foregroundStyle(Color(hex: "C0392B"))
                                .padding(.horizontal, 4)
                            }

                            Button {
                                focusedField = nil
                                authViewModel.signUp(
                                    name: name,
                                    email: email,
                                    password: password,
                                    role: selectedRole
                                )
                            } label: {
                                Text("Create Account")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.appMint)
                                    .foregroundStyle(Color(hex: "1E5631"))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .shadow(color: Color.appMint.opacity(0.4), radius: 6, y: 3)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.appBlue)
                }
            }
        }
    }
}

private struct RoleCard: View {
    let role: UserRole
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.appMint : Color.appGray.opacity(0.3))
                        .frame(width: 52, height: 52)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(isSelected ? Color(hex: "1E5631") : .secondary)
                }
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isSelected ? Color.appDarkText : .secondary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.white : Color.white.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.appMint : Color.appGray.opacity(0.5), lineWidth: 2)
            )
            .shadow(color: isSelected ? Color.appMint.opacity(0.2) : .clear, radius: 8)
        }
        .animation(.spring(duration: 0.25), value: isSelected)
    }
}

private struct FormField: View {
    let label: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    let field: SignUpView.Field
    @FocusState.Binding var focusedField: SignUpView.Field?
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(label, systemImage: icon)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.appBlue)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .words)
                .autocorrectionDisabled(keyboardType == .emailAddress)
                .focused($focusedField, equals: field)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedField == field ? Color.appBlue : Color.appGray, lineWidth: 1.5)
                )
        }
    }
}

#Preview {
    SignUpView()
        .environment(AuthViewModel())
}
