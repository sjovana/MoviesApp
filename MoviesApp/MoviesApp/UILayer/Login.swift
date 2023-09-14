//
//  Login.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 13.8.23..
//

import SwiftUI
import Combine

struct Login: View {
    @ObservedObject var viewModel: ViewModel
    
    init(dependencies: LoginModelDependencies){
        self.viewModel = ViewModel(dependencies: dependencies)
    }
   
    
    var body: some View {
            NavigationView {
                if viewModel.isLoggedIn{
                    HomeWithSideMenu(dependencies: viewModel.dependencies as! HomeWithSideMenuDependencies)
                }
                else {
                    li
                }
            }
        
       
    }
    var li : some View {
        NavigationView {
            ZStack{
                Color(red: 0.54509804, green: 0, blue: 0)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                VStack{
                    TextField("Username", text: $viewModel.email)
                                 .padding()
                                 .textFieldStyle(RoundedBorderTextFieldStyle())
                             
                             SecureField("Password", text: $viewModel.password)
                                 .padding()
                                 .textFieldStyle(RoundedBorderTextFieldStyle())
                             
                             Button("Login") {
                                 viewModel.login()
                             }
                             .padding()
                             .disabled(viewModel.isLoading)
                             .foregroundColor(.white)
                             .frame(width: 300, height: 50)
                             .background(Color(red: 0.54509804, green: 0, blue: 0))
                             .cornerRadius(10)
                             
                             if !viewModel.errorMessage.isEmpty {
                                 Text(viewModel.errorMessage)
                                     .foregroundColor(.red)
                                     .padding()
                             }
                }
            }
        }
    }
    var login : some View {
        VStack{
            TextField("Username", text: $viewModel.email)
                         .padding()
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                     
                     SecureField("Password", text: $viewModel.password)
                         .padding()
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                     
                     Button("Login") {
                         viewModel.login()
                     }
                     .padding()
                     .disabled(viewModel.isLoading)
                     
                     if !viewModel.errorMessage.isEmpty {
                         Text(viewModel.errorMessage)
                             .foregroundColor(.red)
                             .padding()
                     }
        }
        .padding()
        .navigationTitle("Login")
    }
}
//
//struct Login_Previews: PreviewProvider {
//    static var previews: some View {
//        Login()
//    }
//}
protocol LoginModelDependencies {
    
}

extension Login {
    final class ViewModel: ObservableObject{
        
        let dependencies: LoginModelDependencies
        
        @Published var email = ""
        @Published var password = ""
        @Published var isLoading = false
        @Published var isLoggedIn = false
        @Published var errorMessage = ""
        @Published var isSuccessfulLogin = false
        @Published var accessToken: String?
        
        init(dependencies: LoginModelDependencies){
            self.dependencies = dependencies
        }
        
        private var cancellables = Set<AnyCancellable>()
        
        func login() {
            
            guard !email.isEmpty, !password.isEmpty else {
                  errorMessage = "Please enter both email and password."
                  return
              }
            
            guard password.count >= 8 else {
                errorMessage = "Password must be at least 8 characters long."
                return
            }
            
            func isValidEmail(_ email: String) -> Bool {
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
                return emailPredicate.evaluate(with: email)
            }

            guard isValidEmail(email) else {
                errorMessage = "Please enter a valid email address."
                return
            }
            
            isLoading = true
            errorMessage = ""
            
           let apiPublisher = APIClient.login(email: email, password: password)
            
            apiPublisher
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            self.isLoading = false
                            switch completion {
                                case .finished:
                                    break
                                case .failure(let error):
                                    self.errorMessage = error.localizedDescription
                            }
                        } receiveValue: { user in
                            self.accessToken = user
                            self.isSuccessfulLogin = true
                            self.isLoggedIn = true
                        }
                        .store(in: &cancellables)
            
            
        }
        
        
    }
}
