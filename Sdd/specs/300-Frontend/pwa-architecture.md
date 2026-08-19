---
id: PWA-001
title: Arquitectura PWA (Progressive Web App)
version: 1.1.0
status: Stable
owner: Frontend Engineering & Arquitectura
last_updated: 2026-08-12
depends_on:
  - 300-Frontend/design-system.md (BDS - tokens y componentes)
  - 300-Frontend/patient-app.md (PAT - experiencia Nintendo)
  - 400-AI/ai-core.md (AI-001 - motor de inferencia)
exports:
  - Arquitectura completa de la PWA
  - Service Worker con estrategia Cache-First
  - IndexedDB para almacenamiento offline
  - Background Sync para sincronización en segundo plano
  - manifest.json para instalación
  - Guía de instalación y aterrizaje (beforeinstallprompt, instalación por plataforma, UX de instalación)
  - Capacitor.config.json para migración nativa
  - Three.js Deep Module (Pantalla3D.js)
  - Estrategia offline-first
  - Criterios de validación y métricas
used_by:
  - 300-Frontend/patient-app.md (Implementación de la app)
  - Frontend Engineers (desarrollo de la PWA)
  - QA (pruebas offline y rendimiento)
---

# BehavioralOS – Arquitectura PWA (Progressive Web App) (v1.1.0)

> *"La app del paciente debe estar siempre disponible, sin importar la conexión a internet. La PWA es el puente entre la experiencia web y la nativa, permitiendo instalación directa, funcionamiento offline y preparación para migración futura a iOS/Android."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define la **arquitectura completa de la PWA** del BehavioralOS. Su objetivo es:

- **Garantizar disponibilidad constante** mediante funcionamiento offline.
- **Habilitar instalación directa** desde el navegador sin tiendas de aplicaciones.
- **Soportar gráficos 3D** con Three.js para la experiencia Nintendo.
- **Implementar streaming SSE** para chat en tiempo real con la IA.
- **Preparar la migración futura** a aplicaciones nativas via Capacitor.
- **Optimizar rendimiento** con estrategias de caché inteligentes.

### 1.2. Alcance
El documento cubre:

- **Service Worker**: Estrategia Cache-First para assets estáticos.
- **IndexedDB**: Almacenamiento local para datos offline.
- **Background Sync**: Sincronización automática al recuperar conexión.
- **manifest.json**: Metadatos para instalación de la PWA.
- **Instalación y aterrizaje**: beforeinstallprompt, instalación por plataforma y UX de instalación (guía en patient-app).
- **Capacitor.config.json**: Configuración para migración nativa.
- **Three.js Deep Module**: Módulo de gráficos 3D (Pantalla3D.js).
- **Estrategia offline-first**: Filosofía de diseño para disponibilidad.
- **Pipeline de streaming**: PWA → SSE → Backend → Respuesta.

### 1.3. Principio Fundamental
> **"La experiencia del paciente no debe interrumpirse nunca. Sin conexión, la app sigue funcionando. Con conexión, sincroniza automáticamente. La PWA es la garantía de disponibilidad 24/7."**

---

## 2. Arquitectura de Capas

### 2.1. Visión General

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     CAPA DE INTERFAZ (UI)                               │
│       (HTML5 + CSS + TypeScript + Three.js)                            │
│                                                                       │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ │
│  │  Chat (SSE)  │ │  Atlas 3D    │ │  Misiones    │ │  Inventario  │ │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘ │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                     CAPA DE ABSTRACCIÓN (PWA)                          │
│                                                                       │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ │
│  │Service Worker│ │  IndexedDB   │ │BackgroundSync│ │  manifest    │ │
│  │(Cache-First) │ │(Offline DB)  │ │(Auto-Sync)   │ │  .json       │ │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘ │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                     CAPA DE CONECTIVIDAD                               │
│                                                                       │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ │
│  │   HTTPS      │ │  WebSocket   │ │  SSE         │ │  Capacitor   │ │
│  │  (Seguridad) │ │  (Chat)      │ │  (Streaming) │ │  (Futuro)    │ │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘ │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                     BACKEND (Servidor Privado)                         │
│                                                                       │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ │
│  │   FastAPI    │ │  vLLM/Gemma4 │ │Redis Streams │ │  PostgreSQL  │ │
│  │  (Endpoints) │ │  (Inferencia)│ │ (Eventos)    │ │  (Datos)     │ │
│  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2. Estrategia Offline-First

