//
//  LoginView.swift
//  Coffee Shop
//
//  Created by constantine kos on 06.10.2020.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var repeatPassword = ""
    @State var showingSignUp = false
    @State var showingFinishReg = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(showingSignUp ? "Sign Up" : "Sign In")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.bottom, .top], 20)
            
            VStack(alignment: .leading) {
                Text("Email")
                    .fontWeight(.light)
                    .font(.headline)
                
                TextField("email", text: $email).textContentType(.emailAddress).keyboardType(.emailAddress)
                Divider()
                
                Text("Password")
                    .fontWeight(.light)
                    .font(.headline)
                
                SecureField("enter your password", text: $password).textContentType(.password)
                Divider()
                
                if showingSignUp {
                    Text("Repeat password")
                        .fontWeight(.light)
                        .font(.headline)
                    
                    SecureField("repeat your password", text: $repeatPassword).textContentType(.password)
                    Divider()
                }
            }.padding()
            .animation(.easeOut(duration: 0.2))

            HStack {
                Spacer()
                Button(action: {
                    resetPassword()
                }, label: {
                    Text("Forget password?")
                        .foregroundColor(.gray)
                })
            }.padding(.horizontal)
            
            Button(action: {
                showingSignUp ? signUpUser() : loginUser()
            }, label: {
                Text(showingSignUp ? "Sign Up" : "Sign In")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 140, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.top, 20)
            })
            
            //Spacer()
            SignUpView(showingSignUp: $showingSignUp)
        }.sheet(isPresented: $showingFinishReg) {
            FinishRegistrationView()
        }
    }
    private func loginUser() {
        if email != "" && password != "" {
            FUser.loginUser(email: email, password: password) { (error, isEmailVerified) in
                if error != nil {
                    
                    print("### ERROR logging in the user", error?.localizedDescription)
                    return
                } else {
                    
                    print("### USER WAS LOGGED SUCCESSFUL, EMAIL IS VERIFIED:", isEmailVerified)
                    if FUser.currentUser() != nil && FUser.currentUser()!.onboarding {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingFinishReg.toggle()
                    }
                }
            }
        }
    }
    private func signUpUser() {
        if email != "" && password != "" && repeatPassword != "" {
            if password == repeatPassword {
                
                FUser.registerUserWith(email: email, password: password) { (error) in
                    if error != nil {
                        print("### Error registering user:", error!.localizedDescription)
                        return
                    }
                    print("User has been created")
                    // go back to the app
                    // check if user onboarding is done
                }
            } else { print("passwords don't match") }
            
        } else { print("email and password must be set") }
        
    }
    private func resetPassword() {
        
        if email != "" {
            FUser.resetPassword(email: email) { (error) in
                if error != nil {
                    print("### ERROR sending reset password,", error!.localizedDescription)
                    return
                }
                print("Please check your email")
            }
        } else {
            // notify the user
            print("email is empty")
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


struct SignUpView: View {
    @Binding var showingSignUp: Bool
        
    var body: some View {
        Spacer()
        VStack {
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button(action: {
                    showingSignUp.toggle()
                }, label: {
                    Text("Sign Up")
                        .foregroundColor(.green)
                })
                
                
            }
            .padding()
        }
    }
}
