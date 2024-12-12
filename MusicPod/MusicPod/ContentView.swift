//
//  SwiftUIView.swift
//  MusicPod
//
//  Created by eduardo caballero on 10/16/24.
//

import SwiftUI
import AVFoundation
import AVKit
import Foundation

// Modelo de la canción
struct Song: Decodable, Identifiable {
    var id = UUID()
    let title: String
    let fileName: String
    let artist: String?
    let albumArt: String?

    enum CodingKeys: String, CodingKey {
        case title
        case fileName = "file_name"
        case artist
        case albumArt = "album_art"
    }
}

// Función para obtener las canciones desde un servidor
func fetchSongs(completion: @escaping ([Song]?) -> Void) {
    let url = URL(string: "https://415c-2806-105e-5-b33a-a554-7eb2-3188-2e9.ngrok-free.app/music/")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error fetching songs: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }

        do {
            let songs = try JSONDecoder().decode([Song].self, from: data)
            completion(songs)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}

func downloadSong(fileName: String, completion: @escaping (URL?) -> Void) {
    let url = URL(string: "https://415c-2806-105e-5-b33a-a554-7eb2-3188-2e9.ngrok-free.app/music/\(fileName)")!
    
    URLSession.shared.downloadTask(with: url) { localURL, response, error in
        guard let localURL = localURL, error == nil else {
            print("Error downloading song: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        completion(localURL)
    }.resume()
}

// Clase para manejar la reproducción de audio
class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var progress: Double = 0.0
    @Published var currentSong: Song? = nil
    @Published var errorMessage: String? = nil

    var timer: Timer?
    var songs: [Song]
    var currentIndex: Int = 0
    
    init(songs: [Song]) {
        self.songs = songs
    }
    
    func playSong(_ song: Song) {
        downloadSong(fileName: song.fileName) { [weak self] localURL in
            guard let self = self, let localURL = localURL else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error descargando la canción: \(song.title)"
                }
                return
            }
            
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: localURL)
                self.audioPlayer?.play()
                DispatchQueue.main.async {
                    self.currentSong = song
                    self.isPlaying = true
                    self.progress = 0.0
                    self.startTimer()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al reproducir la canción: \(song.title)"
                }
            }
        }
    }

    func pauseSong() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }

    func seekToTime(_ newProgress: Double) {
        if let player = audioPlayer {
            player.currentTime = player.duration * newProgress
            progress = newProgress
        }
    }

    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let player = self.audioPlayer {
                DispatchQueue.main.async {
                    self.progress = player.currentTime / player.duration
                    if player.currentTime >= player.duration {
                        self.nextSong()
                    }
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func nextSong() {
        if !songs.isEmpty {
            currentIndex = (currentIndex + 1) % songs.count
            playSong(songs[currentIndex])
        }
    }

    func previousSong() {
        if !songs.isEmpty {
            currentIndex = (currentIndex - 1 + songs.count) % songs.count
            playSong(songs[currentIndex])
        }
    }
}

// Vista del Mini Player
struct MiniPlayer: View {
    @ObservedObject var audioPlayer: AudioPlayer
    @State private var isExpanded = false
    
    var body: some View {
        if let currentSong = audioPlayer.currentSong {
            VStack {
                HStack {
                    songInfoView(for: currentSong)
                    controlsView()
                }
                .padding()
                progressView()
                Spacer()
            }
            .background(Color(.black))
            .cornerRadius(30)
            .padding()
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            .frame(maxHeight: isExpanded ? .infinity : 90)
            .transition(.move(edge: .bottom))
        }
    }
    
    // Método para mostrar el arte del álbum
    private func albumArtView(for song: Song) -> some View {
        Group {
            if let urlString = song.albumArt, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Muestra un indicador de carga
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                            .clipped()
                    case .failure(_):
                        Image("defaultAlbumArt")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                    @unknown default:
                        Image("defaultAlbumArt")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                    }
                }
            } else {
                Image("defaultAlbumArt")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(5)
            }
        }
    }
    
    // Método para mostrar la información de la canción
    private func songInfoView(for song: Song) -> some View {
        VStack(alignment: .leading) {
            Text(song.title)
                .font(.headline)
                .foregroundColor(.white)
            Text(song.artist ?? "Unknown Artist")
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
    
    // Método para los controles del reproductor
    private func controlsView() -> some View {
        HStack {
            Button(action: {
                audioPlayer.previousSong()
            }) {
                Image(systemName: "backward.fill")
                    .resizable()
                    .frame(width: 30, height: 25)
                    .foregroundColor(.white)
            }
            Button(action: {
                if audioPlayer.isPlaying {
                    audioPlayer.pauseSong()
                } else {
                    audioPlayer.playSong(audioPlayer.currentSong!)
                }
            }) {
                Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            Button(action: {
                audioPlayer.nextSong()
            }) {
                Image(systemName: "forward.fill")
                    .resizable()
                    .frame(width: 30, height: 25)
                    .foregroundColor(.white)
            }
            AirPlayButton()
                .frame(width: 30, height: 30)
        }
    }
    
    // Método para mostrar el progreso de la canción
    private func progressView() -> some View {
        Slider(value: Binding(
            get: { audioPlayer.progress },
            set: { audioPlayer.seekToTime($0) }
        ))
        .padding(.horizontal)
    }
}

// Botón de AirPlay
struct AirPlayButton: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let view = AVRoutePickerView()
        view.activeTintColor = .blue
        view.tintColor = .white
        return view
    }

    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {}
}