La PWA sigue una filosofía **offline-first**:

| Capa | Estrategia | Descripción |
|------|------------|-------------|
| **Assets estáticos** | Cache-First | Service Worker cachea HTML, CSS, JS, Three.js, sonidos |
| **Datos de usuario** | Offline-First | IndexedDB almacena datos localmente |
| **API del chat** | Network-First | Intenta red; si falla, encola en IndexedDB |
| **Streaming SSE** | Network-Only | Requiere conexión en tiempo real |
| **Sincronización** | Background Sync | Automática al recuperar conexión |

---

## 3. Service Worker

### 3.1. Estrategia Cache-First

El Service Worker implementa una estrategia **Cache-First** para assets estáticos:

```javascript
const CACHE_NAME = 'behavioralos-nintendo-v1';
const ASSETS_TO_CACHE = [
  '/',
  '/index.html',
  '/styles.css',
  '/main.js',
  '/libs/three.min.js',
  '/assets/sounds/coin.mp3',
  '/assets/sounds/levelup.mp3',
  '/assets/textures/garden/*',
  '/assets/models/character/*'
];

// Instalación: Cachear assets estáticos
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(ASSETS_TO_CACHE);
    })
  );
  self.skipWaiting();
});

// Activación: Limpiar cachés antiguas
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) return caches.delete(key);
        })
      );
    })
  );
  self.clients.claim();
});

// Interceptación de peticiones
self.addEventListener('fetch', (event) => {
  // API del chat NO se cachea (Network-First)
  if (event.request.url.includes('/api/chat/stream')) {
    return;
  }

  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      return cachedResponse || fetch(event.request);
    })
  );
});
```

### 3.2. Tabla de Estrategias por Recurso

| Recurso | Estrategia | Caché | Actualización |
|---------|------------|-------|---------------|
| HTML shell | Cache-First | Sí | Al instalar nueva versión |
| CSS/JS | Cache-First | Sí | Al detectar cambio |
| Three.js (libs) | Cache-First | Sí | Solo en nueva versión |
| Texturas 3D | Cache-First | Sí | Manual |
| Sonidos | Cache-First | Sí | Manual |
| API chat (SSE) | Network-First | No | Tiempo real |
| Datos usuario | Offline-First | IndexedDB | Background Sync |
| Imágenes avatares | Cache-First | Sí | Al actualizar |

---

## 4. IndexedDB (Base de Datos Offline)

### 4.1. Estructura de la Base de Datos

```javascript
const DB_NAME = 'PBP_Offline_DB';
const DB_VERSION = 1;

// Stores de datos
const stores = {
  'cola_mensajes': { keyPath: 'id', autoIncrement: true },
  'descubrimientos_cache': { keyPath: 'id' },
  'misiones_pendientes': { keyPath: 'id' },
  'configuracion_local': { keyPath: 'clave' },
  'behavioral_twin_cache': { keyPath: 'paciente_id' }
};
```

### 4.2. Tabla de Stores

| Store | Propósito | Datos | TTL |
|-------|-----------|-------|-----|
| `cola_mensajes` | Mensajes pendientes de sincronización | `{id, mensaje, historial, fecha}` | Hasta sincronizar |
| `descubrimientos_cache` | Descubrimientos offline | `{id, titulo, contenido, fecha}` | 30 días |
| `misiones_pendientes` | Misiones no completadas | `{id, mision, progreso}` | Hasta completar |
| `configuracion_local` | Preferencias del usuario | `{tema, idioma, notificaciones}` | Persistente |
| `behavioral_twin_cache` | Estado del Twin (copia local) | `{paciente_id, procesos, valores}` | Hasta sincronizar |

