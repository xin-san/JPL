import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject private var authService: AuthenticationService
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @State private var showResetPassword = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 50)
                
                Text("日语学习助手")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Login Form
                VStack(spacing: 15) {
                    TextField("邮箱", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disabled(authService.isLoading)
                    
                    SecureField("密码", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(authService.isLoading)
                    
                    Button(action: emailLogin) {
                        if authService.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("登录")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(authService.isLoading)
                    
                    HStack {
                        Button("忘记密码？") {
                            showResetPassword = true
                        }
                        .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Button("注册新账号") {
                            showSignUp = true
                        }
                        .foregroundColor(.blue)
                    }
                    
                    // 分隔线
                    HStack {
                        VStack { Divider() }.padding(.horizontal, 8)
                        Text("或")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        VStack { Divider() }.padding(.horizontal, 8)
                    }
                    .padding(.vertical)
                    
                    // Google 登录按钮
                    Button(action: googleLogin) {
                        HStack(spacing: 12) {
                            Image("google_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("使用 Google 账号登录")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                    .disabled(authService.isLoading)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("登录失败"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("确定"))
                )
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
            .sheet(isPresented: $showResetPassword) {
                ResetPasswordView()
            }
        }
    }
    
    private func emailLogin() {
        Task {
            do {
                try await authService.signIn(email: email, password: password)
            } catch let error as AuthError {
                alertMessage = error.localizedDescription
                showAlert = true
            } catch {
                alertMessage = "登录失败：\(error.localizedDescription)"
                showAlert = true
            }
        }
    }
    
    private func googleLogin() {
        Task {
            do {
                try await authService.signInWithGoogle()
            } catch {
                alertMessage = "Google 登录失败，请稍后重试"
                showAlert = true
            }
        }
    }
} 