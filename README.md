# Pet Virtual App

<p align="center">
  <img src="Pet_virtual_front/assets/images/mascota.png" alt="Mascota" width="200">
</p>

**Pet Virtual App** es un ecosistema digital diseñado para la interacción y gestión de una mascota virtual. Este repositorio funciona como un *monorepo* que centraliza tanto la lógica de servidor (Backend) como la interfaz de usuario móvil (Frontend).

Además de Mostrar un espacio de Gráficas y Datos de pruebas (benchMarks).

El sistema integra capacidades de Inteligencia Artificial (RAG) con una arquitectura moderna y escalable basada en microservicios y aplicaciones nativas compiladas.

---

## 🛠️ Tecnologías Utilizadas

### Frontend (Flutter)
- **Flutter** - Framework multiplataforma para aplicaciones móviles
- **Rive** - Animaciones interactivas para la mascota virtual
- **Provider** - Gestión de estado
- **Dio** - Cliente HTTP para comunicación con el backend
- **FL Chart** - Visualización de gráficas emocionales

### Backend (Python)
- **FastAPI** - Framework web de alto rendimiento para APIs REST
- **LangChain** - Orquestación de LLMs y gestión de prompts
- **LangGraph** - Grafos de estado para flujos conversacionales
- **ChromaDB** - Base de datos vectorial para el sistema RAG
- **OpenAI GPT-4o-mini** - Modelo de lenguaje para generación de respuestas
- **SQLAlchemy** - ORM para persistencia de datos
- **Sentence Transformers** - Embeddings para búsqueda semántica

---

## 📂 Estructura del Proyecto

El código fuente está organizado en dos directorios principales. Para detalles sobre instalación, configuración de variables de entorno y ejecución local, por favor consulta el `README.md` específico dentro de cada carpeta.

```text
.
├── benchmarks/ 
├── petBackend/           # Lógica del servidor, APIs y Sistema RAG (Python)
├── pet_virtual_front/    # Aplicación móvil multiplataforma (Flutter)
├── README.md             # Documentación general
└── .gitIgnore            # Archivos ignorados
```

---

## 🚀 Clonar el Proyecto

```bash
# HTTPS
git clone https://github.com/Kevin2001Acosta/pet-virtual-app.git

# SSH
git clone git@github.com:Kevin2001Acosta/pet-virtual-app.git
```

```bash
cd pet-virtual-app
```

> 📌 Consulta el `README.md` de cada subcarpeta para instrucciones de instalación y ejecución.

---

## 👤 Autores

- **Kevin Acosta** - [@Kevin2001Acosta](https://github.com/Kevin2001Acosta)
- **Andrea Cifuentes** - [@AndreaCifuentess](https://github.com/AndreaCifuentess)
