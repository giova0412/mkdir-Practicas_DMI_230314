# Manual de Instalación y Configuración del Entorno de Desarrollo Móvil Multiplataforma

## Datos de la Entrega

| Dato | Valor |
| :--- | :--- |
| **Título** | Manual de Instalación y Configuración del Entorno de Desarrollo Móvil Multiplataforma |
| **Documento** | [`Manual.pdf`](./Manual.pdf) (PDF original, ~9.6 MB) |
| **Autor** | T.S.U. Giovany Raúl Pazos Cruz |
| **Docente** | M.T.I. Marco A. Ramírez Hernández |
| **Asignatura** | Desarrollo Móvil Integral (DMI) |
| **Repositorio backend** | <https://github.com/JFFA25/backend-entorno-dev> |

---

## Descripción General

Guía paso a paso para instalar y configurar un entorno completo de desarrollo de aplicaciones móviles con **arquitectura cliente-servidor**, **autenticación centralizada** y **despliegue contenerizado**.

El manual original (`Manual.docx`) combina la explicación teórica de cada herramienta con el procedimiento técnico y las capturas de pantalla del proceso realizado.

### Stack tecnológico

| Capa | Tecnología |
| :--- | :--- |
| Frontend | Flutter (Dart) |
| Backend | FastAPI (Python), con alternativa en Node/Express |
| Autenticación | Keycloak (OAuth 2.0 / OpenID Connect, tokens JWT) |
| Bases de datos | PostgreSQL (relacional) y MongoDB (NoSQL) |
| Documentación de API | Swagger / OpenAPI |
| Pruebas de API | Postman |
| Contenerización | Docker y Docker Compose |
| Control de versiones | Git y GitHub |

---

## Objetivos

### Objetivo general

Instalar y configurar correctamente todas las herramientas necesarias para desarrollar una aplicación móvil multiplataforma con arquitectura cliente-servidor, autenticación centralizada y despliegue contenedorizado.

### Objetivos específicos

- Comprender el rol teórico de cada herramienta dentro de la arquitectura.
- Instalar y verificar Git, Node.js, Docker y Flutter SDK.
- Configurar contenedores de PostgreSQL, MongoDB y Keycloak con Docker Compose.
- Levantar un backend con FastAPI (o Node/Express) documentado con Swagger/OpenAPI.
- Validar la comunicación entre el backend y las bases de datos con Postman.
- Conectar la app Flutter con el backend y con Keycloak.

---

## Contenido del Manual

| Capítulo | Descripción |
| :--- | :--- |
| Introducción | Alcance del manual, objetivo general y objetivos específicos. |
| 1. Marco teórico | Arquitectura multiplataforma, Flutter y Dart, Keycloak, Swagger/OpenAPI, FastAPI y Express, PostgreSQL y MongoDB, Docker y Compose, Git y GitHub, Postman. |
| 2. Requisitos previos | Hardware y sistema operativo, cuentas necesarias y tabla de versiones recomendadas. |
| 3. Instalación de herramientas base | Git (con llave SSH y GitHub), Node.js y npm, Docker y Compose, Flutter SDK (incluye configuración del PATH en Windows), IDE con plugins y Postman. |
| 4. Configuración del backend | PostgreSQL, MongoDB, Keycloak (realm, cliente, roles y usuario de prueba), FastAPI, alternativa Node/Express, Swagger/OpenAPI y orquestación con Docker Compose. |
| 5. Configuración del frontend (Flutter) | Creación del proyecto, estructura de carpetas, paquetes para consumir la API, login con Keycloak y variables de entorno por ambiente. |
| 6. Pruebas y verificación | Endpoints con Postman, obtención y validación de JWT, Swagger UI y pruebas de la app contra el backend. |
| 7. Buenas prácticas | Manejo de variables sensibles, convenciones de commits y ramas, versionado semántico de la API. |
| 8. Solución de problemas | Tabla de problemas comunes, causas y soluciones. |
| Anexos | A. Comandos rápidos · B. docker-compose.yml completo · C. Glosario · D. Referencias. |