struct ContentView: View {
    @StateObject var audioPlayer = AudioPlayer(songs: [])
    @State private var showAlert = false
    @State private var groupedSongs: [String: [Song]] = [:]
    @State private var showDetailsView = false
    
    var body: some View {

        ZStack(alignment: .bottom) {
            NavigationStack {
                List {
                    ForEach(groupedSongs.keys.sorted(), id: \.self) { artist in
                        Section(header: Text(artist)) {
                            ForEach(groupedSongs[artist]!) { song in
                                songRow(song)
                            }
                        }
                    }
                }
                .navigationTitle("Canciones")
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"),
                          message: Text(audioPlayer.errorMessage ?? "Error desconocido"),
                          dismissButton: .default(Text("OK")))
                }
                .onChange(of: audioPlayer.errorMessage) {
                    showAlert = audioPlayer.errorMessage != nil
                }
                .onAppear {
                    fetchSongs { songs in
                        if let songs = songs {
                            DispatchQueue.main.async {
                                audioPlayer.songs = songs
                                groupedSongs = Dictionary(grouping: songs, by: { $0.artist ?? "Unknown Artist" })
                            }
                        }
                    }
                }
                Button("Sonando"){
                    showDetailsView = true
                }
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(20)
                .frame(maxWidth: 130)
                .background(Color.blue)
                .cornerRadius(30)
                .sheet(isPresented: $showDetailsView){
                    Text("Sonando ahora:")
                        .padding(.top, 0)
                        .presentationCornerRadius(50)
                    MiniPlayer(audioPlayer: audioPlayer)
                        .frame(height: 80)
                        .padding(.top, 20)
                        .presentationDetents([.height(180)])
                        .presentationCornerRadius(50)
                }
            }

        }
    }
    
    // Método para mostrar la fila de una canción
    private func songRow(_ song: Song) -> some View {
        HStack {
            songInfoView(for: song)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            audioPlayer.playSong(song)
        }
        .padding(.vertical, 0)
    }
    
    // Métodos para cargar el arte del álbum y la información de la canción (similares a los de MiniPlayer)
    private func albumArtView(for song: Song) -> some View {
        Group {
            if let urlString = song.albumArt, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Muestra un indicador de carga
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                            .clipped()
                    case .failure(_): // No necesitas capturar el error
                        Image("defaultAlbumArt")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                    @unknown default:
                        Image("defaultAlbumArt")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                    }
                }
            } else {
                Image("defaultAlbumArt")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(5)
            }
        }
    }

    
    private func songInfoView(for song: Song) -> some View {
        VStack(alignment: .leading) {
            Text(song.title)
                .font(.headline)
            Text(song.artist ?? "Unknown Artist")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