### 4.3. Operaciones CRUD Offline

```javascript
// Guardar mensaje offline
async function guardarMensajeOffline(mensaje, historial) {
  const db = await indexedDB.open(DB_NAME, DB_VERSION);
  const transaction = db.transaction('cola_mensajes', 'readwrite');
  const store = transaction.objectStore('cola_mensajes');
  store.add({
    mensaje,
    historial,
    fecha: new Date().toISOString()
  });
}

// Obtener mensajes pendientes
async function obtenerMensajesPendientes() {
  const db = await indexedDB.open(DB_NAME, DB_VERSION);
  const transaction = db.transaction('cola_mensajes', 'readonly');
  const store = transaction.objectStore('cola_mensajes');
  return store.getAll();
}

// Eliminar mensaje sincronizado
async function eliminarMensajeSincronizado(id) {
  const db = await indexedDB.open(DB_NAME, DB_VERSION);
  const transaction = db.transaction('cola_mensajes', 'readwrite');
  const store = transaction.objectStore('cola_mensajes');
  store.delete(id);
}
```

---

## 5. Background Sync

### 5.1. Concepto

Cuando el dispositivo pierde conexión, los mensajes se almacenan en IndexedDB. Al recuperar conexión, el Service Worker ejecuta automáticamente la sincronización:

```javascript
// Registro del Background Sync
self.addEventListener('sync', (event) => {
  if (event.tag === 'sincronizar-charla-pbp') {
    event.waitUntil(enviarMensajesPendientesAlServidor());
  }
});

// Función de sincronización
async function enviarMensajesPendientesAlServidor() {
  const db = await abrirIndexedDB();
  const mensajesPendientes = await obtenerMensajesGuardados(db);

  if (mensajesPendientes.length === 0) return;

  for (const item of mensajesPendientes) {
    try {
      const response = await fetch('http://localhost:8000/api/chat/stream', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          mensaje: item.mensaje,
          historial: item.historial
        })
      });

      if (response.ok) {
        await borrarMensajeDeIndexedDB(db, item.id);
      }
    } catch (error) {
      break; // Detener si el servidor falla
    }
  }
}
```

### 5.2. Flujo Completo

```
[Dispositivo offline]
         │
         ▼
[Guardar en IndexedDB]
         │
         ▼
[Esperar reconexión]
         │
         ▼
[Service Worker detecta sync event]
         │
         ▼
[Leer mensajes pendientes]
         │
         ▼
[Enviar al backend uno por uno]
         │
         ▼
[Eliminar mensajes sincronizados]
         │
         ▼
[Feedback lúdico al usuario]
```

### 5.3. Feedback Nintendo en Offline

En lugar de mostrar errores técnicos, el sistema usa lenguaje Nintendo:

```javascript
mostrarRespuestaEnPantalla3D(
  "¡Tu mensaje se guardó en tu mochila de explorador! " +
  "Tu tutor lo leerá en cuanto recuperemos la señal."
);
```

---

## 6. manifest.json

### 6.1. Configuración de la PWA

```json
{
  "name": "Gimnasio Fluidez Emocional",
  "short_name": "FluidezEmocional",
  "description": "Tu compañero de exploración conductual",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#FFF8E7",
  "theme_color": "#FF6B6B",
  "orientation": "portrait-primary",
  "icons": [
    {
      "src": "/icons/icon-72x72.png",
      "sizes": "72x72",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-96x96.png",
      "sizes": "96x96",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-128x128.png",
      "sizes": "128x128",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-144x144.png",
      "sizes": "144x144",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-152x152.png",
      "sizes": "152x152",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "/icons/icon-384x384.png",
      "sizes": "384x384",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ],
  "categories": ["health", "medical", "lifestyle"],
  "lang": "es",
  "dir": "ltr"
}
```

