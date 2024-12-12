# musicPodXcodeRepo
Archivos del proyecto original de Xcode musicPod.
````zsh
/MusicPod
````

## Iniciar en modo local el servidor de música de MusicPod:

### Requisitos:
* FastAPI (uvicorn)
* Ngrok (a través de homebrew)

#### Paso 1:
````zsh
cd /musicPod_server
````
- Entrar a una terminal dentro de la carpeta del servidor.

#### Paso 2:
````zsh
export PATH="$PATH:$(python3 -m site --user-base)/bin"
````
- Exporta lo necesario para que fastapi y uvicorn funcionen correctamente.

#### Paso 3:
````zsh
brew install ngrok/ngrok/ngrok
````
- Ngrok permitirá el ingreso de solicitudes a la API a través de Internet.

#### Paso 4:
````zsh
uvicorn server:app --host 0.0.0.0 --port 5001
````
- El comando inicia 'server.py' que permite al host 0.0.0.0, a través del puerto 5001, procesar la solicitudes que se le hagan a la API.

#### Paso 5:
````zsh
ngrok http 5001
````
- El comando inicial el túnel para permitir la solicitudes a nuestra API a través de Internet.

#### Paso 5:
````zsh
Forwarding   https://abcd1234.ngrok.io -> http://localhost:5000
````
- Ngrok proporciona un enlace después de Forwarding, por el cual podremos acceder a la API desde Internet.
