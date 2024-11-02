import SwiftUI
import AnimateText

struct LoginView: View {
    
    @EnvironmentObject var viewingStatesModel: ViewingStatesModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isRegistered: Bool = false
    @State private var title_text: String = ""
    @State var type: ATUnitType = .letters
    @State var userInfo: Double? = 0
    @State private var vStackOpacity: Double = 0
    @State private var showPasswordField: Bool = false
    @State private var keyboardOffset: CGFloat = 0
    @State private var animateGradient = false
    
    func register() {
        isRegistered = true
        viewingStatesModel.states.logintoregistration = true
    }
    
    func authentication (username: String, password: String) {
        if username == "123" && password == "123" {
            viewingStatesModel.toggleLogintohome()
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue, .green]),
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateGradient)
            .onAppear {
                animateGradient.toggle()
            }
            .ignoresSafeArea()
            ScrollView {
                VStack {
                    Spacer(minLength: 250)
                    AnimateText<ATCurtainEffect>($title_text, type: type, userInfo: userInfo)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .fixedSize()
                    TextField("Username", text: $username)
                        .padding()
                        .cornerRadius(8)
                        .frame(width: 200, height: 50)
                        .fixedSize()
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.1).cornerRadius(8))
                        .onChange(of: username) {
                            withAnimation(.easeInOut(duration: 1)) {
                                showPasswordField = !username.isEmpty
                            }
                        }
                    
                    if showPasswordField {
                        HStack {
                            SecureField("Password", text: $password)
                                .padding()
                                .cornerRadius(8)
                                .frame(width: 130, height: 50)
                                .foregroundColor(.white)
                                .fixedSize()  // Prevents resizing
                                .background(Color.white.opacity(0.1).cornerRadius(8))
                                .opacity(showPasswordField ? 1 : 0) // Fade in opacity
                                .animation(.easeInOut(duration: 1), value: showPasswordField)
                            
                            Button("💯") {
                                authentication(username: username, password: password)
                            }
                            .font(.system(size: 30))
                            .padding()
                            .cornerRadius(4)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 0)
                            .opacity(showPasswordField ? 1 : 0)
                            .animation(.easeInOut(duration: 1), value: showPasswordField)
                        }.transition(.opacity)
                    } else {
                        Button(isRegistered ? "Registered" : "Make an Account!") {
                            register()
                        }
                        .padding()
                        .cornerRadius(4)
                        .foregroundColor(.yellow)
                        .frame(width: 200, height: 50)
                    }
                }
                .padding(.bottom, keyboardOffset)
                .opacity(vStackOpacity)
                .onAppear {
                    title_text = "Get Ready"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        title_text = "Smash"
                    }
                    withAnimation(.easeOut(duration: 2)) {
                        vStackOpacity = 1
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    adjustForKeyboard(notification: notification)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    keyboardOffset = 0
                }
            }
        }
    }
    private func adjustForKeyboard(notification: NotificationCenter.Publisher.Output) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            withAnimation {
                keyboardOffset = keyboardFrame.height / 2
            }
        }
    }
}

#Preview {
    LoginView()
}