---

## 7. Instalación y Aterrizaje de la PWA

### 7.1. Concepto

La instalación es el primer paso de la experiencia Nintendo: la app debe poder
instalarse directamente desde el navegador (desktop y móvil) con una guía clara,
sin fricción y con feedback lúdico. La instalación no debe bloquearse: el usuario
puede seguir usando la app en web y migrar su progreso offline al instalarla.

### 7.2. Detección y Captura de `beforeinstallprompt`

El navegador emite el evento `beforeinstallprompt` cuando la PWA es instalable.
El cliente lo captura, lo almacena y ofrece un **botón de instalación** contextual
sin bloquear el flujo:

```javascript
let deferredInstallPrompt = null;

window.addEventListener('beforeinstallprompt', (event) => {
  event.preventDefault();
  deferredInstallPrompt = event;
  mostrarBotonInstalar();
});

async function instalarApp() {
  if (!deferredInstallPrompt) return;
  deferredInstallPrompt.prompt();
  const { outcome } = await deferredInstallPrompt.userChoice;
  deferredInstallPrompt = null;
  ocultarBotonInstalar();
  if (outcome === 'accepted') registrarInstalacionExitosa();
}
```

### 7.3. Instalación por Plataforma

| Plataforma | Mecanismo | Nota |
|------------|-----------|------|
| **Chrome / Edge (desktop y Android)** | `beforeinstallprompt` + manifest.json | Experiencia nativa, botón contextual. |
| **Safari (iOS)** | "Compartir → Agregar a pantalla de inicio" (A2HS) | No emite `beforeinstallprompt`; se muestra guía manual. |
| **Firefox / Safari desktop** | A2HS manual o botón que copia instrucciones | Guía visual paso a paso. |
| **Android** | Opcional: banner Trusted Web Activity (TWA) | Preferido cuando exista Play Store. |
| **iOS/Android nativos** | Capacitor (migración futura) | Ver §8 Capacitor.config.json. |

### 7.4. UX de Instalación (Feedback Nintendo)

- **No obstruir**: el prompt de instalación es contextual (esquina, banner inferior), nunca modal a pantalla completa durante uso activo.
- **Offline-first tras instalar**: una vez instalada, la app arranca con la shell cacheada (Cache-First, §3) y sincroniza pendientes con Background Sync (§5).
- **Feedback de éxito**: al instalar se muestra el mismo lenguaje lúdico del sistema ("¡Tu explorador está listo para la aventura!") y se registra la métrica de instalación.
- **Fallback iOS**: si no hay `beforeinstallprompt`, el botón abre una mini-guía con pasos para Safari ("Compartir → Agregar a pantalla de inicio").

### 7.5. Criterios de Instalación

| Criterio | Métrica |
|----------|---------|
| La PWA es instalable en Chrome/Edge/Android | manifest.json válido + SW registrado (Lighthouse instalability) |
| Botón de instalación visible cuando es instalable | `beforeinstallprompt` capturado y promocionado |
| Guía iOS disponible cuando no hay evento | UI de A2HS presentada en Safari |
| Tras instalar, la app arranca offline | Cache-First shell carga sin red (<3s) |
| El progreso se conserva al instalar | IndexedDB no se borra al pasar de web a instalada |

La guía de instalación para el usuario final vive en `patient-app.md` (§4.5, "Ayuda y soporte").

---

## 8. Capacitor.config.json (Migración Nativa)

### 7.1. Configuración

```json
{
  "appId": "com.behavioralos.coterapeuta.pbp",
  "appName": "Gimnasio Fluidez Emocional",
  "webDir": "www",
  "bundledWebRuntime": false,
  "server": {
    "androidScheme": "https"
  },
  "plugins": {
    "LocalNotifications": {
      "smallIcon": "ic_stat_icon_config",
      "iconColor": "#488AFF"
    },
    "PushNotifications": {
      "presentationOptions": ["badge", "sound", "alert"]
    },
    "Camera": {
      "permissions": ["camera", "microphone"]
    }
  }
}
```

