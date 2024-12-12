//
//  LoginView.swift
//  MusicPod
//
//  Created by eduardo caballero on 11/27/24.
//


import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Un gustazo verte :D")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                VStack {
                    Text("Por favor, ingresa tus credenciales abajo...")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    TextField("Correo:", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top, 20)
                        .frame(maxWidth: 310)
                    
                    SecureField("Contraseña:", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top, 20)
                        .frame(maxWidth: 310)
                    
                    Button(action: {
                        // Acción de inicio de sesión
                    }) {
                        Text("Inicia Sesión")
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
                .background(Color.teal)
                .cornerRadius(30)

                Button(action: {
                    // Acción para recuperar contraseña
                }) {
                    Text("¡Oh no! ¿Olvidaste la contraseña?")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
