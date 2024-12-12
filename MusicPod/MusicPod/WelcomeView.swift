//
//  WelcomeView.swift
//  MusicPod
//
//  Created by eduardo caballero on 11/26/24.
//


import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("¡Explora musicPod!")
                    .font(.largeTitle)
                    .padding()
                    .navigationTitle("Bienvenidx!")

                Text("Inicia sesión en tu cuenta o crea una para continuar...")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .padding()

                HStack {
                    NavigationLink(destination: LoginView()) {
                        Text("Iniciar sesión")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: RegisterView()) {
                        Text("Registrarse")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding()

                Spacer()

                Text("Selecciona alguna opción y obtén privilegios 👆🏻")
                    .font(.footnote)
                    .padding()
            }
            .padding()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