### 7.2. Ventajas de Capacitor

| Característica | Beneficio |
|----------------|-----------|
| **Webview nativo** | Three.js se ejecuta via WebGL nativo |
| **Acceso a hardware** | Micrófono, cámara, notificaciones push |
| **Mismos gráficos 3D** | El jardín virtual funciona idéntico en web y nativo |
| **Migración incremental** | Un comando genera proyectos Xcode y Android Studio |
| **Plugins nativos** | Acceso a APIs nativas de iOS/Android |

### 7.3. Comandos de Migración

```bash
# Instalar Capacitor
npm install @capacitor/core @capacitor/cli

# Inicializar Capacitor
npx cap init "Gimnasio Fluidez Emocional" "com.behavioralos.coterapeuta.pbp"

# Agregar plataformas
npx cap add ios
npx cap add android

# Sincronizar código web
npx cap sync

# Abrir en IDE
npx cap open ios
npx cap open android
```

---

## 9. Three.js Deep Module (Pantalla3D.js)

### 9.1. Concepto

El módulo `Pantalla3D.js` encapsula toda la lógica de gráficos 3D de la PWA:

```javascript
// Pantalla3D.js - Módulo de gráficos 3D
class Pantalla3D {
  constructor(canvasElement) {
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    this.renderer = new THREE.WebGLRenderer({ canvas: canvasElement, antialias: true });
    this.objects = new Map();
    this.animations = [];
  }

  // Renderizar el Jardín Virtual
  renderJardinVirtual(procesos) {
    // Crear terreno 3D basado en procesos del Hexaflex
    procesos.forEach(proceso => {
      const terreno = this.crearRegion(proceso);
      this.scene.add(terreno);
      this.objects.set(proceso.id, terreno);
    });
  }

  // Renderizar personaje/mascota
  renderPersonaje(estadoEmocional) {
    const personaje = this.crearPersonaje(estadoEmocional);
    this.scene.add(personaje);
    this.objects.set('personaje', personaje);
  }

  // Animar según contexto
  animarSegunContexto(contexto) {
    this.animations.push({
      objeto: contexto.objeto,
      tipo: contexto.animacion,
      duracion: contexto.duracion
    });
  }

  // Loop de renderizado
  animate() {
    requestAnimationFrame(() => this.animate());
    this.renderer.render(this.scene, this.camera);
  }
}
```

### 9.2. Elementos 3D del Hub Central

| Elemento | Implementación Three.js | Interacción |
|----------|------------------------|-------------|
| **Terreno** | PlaneGeometry con texturas | Navegación por región |
| **Regiones** | CylinderGeometry/BoxGeometry | Click para explorar |
| **Personaje** | GLTFLoader (modelo 3D) | Interacción directa |
| **Partículas** | Points/BufferGeometry | Efectos de logro |
| **Iluminación** | AmbientLight + DirectionalLight | Según estado emocional |
| **Cielo** | Sky shader | Según estación/hora |

### 9.3. Optimización para Móviles

| Técnica | Descripción |
|---------|-------------|
| **LOD (Level of Detail)** | Modelos de baja poli para móviles |
| **Texturas comprimidas** | Basis Universal para reducir VRAM |
| **Frustum culling** | No renderizar objetos fuera de cámara |
| **Instanced rendering** | Reutilizar geometrías idénticas |
| **Throttling** | Limitar FPS en dispositivos lentos |

---

## 10. Pipeline de Streaming SSE

### 10.1. Flujo Completo

