# Repositorio de Prácticas para la Asignatura de Desarrollo Móvil Integral

**Ingeniería en Desarrollo y Gestión de Software**

📌 **Alumno:** T.S.U. Giovany Raúl Pazos Cruz  
👨‍🏫 **Docente:** M.T.I. Marco A. Ramírez Hernández  
📅 **Periodo:** Septiembre - Diciembre 2026  

---

## 🛠️ Tecnologías Utilizadas

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Codex](https://img.shields.io/badge/Codex-000000?style=for-the-badge&logo=openai&logoColor=white)
![Archify](https://img.shields.io/badge/Archify-3B82F6?style=for-the-badge&logo=diagramsdotnet&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![VS Code](https://img.shields.io/badge/VS%20Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)

---

## 📝 Descripción

Este repositorio contendrá los resultados de las prácticas de la materia para tener una mejor organización y agilizar la revisión de las mismas.

---

## 📊 Tabla de Prácticas

### Tabla de Prácticas de la Materia

| No. | Nombre | Descripción | Ponderación | Estatus |
| :-: | :--- | :--- | :-: | :-: |
| **1** | Metodología de Evaluación de la Materia | Transcribir en libreta y comprender la metodología y fechas de evaluación de la asignatura | 5% | 🟢 Concluida |
| **2** | [Mi Primer Aplicación Móvil con Flutter](./Practica2/flutter_application_1) | Codificar la app móvil en el framework de Flutter manejando Stateless y Stateful Widgets | 25% | 🟢 Concluida |
| **3** | [Aplicación Móvil Flutter - Chat App](./Practica03/flutter_application_2) | Desarrollo de interfaz de chat interactiva utilizando widgets personalizados en Flutter | 25% | 🟢 Concluida |
| **4** | [Aplicación Móvil Flutter - TokTik VidFlow](./Practica04/toktik) | Clon de TikTok con feed vertical, reproducción con controles, likes persistentes y arquitectura limpia con Provider + Repository + DataSources | 25% | 🟢 Concluida |

---

## 📱 Publicación de la App en Appetize.io (TokTik VidFlow)

Publicación para demostración y pruebas (no distribución comercial) de [TokTik VidFlow](./Practica04/toktik) en dispositivos Android virtuales desde el navegador, sin instalar nada en físico.

### Comandos utilizados

```bash
# Validación previa: análisis y pruebas (6/6 pass)
flutter analyze
flutter test

# Compilación del ejecutable
flutter build apk --release
```

### Archivo APK generado

| Dato | Valor |
| :--- | :--- |
| Ruta | `Practica04/toktik/build/app/outputs/flutter-apk/app-release.apk` |
| Tamaño | 403.6 MB |
| SHA-1 | `83522bb78dad4c376907dd24b8ca0829208b67e6` |
| Versión | 1.0.0+1 (`pubspec.yaml`) |
| Application ID | `com.example.toktik` |
| Permisos | INTERNET (streaming de MP4 de Pixabay/Giphy/Vimeo) |

> El APK **no** se versiona en git: supera el límite de 100 MB por archivo de GitHub. El 86% del peso (~347 MB) son los 8 videos de muestra en `assets/videos/` usados como datasource local sin internet. Se distribuye únicamente vía Appetize.

### Publicación en Appetize (pasos)

1. Crear cuenta en [appetize.io](https://appetize.io) y abrir el dashboard.
2. Subir `app-release.apk` (arrastrar al dashboard o vía API):
   ```bash
   curl -X POST https://api.appetize.io/v1/apps \
     -u "TOKEN:" -F "file=@app-release.apk" -F "platform=android"
   ```
3. Elegir dispositivo virtual (ej. Pixel 8 · Android 14 y Galaxy A54 · Android 13) y orientación vertical.
4. Iniciar la sesión desde el navegador y ejecutar las pruebas funcionales.

### 🔗 Enlace de acceso

> **Enlace Appetize:** *(pendiente — pegar aquí el link `https://appetize.io/app/XXXX` tras publicar el APK)*

### Pruebas funcionales (checklist)

- [ ] Pantalla inicial carga el feed vertical sin errores.
- [ ] Solo el video visible se reproduce; al desplazar cambia el activo.
- [ ] Controles visibles: play/pausa, tiempo actual/total y barra para adelantar.
- [ ] Tabs Discover / For You / Favorites navegan correctamente.
- [ ] Like persiste (cerrar y reabrir conserva favoritos).
- [ ] Cambio de tema por temporada aplica logos y colores.

### Pruebas en 2 dispositivos

| Dispositivo | SO | Resultado |
| :--- | :--- | :--- |
| Pixel 8 (vertical) | Android 14 | *(pendiente de sesión Appetize)* |
| Galaxy A54 (vertical) | Android 13 | *(pendiente de sesión Appetize)* |

### Incidencias conocidas

- APK pesado (403.6 MB) por videos locales; no afecta a Appetize pero la subida tarda. Alternativa si falla la carga: `flutter build apk --release --split-per-abi` y subir el `app-arm64-v8a-release.apk`.
- En emulador local, videos 4K de Pixabay excedían el decoder (ver README de la práctica); en Appetize se usan MP4 livianos `tiny/small`.

---

<p align="center">
  <i>Desarrollado por <b>Giovany Raúl Pazos Cruz</b> - 2026</i>
</p>