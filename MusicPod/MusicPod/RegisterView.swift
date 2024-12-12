//
//  RegisterView.swift
//  MusicPod
//
//  Created by eduardo caballero on 11/27/24.
//


import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("¡Un gusto conocerte!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                VStack {
                    Text("Por favor, dejanos conocerte...")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    TextField("Nombre:", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top, 20)
                        .frame(maxWidth: 300)
                    
                    TextField("Correo:", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top, 20)
                        .frame(maxWidth: 300)
                    
                    SecureField("Contraseña:", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top, 20)
                        .frame(maxWidth: 300)
                    
                    SecureField("Una vez más:", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top, 20)
                        .frame(maxWidth: 300)
                    
                    Button(action: {
                        // Acción de registro
                    }) {
                        Text("¡Registrate!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: 110)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    .padding(.top, 20)
                }
                .padding(20)
                .background(Color.orange)
                .cornerRadius(30)

                Spacer()

            }
            .padding()
        }
    }
}



struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