```
[Paciente escribe mensaje]
         │
         ▼
┌───────────────────────────────────────────────────┐
│     Service Worker: Guardar en IndexedDB          │
│     (Backup por si falla la conexión)             │
└────────────────┬──────────────────────────────────┘
                 │
                 ▼
┌───────────────────────────────────────────────────┐
│     Conexión SSE al Backend                       │
│     (POST /api/chat/stream)                       │
└────────────────┬──────────────────────────────────┘
                 │
                 ▼
┌───────────────────────────────────────────────────┐
│     Streaming de tokens                           │
│     (Carácter por carácter)                       │
└────────────────┬──────────────────────────────────┘
                 │
                 ▼
┌───────────────────────────────────────────────────┐
│     Renderizado en tiempo real                    │
│     (Three.js actualiza UI)                       │
└────────────────┬──────────────────────────────────┘
                 │
                 ▼
┌───────────────────────────────────────────────────┐
│     Extracción de JSON completo                   │
│     (Al finalizar el stream)                      │
└────────────────┬──────────────────────────────────┘
                 │
                 ▼
┌───────────────────────────────────────────────────┐
│     Actualización de motores derivados            │
│     (Event Sourcing)                              │
└───────────────────────────────────────────────────┘
```

### 10.2. Código del Cliente SSE

```javascript
async function enviarMensajeAlCoterapeuta(textoMensaje, historialClinico) {
  if (navigator.onLine) {
    // Modo online: Streaming SSE
    const response = await fetch('http://localhost:8000/api/chat/stream', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ mensaje: textoMensaje, historial: historialClinico })
    });

    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let buffer = '';

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value);
      // Renderizar tokens en tiempo real
      renderizarTokensEnTiempoReal(buffer);
    }

    // Extraer JSON completo y procesar eventos derivados
    const jsonCompleto = JSON.parse(buffer);
    procesarEventosDerivados(jsonCompleto);

  } else {
    // Modo offline: Guardar en IndexedDB
    await guardarMensajeOffline(textoMensaje, historialClinico);
    
    // Registrar Background Sync
    if ('serviceWorker' in navigator && 'SyncManager' in window) {
      const reg = await navigator.serviceWorker.ready;
      await reg.sync.register('sincronizar-charla-pbp');
    }

    // Feedback Nintendo
    mostrarRespuestaEnPantalla3D(
      "¡Tu mensaje se guardó en tu mochila de explorador! " +
      "Tu tutor lo leerá en cuanto recuperemos la señal."
    );
  }
}
```

---

## 11. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Instalación PWA** | ≥80% usuarios instalan la app | Métricas de instalación |
| **Funcionamiento offline** | La app carga sin conexión en <3s | Pruebas manuales |
| **Sincronización** | 100% mensajes se sincronizan al reconectar | Tests automatizados |
| **Rendimiento 3D** | >30fps en dispositivos medianos | Lighthouse 3D |
| **Tamaño total** | <5MB initial load | Análisis de bundle |
| **Cache hit rate** | >90% assets servidos desde caché | Métricas Service Worker |
| **Background Sync** | 100% mensajes pendientes sincronizados | Tests automatizados |
| **Compatibilidad** | Funciona en Chrome, Safari, Firefox, Edge | Pruebas cross-browser |
| **Capacitor ready** | La app se ejecuta en Capacitor sin cambios | Build de prueba |

---

## 12. Referencias

- **MDN Web Docs**: Progressive Web Apps, Service Workers, IndexedDB, beforeinstallprompt.
- **web.dev**: PWA checklist, Lighthouse.
- **Capacitor**: Documentación oficial para migración nativa.
- **Three.js**: Documentación para gráficos 3D en web.

---

## 13. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-14 | Frontend Engineering | Creación inicial: Service Worker, IndexedDB, Background Sync, manifest.json, Capacitor, Three.js module, pipeline SSE. |
| 1.1.0 | 2026-08-12 | Frontend Engineering | Añadida §7 Instalación y Aterrizaje de la PWA (beforeinstallprompt, instalación por plataforma, UX de instalación, criterios). Secciones 8-13 renumeradas. |

---

**Fin del documento `pwa-architecture.md`**
