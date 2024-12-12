import SwiftUI

struct MusicPodHomeView: View {
    @State private var isExpanded: Bool = false // Estado para manejar el desplegable

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Encabezado
                HStack {
                    Text("Bienvenido, eduardo! Reproduce algo.")
                        .font(.subheadline)
                    Spacer()
                    
                    NavigationLink(destination: WelcomeView()) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .navigationTitle("musicPod")
                .padding(.horizontal)

                // Barra de b\u00fasqueda
                HStack {
                    TextField("Buscar ...", text: .constant(""))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .background(
                            ZStack {
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.clear]),
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 220
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 15))

                                // Agregar efecto granular
                                Color.black.opacity(10)
                                    .blendMode(.overlay)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        )
                        .cornerRadius(15)

                    Image(systemName: "wifi.slash")
                        .foregroundColor(.red)
                }
                .padding(.horizontal)

                // Reproductor con pesta\u00f1a desplegable
                VStack(spacing: 1) {
                    Text("sonando ahora:")
                        .font(.caption)
                        .foregroundColor(.white)

                    HStack {
                        Text("Team – Lorde")
                            .font(.headline)
                            .foregroundColor(.blue)

                        Spacer()

                        HStack(spacing: 15) {
                            Image(systemName: "heart")
                            Image(systemName: "pause.fill")
                            Image(systemName: "forward.fill")
                            Image(systemName: "headphones")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .padding()
                .background(
                    ZStack {
                        RadialGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.clear]),
                            center: .center,
                            startRadius: 1,
                            endRadius: 220
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 15))

                        // Agregar efecto granular
                        Color.black.opacity(10)
                            .blendMode(.overlay)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                )
                .cornerRadius(15)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }

                if isExpanded {
                    VStack {
                        Text("Reproductor grande")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        HStack(spacing: 20) {
                            Image(systemName: "backward.fill")
                            Image(systemName: "play.fill")
                            Image(systemName: "forward.fill")
                        }
                        .font(.largeTitle)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }

                // Secci\u00f3n de opciones principales
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    NavigationLink(destination: ContentView()) {
                        OptionButton(icon: "list.bullet", text: "playlists")      .background(
                                ZStack {
                                    RadialGradient(
                                        gradient: Gradient(colors: [Color.red.opacity(0.2), Color.clear]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 180
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))

                                    // Agregar efecto granular
                                    Color.black.opacity(10)
                                        .blendMode(.overlay)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            )
                            .cornerRadius(15)
                    }

                    NavigationLink(destination: ContentView()) {
                        OptionButton(icon: "music.note", text: "canciones")
                            .background(
                                ZStack {
                                    RadialGradient(
                                        gradient: Gradient(colors: [Color.orange.opacity(0.2), Color.clear]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 180
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))

                                    // Agregar efecto granular
                                    Color.black.opacity(10)
                                        .blendMode(.overlay)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            )
                            .cornerRadius(15)
                    }
                    NavigationLink(destination: ContentView()) {
                        OptionButton(icon: "opticaldisc.fill", text: "albums")
                            .background(
                                ZStack {
                                    RadialGradient(
                                        gradient: Gradient(colors: [Color.yellow.opacity(0.2), Color.clear]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 180
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))

                                    // Agregar efecto granular
                                    Color.black.opacity(10)
                                        .blendMode(.overlay)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            )
                            .cornerRadius(15)
                    }
                    NavigationLink(destination: ContentView()) {
                        OptionButton(icon: "star.fill", text: "artistas")                .background(
                                ZStack {
                                    RadialGradient(
                                        gradient: Gradient(colors: [Color.green.opacity(0.2), Color.clear]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 180
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))

                                    // Agregar efecto granular
                                    Color.black.opacity(10)
                                        .blendMode(.overlay)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            )
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)

                // Secci\u00f3n de opciones inferiores
                HStack(spacing: 20) {
                    NavigationLink(destination: ContentView()) {
                        OptionButton(icon: "mic.fill", text: "memos")
                            .background(
                                ZStack {
                                    RadialGradient(
                                        gradient: Gradient(colors: [Color.cyan.opacity(0.2), Color.clear]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 70
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))

                                    // Agregar efecto granular
                                    Color.black.opacity(10)
                                        .blendMode(.overlay)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            )
                            .cornerRadius(15)
                    }
                    NavigationLink(destination: ContentView()) {
                        OptionButton(icon: "heart.fill", text: "favoritos")
                            .background(
                                ZStack {
                                    RadialGradient(
                                        gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.clear]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 70
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))

                                    // Agregar efecto granular
                                    Color.black.opacity(10)
                                        .blendMode(.overlay)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            )
                            .cornerRadius(15)
                    }
                    NavigationLink(destination: ContentView()) {
                        OptionButton(icon: "cart.fill", text: "tienda")
                            .background(
                                ZStack {
                                    RadialGradient(
                                        gradient: Gradient(colors: [Color.pink.opacity(0.2), Color.clear]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 70
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))

                                    // Agregar efecto granular
                                    Color.black.opacity(10)
                                        .blendMode(.overlay)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            )
                            .cornerRadius(15)
                    }
                    NavigationLink(destination: ContentView()) {
                        OptionButton(icon: "person.2.fill", text: "amigos")
                            .background(
                                ZStack {
                                    RadialGradient(
                                        gradient: Gradient(colors: [Color.brown.opacity(0.2), Color.clear]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 70
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))

                                    // Agregar efecto granular
                                    Color.black.opacity(10)
                                        .blendMode(.overlay)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            )
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

struct OptionButton: View {
    var icon: String
    var text: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.black)

            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .cornerRadius(15)
    }
}

struct MusicPodHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPodHomeView()
    }
}
