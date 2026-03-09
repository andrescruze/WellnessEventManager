import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var isLoading = false
    @FocusState private var focusedField: Field?

    enum Field { case email, password }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // Logo
                        VStack(spacing: 16) {
                            Image("AppLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .shadow(color: Color.appMint.opacity(0.35), radius: 16, x: 0, y: 6)

                            Text("Discover events that nourish your soul")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)

                        // Form
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Label("Email", systemImage: "envelope")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appBlue)
                                TextField("you@example.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focusedField, equals: .email)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(focusedField == .email ? Color.appBlue : Color.appGray, lineWidth: 1.5)
                                    )
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Label("Password", systemImage: "lock")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appBlue)
                                SecureField("••••••••", text: $password)
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
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    authViewModel.login(email: email, password: password)
                                    isLoading = false
                                }
                            } label: {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text("Log In")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.appMint)
                                .foregroundStyle(Color(hex: "1E5631"))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: Color.appMint.opacity(0.4), radius: 6, y: 3)
                            }
                        }
                        .padding(.horizontal, 24)

                        // Divider
                        HStack {
                            Rectangle().fill(Color.appGray).frame(height: 1)
                            Text("or try a demo")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize()
                            Rectangle().fill(Color.appGray).frame(height: 1)
                        }
                        .padding(.horizontal, 24)

                        // Demo logins
                        VStack(spacing: 10) {
                            DemoLoginButton(
                                title: "Demo Attendee",
                                subtitle: "sofia@email.com",
                                icon: "person.fill",
                                color: Color.appMint
                            ) {
                                authViewModel.login(email: "sofia@email.com", password: "password123")
                            }
                            DemoLoginButton(
                                title: "Demo Organizer",
                                subtitle: "maya@zenflow.com",
                                icon: "star.fill",
                                color: Color.appLavender
                            ) {
                                authViewModel.login(email: "maya@zenflow.com", password: "password123")
                            }
                        }
                        .padding(.horizontal, 24)

                        // Sign up link
                        Button {
                            showSignUp = true
                        } label: {
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundStyle(.secondary)
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appBlue)
                            }
                            .font(.subheadline)
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}

private struct DemoLoginButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(color.opacity(0.2)).frame(width: 36, height: 36)
                    Image(systemName: icon).font(.caption).foregroundStyle(color)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.subheadline).fontWeight(.medium).foregroundStyle(Color.appDarkText)
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "arrow.right.circle")
                    .foregroundStyle(color)
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.3), lineWidth: 1))
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
