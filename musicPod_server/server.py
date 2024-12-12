from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse, JSONResponse
from typing import List, Dict
import os
import json

app = FastAPI()

# Rutas de los archivos de música y portada
MUSIC_FOLDER = '../musicPod_server/music'
ALBUM_ART_FOLDER = '../musicPod_server/music/albumart'

@app.get("/music", response_model=List[Dict[str, str]])
def get_songs():
    songs = []
    for filename in os.listdir(MUSIC_FOLDER):
        if filename.endswith('.mp3') or filename.endswith('.m4a'):
            title = filename.split('.')[0]
            metadata_file = os.path.join(MUSIC_FOLDER, f"{title}.json")
            song_data = {
                'title': title,
                'file_name': filename,
                'artist': "Unknown Artist",
                'albumArt': ""
            }
            if os.path.isfile(metadata_file):
                with open(metadata_file, 'r') as f:
                    metadata = json.load(f)
                    song_data['artist'] = metadata.get('artist', "Unknown Artist")
                    album_art_path = metadata.get('albumArt')
                    if album_art_path:
                        # Actualiza el albumArt para apuntar al URL del servidor
                        album_art_name = os.path.basename(album_art_path)
                        song_data['albumArt'] = f"http://localhost:5000/albumart/{album_art_name}"
            songs.append(song_data)
    return JSONResponse(content=songs)

@app.get("/albumart/{album_art_name}")
def get_album_art(album_art_name: str):
    file_path = os.path.join(ALBUM_ART_FOLDER, album_art_name)
    if os.path.isfile(file_path):
        return FileResponse(file_path, media_type="image/jpeg")
    else:
        raise HTTPException(status_code=404, detail="Album art not found")

@app.get("/music/{filename}")
def download_song(filename: str):
    file_path = os.path.join(MUSIC_FOLDER, filename)
    if os.path.isfile(file_path):
        return FileResponse(file_path, media_type='audio/mpeg', filename=filename)
    else:
        raise HTTPException(status_code=404, detail="File not found")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)
