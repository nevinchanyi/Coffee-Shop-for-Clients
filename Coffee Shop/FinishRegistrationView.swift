//
//  FinishRegistrationView.swift
//  Coffee Shop
//
//  Created by constantine kos on 06.10.2020.
//

import SwiftUI

struct FinishRegistrationView: View {
    @State var name = ""
    @State var surname = ""
    @State var phoneNumber = ""
    @State var address = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section {
                Text("Finish registration")
                    .fontWeight(.heavy)
                    .font(.title)
                    .padding([.top, .bottom], 20)
                TextField("Name", text: $name).textContentType(.name)
                TextField("Surname", text: $surname).textContentType(.familyName)
                TextField("PhoneNumber", text: $phoneNumber).textContentType(.telephoneNumber).keyboardType(.numberPad)
                TextField("Address", text: $address).textContentType(.fullStreetAddress)
                
            } //
            
            Section {
                Button(action: {
                    finishRegistration()
                }, label: {
                    Text("Finish Registration")
                        .foregroundColor(fieldsCompleted() ? nil : .green)
                })
            }.disabled(fieldsCompleted())
        }
    }
    private func fieldsCompleted() -> Bool {
        if name != "" && surname != "" && phoneNumber != "" && address != "" {
            return false
        }
        return true
    }
    
    private func finishRegistration() {
        let fullname = name + " " + surname
        
        updateCurrentUser(withValues: [kFIRSTNAME: name, kLASTNAME: surname, kFULLNAME: fullname, kFULLADDRESS: address, kPHONENUMBER: phoneNumber, kONBOARD: true]) { (error) in
            if error != nil {
                
                print("### ERROR: updating user:", error!.localizedDescription)
                return
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct FinishRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        FinishRegistrationView()
    }
}
