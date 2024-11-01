import SwiftUI
import AVFoundation
import AnimateText



struct ContentView: View {
    
    @State private var showloginlayer: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                // Background video view
                BackgroundVideoPlayerView(login: 1,showloginpage: $showloginlayer)
                    .edgesIgnoringSafeArea(.all) // Make it full-screen, this is where they dynamic island is

                if showloginlayer {
                    LoginOverlay(animationforstringset: showloginlayer)
                }
            }
            
        }
    }
}

struct LoginOverlay: View {
    
    // For the login animation
    @State var animationforstringset: Bool
    
    @State private var Username: String = ""
    @State private var WrongUsername: Int = 0
    
    @State private var Password: String = ""
    @State private var WrongPassword: Int = 0
    
    @State private var isLoggedIn: Bool = false
    @State private var isRegistered: Bool = false
    
    @State private var isHomePage: Bool = false
    @State private var isRagistationPage: Bool = false
    
    // Animation of the text
    
    @State private var title_text: String = ""
    @State var type: ATUnitType = .letters
    //sets the delay
    @State var userInfo: Double? = 0
    
    
    @State private var vStackOpacity: Double = 0

    
    @State private var showPasswordField: Bool = false
    
    
    
    func login() {
        isLoggedIn = true // Set to true to simulate login success
    }
    
    func register() {
        isRegistered = true // Set to true to simulate registration success
        isRagistationPage = true
    }
    
    func authentication (Username: String, Password: String){
        //this is a tester piece of code just to get it working want to add websock and everything else later. Something good for scalling. ---- Can implement a hashmap with username as key and the value is the password, password we can use another algo called sha for encryption and then store it as the key value pair
        if Username == "123"{
            WrongUsername = 0
            if Password == "123"{
                WrongPassword = 0
                isHomePage = true
                login()
            }
        }
    }
    
    var body: some View {
        VStack {
            //title animation
            AnimateText<ATCurtainEffect>($title_text, type: type, userInfo: userInfo)
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            TextField("Username", text: $Username)
                .padding()
                .cornerRadius(8)
                .frame(width:200 , height: 50)
                .foregroundColor(.white)
                .onChange(of: Username) { perform:
                    if Username == "123" {
                        withAnimation(.easeInOut(duration: 1)) {
                            showPasswordField = true
                        }
                    } else {
                        showPasswordField = false
                    }
                }
            
            
            if showPasswordField {
                HStack{
                    SecureField("Password", text: $Password)
                        .padding()
                        .cornerRadius(8)
                        .frame(width: 130, height: 50)
                        .foregroundColor(.white)
                        .opacity(showPasswordField ? 1 : 0) // Fade in opacity
                        .animation(.easeInOut(duration: 1), value: showPasswordField)

                    Button(isLoggedIn ? "🐼" : "💯") {
                        authentication(Username: Username, Password: Password)
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
        .frame(width:1800, height:1000)
        .background(LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom), ignoresSafeAreaEdges: .all)
        .opacity(vStackOpacity) // Bind opacity to state
        .navigationDestination(isPresented: $isHomePage) {
            HomePage().navigationBarBackButtonHidden(true)
        }
        // goes to registration page if true
        .navigationDestination(isPresented: $isRagistationPage){
            RegistrationPage()
        }
        //this happens at real time and you wanna add anything dynamic into this
        .onAppear {
            // Initial delay to trigger animation
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                title_text = "Get Ready"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                title_text = "Smash"
            }
            withAnimation(.easeOut(duration: 2)) {
                vStackOpacity = 1 // Fade in
            }
        }
    }
}


struct HomePage: View {
    var body: some View {
        TabView {
            // Match History Tab
            MatchHistoryPage()
                .tabItem {
                    Text("🏛️")
                }
                .transition(.slide)
            // Start Session Tab
            StartSessionPage()
                .tabItem {
                    Text("🏸")
                }
                .transition(.slide)
            // Clips Tab
            ClipsPage()
                .tabItem {
                    Text("📸")
                }
                .transition(.slide)
        }
    }
}


struct ClipsPage: View {
    var body: some View {
        VStack{
            Text("clips page")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
        }
        .frame(width:1800, height:1000)
        .background(LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom), ignoresSafeAreaEdges: .all)
    }
}




struct MatchHistoryPage: View {
    @State private var showloginlayer: Bool = false
    var body: some View {
        ZStack{
            BackgroundVideoPlayerView(login: 3, showloginpage: $showloginlayer)
                .edgesIgnoringSafeArea(.all)
            Text("Match History")
                .foregroundColor(.white)
                .bold()
                .font(.system(size:20))
        }
    }
}



struct AccountSettingsPage: View {
    @State var logout: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack{
                    Text("Account Settings")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size:20))
                    
                    Button("Logout"){
                        logout.toggle()

                    }
                    .foregroundStyle(.white)
                    .padding()
                }
            }
            .navigationDestination(isPresented: $logout) {
                ContentView().navigationBarBackButtonHidden(true)
            }
        }
    }
}


struct StartSessionPage: View {
    @State var isAccountSettingsPage: Bool = false
    @State private var showloginlayer: Bool = false
    var body: some View {
        
        ZStack{
            BackgroundVideoPlayerView(login: 2,showloginpage: $showloginlayer)
                .edgesIgnoringSafeArea(.all)
            VStack{
                    Button("🐼"){
                        isAccountSettingsPage.toggle()
                    }
                    .font(.system(size:30))
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .offset(x:-160,y:-300)
                    .shadow(color: .black, radius: 5, x: 0, y: 10)
                    
                    Text("Home")
                        .bold()
                        .font(.system(size:20))
                        .foregroundColor(.white)
                    
                    Button("Start a Session") {
            
                    }
                        .foregroundColor(.white)
            }
        }
        .navigationDestination(isPresented: $isAccountSettingsPage)
        {
            AccountSettingsPage().navigationBarBackButtonHidden(false)
        }
    }
}


class Camerasession: ObservableObject {
    
}


struct RegistrationPage: View {
    var body: some View {
        Text("registration")
    }
}

//// BackgroundVideoPlayerView for showing a video in the background
//struct BackgroundVideoPlayerView: UIViewRepresentable {
//    let login: Int // class atribute
//    @Binding var showloginpage: Bool
//    
//    func statecheck() -> String {
//        // should add async but will do after
//        switch login {
//        case 1:
//            return "intro"
//        
//        case 2:
//            return "Homepagebackground"
//            
//        case 3:
//            return "MatchistoryBackground"
//            
//        default:
//            return "null"
//        }
//    }
//    
//    
//    
//    func makeUIView(context: Context) -> UIView { // return UIView type
//        let view = UIView(frame: .zero) // making the object UIView
//        // Load video from bundle asests, guard is the same as a try else statement
//        
//        guard let path = Bundle.main.path(forResource: statecheck(), ofType: "mp4") else {
//                return view
//            }
//
//        let player = AVPlayer(url: URL(fileURLWithPath: path))  // making AVPlayer object
//
//        // Configure the player layer
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resizeAspectFill    // setting the size of the video
//        playerLayer.frame = UIScreen.main.bounds
//        view.layer.addSublayer(playerLayer)     // using it as a layer background layer
//        
//        // Start the video
//        player.play()
//        
//        
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
//            if login > 1 {
//                player.seek(to: .zero) // Reset to the beginning
//                player.play() // Play again
//            }else{
//                showloginpage.toggle()
//            }
//        }
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // Handle updates if necessary
//    }
//}



#Preview {          // main
    ContentView()
}
