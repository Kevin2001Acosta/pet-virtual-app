# Backend de UniPet

<p align="center">
  <img src="../Pet_virtual_front/assets/images/mascota.png" alt="UniPet" width="150">
</p>

**Backend de UniPet** es una API RESTful desarrollada con **FastAPI**, un framework web de alto rendimiento en Python. El sistema implementa un chatbot inteligente potenciado por un sistema **RAG (Retrieval-Augmented Generation)** que fundamenta sus respuestas en documentos especializados.

### ¿Por qué FastAPI?
- 🚀 **Alto rendimiento** - A la par con NodeJS y Go
- 🐍 **Python nativo** - Ideal para integración con modelos de IA
- 📚 **Documentación automática** - Swagger UI generada automáticamente
- ✅ **Validación integrada** - Con Pydantic para tipado seguro

### Arquitectura
El diseño sigue una arquitectura por capas inspirada en **MVC**:
- **Rutas** → Punto de entrada de peticiones HTTP
- **Controladores** → Validación y orquestación de lógica
- **Servicios** → Reglas de negocio encapsuladas
- **Sistema RAG** → Módulo independiente para respuestas fundamentadas en documentos

---

## 📋 Requisitos Previos

- **Python**: 3.11 o superior
- **pip**: Gestor de paquetes de Python
- **PostgreSQL**: Base de datos (o conexión a una instancia remota)
- **Git**: Control de versiones

---

## 🚀 Instalación y Configuración

### 1. Navegar a la Carpeta del Proyecto

```bash
cd petBackend
```

### 2. Crear Entorno Virtual

```bash
python -m venv env
```

### 3. Activar Entorno Virtual

**Windows (PowerShell):**
```bash
.\env\Scripts\Activate.ps1
```

**Windows (CMD):**
```bash
.\env\Scripts\activate.bat
```

**Linux/macOS:**
```bash
source env/bin/activate
```

### 4. Instalar Dependencias

```bash
pip install -r requirements.txt
```

---

## ⚙️ Variables de Entorno

Crear un archivo `.env` en la raíz de `petBackend/` con las siguientes variables:

```env
# OpenAI API Key para el modelo de lenguaje
OPENAI_API_KEY=tu_api_key_de_openai

# URL de conexión a PostgreSQL
DATABASE_URL=postgresql://usuario:contraseña@host:puerto/nombre_db

# Configuración de correo (para recuperación de contraseña)
MAIL_USERNAME=tu_correo@gmail.com
MAIL_PASSWORD=contraseña_de_aplicacion
MAIL_FROM=tu_correo@gmail.com

# Clave secreta para firmar tokens JWT (usar string aleatorio seguro)
SECRET_KEY=tu_clave_secreta_para_jwt

# URL del backend (para enlaces en correos)
BACKEND_URL=http://localhost:8000
```

### 📧 Nota sobre MAIL_PASSWORD

La variable `MAIL_PASSWORD` **no es la contraseña de tu cuenta de Gmail**. Debes generar una **Contraseña de Aplicación**:

1. Ve a [Configuración de seguridad de Google](https://myaccount.google.com/security)
2. Activa la verificación en 2 pasos
3. Busca "Contraseñas de aplicaciones"
4. Genera una nueva contraseña para "Correo"
5. Usa esa contraseña de 16 caracteres en `MAIL_PASSWORD`

### 🔐 Nota sobre SECRET_KEY

La `SECRET_KEY` se utiliza para **firmar y verificar tokens JWT** (JSON Web Tokens). Estos tokens autentican a los usuarios en cada petición. Usa una cadena aleatoria segura, por ejemplo generada con:

```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

---

## ▶️ Ejecutar el Servidor

```bash
uvicorn src.main:app --host 0.0.0.0 --port 8000 --reload
```

| Parámetro | Descripción |
|-----------|-------------|
| `--host 0.0.0.0` | Permite conexiones desde cualquier IP |
| `--port 8000` | Puerto donde corre el servidor |
| `--reload` | Recarga automática al detectar cambios (desarrollo) |

### 📚 Documentación de la API

Una vez ejecutado, accede a la documentación interactiva:

- **Swagger UI**: [http://localhost:8000/docs](http://localhost:8000/docs)
- **ReDoc**: [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

## 📁 Estructura del Proyecto

```text
petBackend/
├── src/
│   ├── main.py              # Punto de entrada de la aplicación
│   ├── controllers/         # Lógica de control y validación
│   ├── database/            # Configuración de BD y modelos ORM
│   ├── models/              # Schemas Pydantic (DTOs)
│   ├── routes/              # Definición de endpoints
│   ├── services/            # Lógica de negocio
│   └── rag_system/          # Sistema RAG para el chatbot
│       ├── data/            # Documentos PDF para contexto
│       └── system/          # Core del sistema RAG
├── .env                     # Variables de entorno (no subir a git)
├── requirements.txt         # Dependencias del proyecto
├── Dockerfile               # Configuración para Docker
└── README.md
```

---

## 🐳 Docker (Opcional)

```bash
docker build -t unipet-backend .
docker run -p 8000:8000 --env-file .env unipet-backend
```
