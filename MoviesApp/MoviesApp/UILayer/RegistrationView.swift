//
//  LogInView.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 5.5.23..
//

import SwiftUI
import Combine

struct RegistrationView: View {
    @ObservedObject var viewModel : ViewModel
    
    @State var index = 0
    @State var isAuthenticated: Bool = false
    
    init(dependencies: RegisterModelDependencies) {
        self.viewModel = ViewModel(dependencies: dependencies)
    }
    
    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Register") {
                viewModel.register()
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
        .navigationTitle("Register")
    }
}
//struct RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationView( )
//    }
//}


protocol RegisterModelDependencies {
    
}
final class ViewModel: ObservableObject {
    let dependencies: RegisterModelDependencies
    
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isSuccessfulRegistration = false
    
    init(dependencies: RegisterModelDependencies) {
        self.dependencies = dependencies
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func register() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        let apiPublisher = APIClient.register(name: name, email: email, password: password)
        
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
            } receiveValue: { token in
                self.isSuccessfulRegistration = true
            }
            .store(in: &cancellables)
    }
}
