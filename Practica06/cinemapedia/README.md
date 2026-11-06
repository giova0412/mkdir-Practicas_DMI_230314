<div align="center">

# Cinemapedia

**Tu enciclopedia de cine, con estilo neón.**

Descubre películas de acción y aventura, revisa el detalle de cada una y guarda tus favoritas,
en 5 idiomas.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Estado-Riverpod-00E5FF)
![Plataformas](https://img.shields.io/badge/Plataformas-Windows%20%7C%20Android%20%7C%20iOS-00838F)
![Idiomas](https://img.shields.io/badge/Idiomas-ES%20%7C%20EN%20%7C%20DE%20%7C%20ZH%20%7C%20AR-7DF9FF)

</div>

## Sobre la app

**Cinemapedia** es una aplicación de películas hecha con Flutter que consume la API de
[The Movie DB](https://www.themoviedb.org/). Muestra un catálogo de películas con el detalle de
cada una, incluyendo reparto, tráilers y películas similares.

La app está disponible en **5 idiomas** (español de México, inglés, alemán, chino y árabe) y se
cambia desde el menú lateral: se traducen tanto los textos de la app como los datos de las
películas que llegan de la API.

> **Identidad visual propia:** tema **cian neón sobre negro**, logo de **aro con botón de play**,
> banderas de idioma y clasificaciones de edad **circulares**. El catálogo se arma con películas de
> **acción y aventura**.

## Capturas

> **Nota:** las capturas se agregarán más adelante. Colócalas en `assets/images/` con los nombres
> sugeridos abajo y descomenta las tablas.

<!--
<div align="center">

| Pantalla de carga | Inicio | Menú lateral |
| :---: | :---: | :---: |
| <img src="assets/images/load.png" alt="Pantalla de carga" width="215" /> | <img src="assets/images/home.png" alt="Inicio" width="215" /> | <img src="assets/images/menu.png" alt="Menú lateral" width="215" /> |

| Detalle de película | Elenco | Favoritos |
| :---: | :---: | :---: |
| <img src="assets/images/detail.png" alt="Detalle" width="215" /> | <img src="assets/images/cast.png" alt="Elenco" width="215" /> | <img src="assets/images/favorites.png" alt="Favoritos" width="215" /> |

</div>
-->

## Funcionalidades

- **Pantalla de carga animada:** el logo (aro con botón de play) se dibuja sobre fondo negro,
  aparece el nombre y hace zoom hacia la pantalla principal. Mientras cargan las películas, el logo
  late en el centro de la pantalla.
- **Carrusel de estrenos** con autoplay, flechas para cambiar de película y, sobre cada imagen,
  el título con una descripción corta.
- **Listas horizontales** con scroll infinito: _En cines_, _Próximamente_ y _Mejor calificadas_.
- **Populares** en una vista de cuadrícula tipo masonry.
- **Detalle de película:** sinopsis, géneros, reparto, tráilers de YouTube, películas similares y
  clasificación de edad según el país del idioma elegido (ver [Clasificación de edad](#clasificación-de-edad)).
- **Búsqueda** de películas con sugerencias en tiempo real.
- **Favoritos** guardados en el dispositivo (base de datos local con Isar).
- **Menú lateral** que se abre con el botón de la barra o deslizando desde el borde de la pantalla.
- **Selector de idioma** con banderas circulares: español, inglés, alemán, chino y árabe
  (ver [Idiomas de la app](#idiomas-de-la-app)).
- **Tema oscuro** con fondo negro puro y acentos **cian neón**.

## Catálogo

Para dar una identidad distinta, el catálogo no usa las listas genéricas de estrenos. Se arma con
el endpoint `/discover/movie` de The Movie DB filtrando por los géneros **Acción (28)** o
**Aventura (12)**, de modo que las secciones muestran películas de acción (muchas con coches y
persecuciones). Cada sección conserva su significado original:

| Sección | Orden |
| ------- | ----- |
| En cines | Acción y aventura estrenadas recientemente (hasta hoy) |
| Próximamente | Acción y aventura que se estrenan a partir de hoy |
| Mejor calificadas | Acción y aventura mejor calificadas de todos los tiempos |
| Populares | Acción y aventura ordenadas por popularidad |

La búsqueda, las películas similares y los favoritos siguen funcionando igual que siempre.

## Idiomas de la app

Al elegir un idioma en el menú lateral cambia **todo**: los textos de la app (menú inferior,
secciones, búsqueda, favoritos, pantalla de carga, detalle) y los datos de la API (títulos,
sinopsis, géneros, reparto y tráilers). Las películas se recargan solas con el nuevo idioma.

| Bandera | Idioma  | Código API |
| :-----: | ------- | :--------: |
|    MX   | Español |  `es-MX`   |
|    US   | English |  `en-US`   |
|    DE   | Deutsch |  `de-DE`   |
|    CN   | 中文      |  `zh-CN`   |
|    EG   | العربية |  `ar-EG`   |

- **Banderas circulares:** cada bandera se dibuja en código (`CustomPainter`) con forma redonda y
  un borde cian.
- **Respaldo en inglés:** si una película no tiene traducción en el idioma elegido, The Movie DB
  devuelve el título original y la sinopsis vacía. En ese caso la app pide también la versión en
  inglés y la usa como respaldo.
- **Diseño de izquierda a derecha:** la pantalla no se voltea, ni siquiera en árabe.
- **Fechas:** el formato de fecha del detalle y la etiqueta del día en _En cines_ siguen el idioma elegido.
- El idioma elegido no se guarda: al cerrar la app vuelve a español (MX).
- Los favoritos conservan el título y la sinopsis en el idioma en que se guardaron.

<details>
<summary><b>Cómo agregar otro idioma</b></summary>

<br />

1. Agrégalo a la lista `AppLanguages.all` en `lib/config/i18n/app_language.dart`.
2. Agrega sus textos en `lib/config/i18n/app_strings.dart` (mapa `_values` y lista `supportedCodes`).
3. Si usa una bandera nueva, dibújala en `lib/presentation/widgets/shared/flag_icon.dart`.

</details>

## Clasificación de edad

En el detalle de cada película, debajo de la fecha de estreno, se muestra la clasificación de edad
**del país del idioma elegido**. La etiqueta es un **círculo cian**: al cambiar el idioma en el menú
lateral y abrir otra película, el texto cambia al sistema de clasificación de ese país.

| País | Sistema | Cómo se ve |
| :--: | ------- | ---------- |
| MX | Clasificación mexicana | `AA`, `A`, `B`, `B15`, `C`, `D` |
| US | MPA | `G`, `PG`, `PG-13`, `R`, `NC-17` |
| DE | FSK | `FSK 0`, `FSK 6`, `FSK 12`, `FSK 16`, `FSK 18` |
| CN / EG | Sin dato en The Movie DB (normalmente) | `NR` |

- **De dónde sale:** de `/movie/{id}/release_dates` de The Movie DB. Se toma la clasificación del
  país y se prefiere la del estreno en cines.
- **Sin clasificación:** si el país no tiene dato (o la película es muy nueva), se muestra **NR**
  (sin clasificar).
- **Dónde está en el código:** `getCertification` en `moviedb_datasource.dart`, el provider
  `movie_certification_provider.dart` y el formato en `lib/config/helpers/age_rating.dart`.

## Logo

El logo de Cinemapedia es un **aro cian con un botón de reproducción (play)** dentro. Es el mismo
dibujo en toda la app: barra superior, menú lateral y pantalla de carga. Se dibuja en código con
`CustomPainter` (`lib/presentation/widgets/shared/cinemapedia_logo.dart`), por eso se ve nítido a
cualquier tamaño y no depende de ninguna imagen externa.

## Paleta de colores

| Color               |    Hex    | Uso |
| :------------------ | :-------: | :-- |
| **Cian base**       | `#00E5FF` | Color de la marca y semilla del tema |
| **Cian oscuro**     | `#00838F` | Segmento bajo del aro y detalles |
| **Cian neón claro** | `#7DF9FF` | Acentos, color principal de la interfaz (puntos del carrusel, barra inferior, corazón de favoritos) |
| **Negro**           | `#000000` | Fondo de la app, de la pantalla de carga y de la barra superior |
| **Blanco**          | `#FFFFFF` | Textos e iconos sobre fondo oscuro |

> Los colores están centralizados en `lib/config/theme/app_theme.dart` (`AppTheme`).

## Tecnologías

| Para qué             | Paquete                          |
| -------------------- | -------------------------------- |
| Estado               | `flutter_riverpod`               |
| Navegación           | `go_router`                      |
| Peticiones HTTP      | `dio`                            |
| Base de datos local  | `isar_community`                 |
| Carrusel             | `card_swiper`                    |
| Animaciones          | `animate_do`                     |
| Cuadrícula           | `flutter_staggered_grid_view`    |
| Tráilers             | `youtube_player_flutter`         |
| Variables de entorno | `flutter_dotenv`                 |
| Fechas e idiomas     | `intl` y `flutter_localizations` |

## Arquitectura

La app se divide en capas:

- **Configuración y arranque:** tema, router, textos e idiomas (`lib/config/`).
- **Presentación y estado:** pantallas, vistas, widgets y providers de Riverpod (`lib/presentation/`).
- **Dominio:** entidades, contratos de datasources y repositorios (`lib/domain/`).
- **Infraestructura:** implementación de datasources y repositorios, modelos y mappers
  (`lib/infrastructure/`).
- **Servicios externos:** The Movie DB, imágenes de TMDB y YouTube.
- **Almacenamiento local** con Isar (favoritos).

Los providers piden las películas al repositorio, que las trae de The Movie DB y las convierte a
entidades con mappers.

## Requisitos

- **Flutter estable reciente** (Dart ^3.10, Gradle 9.3.1, AGP 9.1.0, Kotlin 2.4.0). Si tu Flutter es
  más viejo: `flutter upgrade`.
- **JDK 17 o superior** (el que trae Android Studio sirve).
- Android SDK 36 (Android Studio lo instala solo cuando se lo pide el build).
- Una API key gratuita de [The Movie DB](https://www.themoviedb.org/settings/api).

## Cómo ejecutarlo

1. Crea un archivo `.env` en la raíz del proyecto con tu API key:
   ```
   THE_MOVIEDB_KEY=tu_api_key
   ```
2. Instala las dependencias:
   ```
   flutter pub get
   ```
3. Ejecútalo en Windows, en un emulador o en tu celular (con depuración USB activada):
   ```
   flutter devices
   flutter run
   ```

> **La web no está soportada:** Isar no corre en navegador.

## Generar el APK

Desde la raíz del proyecto, en PowerShell, este comando genera el APK y lo copia al escritorio como
`Cinemapedia.apk`:

```powershell
flutter build apk --release; if ($?) { Copy-Item build\app\outputs\flutter-apk\app-release.apk "$([Environment]::GetFolderPath('Desktop'))\Cinemapedia.apk" -Force }
```

El archivo original queda en `build/app/outputs/flutter-apk/app-release.apk`.

> El `.env` va dentro del APK, así que no lo subas a una tienda pública. Además, el APK sale
> firmado con la llave de depuración: sirve para instalarlo y mostrarlo, no para publicarlo.

## Créditos

- Datos de películas: [The Movie DB](https://www.themoviedb.org/). Esta app usa la API de TMDB
  pero no está avalada ni certificada por TMDB.
