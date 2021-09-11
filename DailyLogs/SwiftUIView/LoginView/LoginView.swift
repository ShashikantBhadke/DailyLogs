//
//  LoginView.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 28/08/21.
//

import SwiftUI

struct LoginView: View {
    
    @State var mail = ""
    @State var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Mail Address", text: $mail)
                .padding()
                .frame(height: 45)
                .cornerRadius(4)
                .border(Color.gray, width: 1)
            SecureField("Password", text: $password)
                .padding()
                .frame(height: 45)
                .cornerRadius(4)
                .border(Color.gray, width: 1)
        }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
