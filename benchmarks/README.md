# Benchmarks - Pruebas de Rendimiento y Evaluación

Este directorio contiene las pruebas de rendimiento y evaluación del chatbot UniPet, incluyendo análisis de tiempos de respuesta y evaluaciones de calidad mediante el método **LLM-as-a-Judge**.

---

## 📋 Requisitos Previos

- **Python**: 3.11 o superior
- **pip**: Gestor de paquetes de Python
- **Jupyter Notebook** o **VS Code** con extensión de Jupyter

---

## 🚀 Instalación y Configuración

### 1. Navegar a la Carpeta de Benchmarks

```bash
cd benchmarks
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

### 5. Ejecutar los Notebooks

Abre los notebooks en VS Code o Jupyter:

```bash
jupyter notebook
```

---

## 📁 Estructura del Proyecto

```text
benchmarks/
├── speed_test/                    # Pruebas de rendimiento
│   ├── data/                      # Datos de prueba (.xlsx)
│   ├── notebooks/                 # Análisis de tiempos de respuesta
│   └── plots/                     # Gráficas generadas
│
├── test_just_as_a_judge/          # Evaluación LLM-as-a-Judge
│   ├── data/                      # Resultados de evaluaciones (.xlsx)
│   ├── notebooks/                 # Análisis de fundamentación y relevancia
│   └── plots/                     # Gráficas de métricas
│
├── emotion_model_comparison/      # Comparación de modelos de emociones
│   ├── data/                      # Datasets de emociones (.csv)
│   ├── notebooks/                 # Análisis comparativo de modelos
│   └── plots/                     # Visualizaciones comparativas
│
├── requirements.txt               # Dependencias del proyecto
└── README.md
```

> 📊 **Nota:** Los archivos Excel (`.xlsx`) y CSV contienen los datos crudos de las pruebas realizadas, permitiendo reproducir los análisis.

---

## 🧪 Descripción de las Pruebas

### ⚡ Prueba de Rendimiento (`speed_test/`)

Evaluación del tiempo de respuesta del chatbot utilizando **20 preguntas independientes** enviadas secuencialmente vía HTTP.

**Métricas calculadas:**
- Tiempo promedio de respuesta
- Tiempo mínimo y máximo
- Distribución de tiempos

**Resultado destacado:** El tiempo promedio de respuesta fue de **4.57 segundos**, dentro del rango aceptable según los estudios de Robert B. Miller sobre interacción humano-computadora, donde usuarios toleran hasta 4.6 segundos en tareas complejas.

---

### 🧑‍⚖️ LLM-as-a-Judge (`test_just_as_a_judge/`)

Método de evaluación donde un modelo de lenguaje avanzado (**GPT-4o**) actúa como juez para evaluar las respuestas del chatbot.

#### Fundamentación (Grounding)

Verifica que las respuestas estén respaldadas por el contexto RAG proporcionado.

| Métrica | Valor |
|---------|-------|
| Escala | 0 - 5 |
| Promedio | 2.55 |

> **Nota:** Las puntuaciones bajas corresponden a interacciones con emociones positivas, donde el RAG no es necesario ya que está diseñado para situaciones de deterioro emocional.

#### Relevancia (Relevance)

Evalúa qué tan alineada está la respuesta con la intención del usuario y la emoción detectada.

| Métrica | Valor |
|---------|-------|
| Escala | 0 - 5 |
| Promedio | **4.8** |

> El alto puntaje de relevancia confirma que el chatbot responde apropiadamente según el contexto emocional, priorizando empatía en emociones positivas sobre el uso del RAG.

---

### 🎭 Comparación de Modelos de Emociones (`emotion_model_comparison/`)

Evaluación comparativa de modelos pre-entrenados para el reconocimiento de emociones en texto. La selección del modelo es crítica para:

- Detectar el estado anímico del estudiante en tiempo real
- Adaptar respuestas empáticas al contexto emocional
- Identificar momentos que requieren escalamiento a apoyo profesional

#### Modelos Evaluados

| Modelo | Arquitectura | F1 Score | Idioma |
|--------|--------------|----------|--------|
| **PySentimiento** | RoBERTuito (RoBERTa) | 68.9% | Español, Inglés, Italiano, Portugués |
| **monologg/bert-base-cased-goemotions-ekman** | BERT | 62.38% | Inglés |
| **Daveni/twitter-xlm-roberta-emotion-es** | XLM-RoBERTa | **71.70%** | Español |

#### Descripción de Modelos

**PySentimiento**
- Biblioteca Python multilingüe de código abierto
- Construida sobre HuggingFace Transformers
- Utiliza RoBERTuito para español (basado en RoBERTa)

**monologg/bert-base-cased-goemotions-ekman**
- Basado en BERT con taxonomía de Paul Ekman
- Entrenado con GoEmotions (58,000 comentarios de Reddit)
- Clasifica 6 emociones básicas + neutral

**Daveni/twitter-xlm-roberta-emotion-es**
- Arquitectura XLM-RoBERTa-base
- Entrenado en 198 millones de tweets
- 🏆 1er lugar en EmoEvalEs@IberLEF 2021
- Clasifica: ira, disgusto, miedo, alegría, tristeza, sorpresa, otros

---

### 📊 Ejemplo de Evaluación

| Componente | Contenido |
|------------|-----------|
| **Entrada usuario** | "Saqué buena nota en la expo, valió la pena trasnochar." |
| **Respuesta chatbot** | "¡Qué bien! Felicitaciones por esa buena nota... ¿Tienes algún plan para celebrar tu éxito? 🎉✨" |
| **Fundamentación** | 0.5 (No requiere RAG para emociones positivas) |
| **Relevancia** | 5.0 (Respuesta empática y apropiada) |

---

## 📈 Gráficas Generadas

Las visualizaciones se encuentran en las carpetas `plots/` de cada prueba:

- `speed_test/plots/` - Distribución de tiempos, estadísticas
- `test_just_as_a_judge/plots/` - Métricas de fundamentación y relevancia
- `emotion_model_comparison/plots/` - Comparación de modelos de emociones