---

## Requisitos Previos

### Hardware y sistema operativo

- Procesador de 64 bits con virtualización habilitada en BIOS/UEFI.
- Mínimo 8 GB de RAM (recomendado 16 GB).
- Al menos 15 GB libres en disco.
- Windows 10/11, macOS o Linux (Ubuntu recomendado).

### Cuentas

- **GitHub** (necesaria).
- **Docker Hub** (opcional).

### Versiones recomendadas

| Herramienta | Versión | Verificación |
| :--- | :--- | :--- |
| Git | 2.4x o superior | `git --version` |
| Node.js | 20.x LTS | `node -v` |
| Docker | 26.x o superior | `docker --version` |
| Docker Compose | v2 (plugin) | `docker compose version` |
| Flutter SDK | 3.2x (stable) | `flutter doctor` |
| Python | 3.11 o superior | `python --version` |
| PostgreSQL | 16.x (imagen Docker) | `psql --version` |
| MongoDB | 7.x (imagen Docker) | `mongosh --version` |
| Keycloak | 25.x (imagen Docker) | Consola web `/admin` |
| Postman | Última estable | `postman --version` |

---

## Inicio Rápido

> Antes de levantar el stack crea un archivo `.env` en la raíz con las variables obligatorias (ver [Anexo B](#anexo-b--docker-composeyml)). Sin ellas Docker Compose aborta el arranque.

```bash
# 1. Levantar PostgreSQL, MongoDB, Keycloak y la API
docker compose up -d
docker compose ps

# 2. Ver logs de la API
docker compose logs -f api

# 3. Ejecutar la app Flutter
cd app_movil
flutter pub get
flutter run
```

### Servicios y puertos

| Servicio | Puerto | URL / acceso |
| :--- | :-: | :--- |
| PostgreSQL | 5432 | `localhost:5432` |
| MongoDB | 27017 | `localhost:27017` |
| Keycloak | 8080 | <http://localhost:8080> |
| API (FastAPI) | 8000 | <http://localhost:8000> · Swagger en `/docs` · ReDoc en `/redoc` |

> 💡 En el `docker-compose.yml` del [Anexo B](#anexo-b--docker-composeyml) los servicios se publican en una sola URL (`http://localhost:8085`), con Keycloak bajo `/auth` y la API bajo `/api`; PostgreSQL y MongoDB quedan en la red privada.

> ⚠️ Las credenciales del manual (`admin` / `admin123`) son solo para desarrollo local. **No las uses en producción.**

---

## Estructura Recomendada del Proyecto Flutter

```text
lib/
├── core/           # constantes, temas, utilidades
├── data/           # modelos y servicios de datos (API, auth)
├── domain/         # lógica de negocio
├── presentation/  # pantallas y widgets
└── main.dart
```

### Variables de entorno (ejemplo `.env.dev`)

```env
API_BASE_URL=http://localhost:8000
KEYCLOAK_URL=http://localhost:8080
KEYCLOAK_REALM=app-movil
KEYCLOAK_CLIENT_ID=app-movil-client
```

---

## Paquetes Principales

| Ámbito | Paquetes |
| :--- | :--- |
| **Flutter** | `dio`, `flutter_secure_storage`, `openid_client`, `flutter_appauth` |
| **FastAPI** | `fastapi`, `uvicorn`, `python-jose`, `sqlalchemy`, `psycopg2-binary`, `pymongo` |
| **Express (alterno)** | `express`, `cors`, `dotenv`, `pg`, `mongoose`, `jsonwebtoken` |

---

## Buenas Prácticas

- Nunca subir credenciales al repositorio: usar `.env` y agregarlo a `.gitignore`.
- Ramas: `main` / `develop` (estables), `feature/...`, `fix/...`.
- Commits con *Conventional Commits*: `feat:`, `fix:`, `docs:`, `chore:`.
- Versionar las rutas de la API (por ejemplo `/api/v1/`).

---

## Problemas Comunes

| Problema | Solución rápida |
| :--- | :--- |
| Puerto en uso (5432, 8080…) | Cambiar el mapeo en `docker-compose.yml` o detener el proceso que lo ocupa. |
| `flutter doctor` con errores | `flutter doctor --android-licenses` y reinstalar componentes faltantes. |
| La app no conecta con Keycloak | Verificar que la *redirect URI* del cliente coincida exactamente con la de la app. |
| JWT rechazado por el backend | Revisar que *issuer* y *audience* coincidan con los del Realm. |
| Contenedor que se reinicia | Revisar variables de entorno y `docker compose logs -f <servicio>`. |

---

## Anexo B · `docker-compose.yml`

Archivo completo disponible en [`./docker-compose.yml`](./docker-compose.yml) (proyecto base: <https://github.com/JFFA25/backend-entorno-dev>).

### Servicios definidos

| Servicio | Imagen / build | Puerto publicado | Función |
| :--- | :--- | :-: | :--- |
| `postgres` | `postgres:17-alpine` | 5432 (red interna) | Base relacional + base de Keycloak, con `init` en `docker-entrypoint-initdb.d`. |
| `mongo` | `mongo:7` | 27017 (red interna) | Base NoSQL para documentos. |
| `keycloak` | `quay.io/keycloak/keycloak:26.8.0` | 8085 vía proxy | IAM (OAuth 2.0 / OIDC) sobre PostgreSQL, con import del realm `app-movil`. |
| `api` | build `./api` (FastAPI) | 8000 (red interna) | API REST documentada con Swagger/OpenAPI. |
| `flutter-web` | build `web/Dockerfile` (nginx) | **8085** | Único servicio publicado: sirve la web Flutter y hace *proxy* a `/api` y `/auth`. |

Todas las redes se aíslan en la red privada `private`; los volúmenes `postgres_data` y `mongo_data` persisten los datos.

### Variables de entorno obligatorias (`.env`)

```env
POSTGRES_PASSWORD=change-me
KEYCLOAK_DB_PASSWORD=change-me
MONGO_PASSWORD=change-me
KEYCLOAK_ADMIN_PASSWORD=change-me
```

| Variable | Requerida | Valor por defecto | Descripción |
| :--- | :-: | :--- | :--- |
| `POSTGRES_USER` | No | `stack_admin` | Usuario owner de PostgreSQL. |
| `POSTGRES_PASSWORD` | **Sí** | — | Contraseña del usuario de PostgreSQL. |
| `POSTGRES_DB` | No | `app_db` | Base de datos de la aplicación. |
| `MONGO_USER` | No | `stack_admin` | Usuario root de MongoDB. |
| `MONGO_PASSWORD` | **Sí** | — | Contraseña de MongoDB. |
| `KEYCLOAK_DB_PASSWORD` | **Sí** | — | Contraseña del usuario `keycloak` en PostgreSQL. |
| `KEYCLOAK_ADMIN` | No | `admin` | Administrador inicial de Keycloak. |
| `KEYCLOAK_ADMIN_PASSWORD` | **Sí** | — | Contraseña del administrador de Keycloak. |
| `PUBLIC_BASE_URL` | No | `http://localhost:8085` | URL pública (afecta `KC_HOSTNAME` y el build de Flutter web). |
| `WEB_PORT` | No | `8085` | Puerto host del servicio `flutter-web`. |

> 🔒 El archivo `.env` **nunca** se versiona; solo se comparte un `.env.example` con valores de relleno.

---

## Referencias

[Flutter](https://flutter.dev) · [Docker](https://www.docker.com) · [Keycloak](https://www.keycloak.org) · [FastAPI](https://fastapi.tiangolo.com) · [PostgreSQL](https://www.postgresql.org) · [MongoDB](https://www.mongodb.com) · [Swagger/OpenAPI](https://swagger.io) · [Postman](https://www.postman.com)

---

<p align="center">
  <i>Manual elaborado por <b>Giovany Raúl Pazos Cruz</b> - 2026</i>
</p>
