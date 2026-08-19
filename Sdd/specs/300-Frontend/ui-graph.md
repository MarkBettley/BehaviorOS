---
id: UI-001
title: UI Graph – Mapa de Pantallas y Navegación
version: 1.0.0
status: Stable
owner: Diseño UX/UI & Frontend Engineering
last_updated: 2026-07-01
depends_on:
  - 000-Core/philosophy.md (Filosofía)
  - 000-Core/principles.md (Principios)
  - 000-Core/vocabulary.md (Lenguaje)
  - 300-Frontend/design-system.md (BDS)
  - 300-Frontend/ahee-implementation.md (Adaptación AHEE)
exports:
  - Mapa de pantallas completo (paciente y terapeuta)
  - Flujos de navegación y transiciones
  - Arquitectura de información (taxonomía y jerarquía)
  - Patrones de navegación (bottom nav, sidebar, gestos)
  - Flujos de usuario clave (onboarding, misión, sesión, etc.)
  - Integración con el Behavioral Twin y el TCCN
used_by:
  - Patient App (Experiencia Nintendo)
  - Therapist App (Experiencia Apple)
  - Admin Dashboard
  - Frontend Engineers (implementación de navegación)
  - QA (pruebas de flujos)
  - UX Designers (iteración de flujos)
---

# BehavioralOS – UI Graph: Mapa de Pantallas y Navegación

> *"Una buena navegación es invisible. El usuario no piensa en cómo llegar a donde quiere; simplemente llega. La arquitectura de información del BehavioralOS debe ser intuitiva, consistente y adaptativa, guiando al usuario sin que se dé cuenta."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **mapa de pantallas y la arquitectura de navegación** del BehavioralOS. Su objetivo es:

- **Establecer la estructura de información** de todas las aplicaciones (paciente, terapeuta, administrador).
- **Definir los flujos de usuario** clave (onboarding, misión, sesión, gestión de pacientes, videoterapia, etc.).
- **Especificar los patrones de navegación** (bottom navigation, sidebar, gestos, transiciones).
- **Garantizar la consistencia** entre las experiencias del paciente (Nintendo) y del terapeuta (Apple).
- **Integrar la navegación con el Behavioral Twin y el TCCN** para ofrecer una experiencia personalizada y contextual.

### 1.2. Alcance
El UI Graph cubre:

- **Mapa de pantallas**: Todas las pantallas de la aplicación, organizadas por dominio y flujo.
- **Flujos de navegación**: Cómo se conectan las pantallas entre sí (transiciones, jerarquía).
- **Patrones de navegación**: Bottom navigation, sidebar, gestos, breadcrumbs, atajos de teclado.
- **Flujos de usuario clave**: Onboarding, autenticación, realización de misión, videoterapia, gestión de pacientes, etc.
- **Integración con motores**: Cómo la navegación se adapta al estado del Behavioral Twin y a las interacciones del TCCN.

### 1.3. Principio Fundamental
> **"La navegación debe ser una extensión natural de la experiencia del usuario. Para el paciente, debe sentirse como explorar un mundo (Nintendo). Para el terapeuta, debe sentirse como gestionar un consultorio (Apple). Ambas experiencias deben ser fluidas, intuitivas y adaptativas."**

---

## 2. Filosofía de Navegación

### 2.1. Principios Generales

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Jerarquía clara** | La información se organiza en niveles de profundidad lógicos. | El usuario siempre sabe dónde está y cómo volver. |
| 2 | **Contextualidad** | La navegación se adapta al estado del usuario y al contexto. | La pantalla de inicio cambia según la hora del día, el estado de ánimo y las misiones pendientes. |
| 3 | **Minimización de clics** | El usuario puede llegar a cualquier destino con ≤ 3 clics. | El home tiene acceso directo a las acciones principales. |
| 4 | **Feedback visual** | Cada acción de navegación tiene una respuesta visual inmediata. | Transiciones suaves, indicadores de carga, cambio de estado. |
| 5 | **Accesibilidad** | La navegación es accesible por teclado, lectores de pantalla y gestos. | Atajos de teclado, navegación por voz (opcional). |
| 6 | **Adaptatividad (AHEE)** | La navegación se adapta al perfil del usuario. | Niños ven más iconos y menos texto; adultos ven más texto y menos decoración. |

### 2.2. Diferencias entre Experiencias

| Aspecto | Paciente (Nintendo) | Terapeuta (Apple) |
|---------|---------------------|-------------------|
| **Estilo de navegación** | Exploratoria, lúdica, con gestos y animaciones. | Funcional, eficiente, con atajos y búsqueda rápida. |
| **Patrón principal** | Bottom navigation (5 pestañas). | Sidebar colapsable + breadcrumbs. |
| **Transiciones** | Slide horizontal con aceleración. | Fade y slide vertical suave. |
| **Feedback** | Sonido, vibración, partículas. | Indicadores visuales discretos. |
| **Gestos** | Deslizar para navegar entre pantallas. | Deslizar para acciones rápidas (ej. archivar). |
| **Atajos** | Limitados (botones grandes). | Atajos de teclado (Cmd+K, Cmd+1, etc.). |

---

## 3. Mapa de Pantallas – Paciente (Experiencia Nintendo)

### 3.1. Bottom Navigation (5 Pestañas)
┌─────────────────────────────────────────────────────────────────────────┐
│ Bottom Navigation (Paciente) │
├──────────┬──────────┬──────────┬──────────┬──────────┬─────────────────┤
│ Mapa │ Misiones │ Compañero│Inventario│ Perfil │ │
│ (Atlas) │ │ │ (Mochila)│ │ │
└──────────┴──────────┴──────────┴──────────┴──────────┴─────────────────┘


#### 3.1.1. Pantalla: Mapa (Atlas)

**Descripción**: Pantalla principal del paciente. Muestra un mapa interactivo del comportamiento del usuario, con regiones que representan procesos psicológicos (Atención, Acción, Perspectiva, Relaciones, Significado, Equilibrio). Las regiones se iluminan a medida que el usuario explora y descubre patrones.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Mapa interactivo** | Regiones con colores y nombres de procesos. | Click en una región → abre la pantalla de detalle del proceso. |
| **Misión del día** | Burbuja flotante en la esquina inferior derecha. | Click → inicia la misión diaria. |
| **Progreso general** | Barra circular en la esquina superior derecha. | Click → muestra resumen de progreso. |
| **Compañero IA** | Avatar del TCCN en la esquina inferior izquierda. | Click → abre el chat con el compañero. |
| **Notificaciones** | Campana en la esquina superior izquierda. | Click → abre el centro de notificaciones. |

**Estado del mapa**:
- **Región iluminada**: Proceso con alta exploración (ej. "Atención" al 80%).
- **Región difuminada**: Proceso poco explorado (ej. "Significado" al 10%).
- **Región parpadeante**: Nuevo descubrimiento disponible en esa región.

#### 3.1.2. Pantalla: Misiones

**Descripción**: Lista de misiones (ejercicios) disponibles, organizadas por proceso y por nivel de dificultad. Cada misión tiene una narrativa, una duración estimada y una recompensa (descubrimiento).

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Filtros** | Por proceso (Atención, Acción, etc.) y por estado (disponible, completada, bloqueada). | Click → filtra la lista de misiones. |
| **Tarjeta de misión** | Icono, título, descripción breve, duración, recompensa. | Click → abre la pantalla de detalle de la misión. |
| **Botón "Iniciar"** | En la tarjeta de misión o en la pantalla de detalle. | Click → inicia el ejercicio (Godot). |
| **Progreso semanal** | Barra de progreso en la parte superior. | Muestra el avance de la semana. |

**Estado de la tarjeta**:
- **Disponible**: Fondo blanco, botón "Iniciar" visible.
- **Completada**: Fondo verde claro, badge de "¡Completada!".
- **Bloqueada**: Fondo gris, icono de candado, mensaje de "Completa la misión anterior".

#### 3.1.3. Pantalla: Compañero (TCCN)

**Descripción**: Pantalla de chat con el compañero IA (TCCN). El compañero inicia conversaciones basadas en el estado del Behavioral Twin, haciendo preguntas, ofreciendo observaciones y guiando al usuario.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Historial de chat** | Burbujas de conversación (usuario y compañero). | Scroll para ver mensajes anteriores. |
| **Input de texto** | Campo de texto para escribir mensajes. | Enviar mensaje con Enter o botón "Enviar". |
| **Botones rápidos** | Sugerencias de respuesta (ej. "Cuéntame más", "Explorar eso"). | Click → envía un mensaje predefinido. |
| **Avatar del compañero** | Animado, con expresiones (feliz, curioso, atento). | Cambia según el contexto de la conversación. |
| **Mensaje de bienvenida** | El compañero inicia con una observación (ej. "Hoy noté que dormiste mejor. ¿Quieres explorar eso?"). | Click en "Explorar" → inicia una misión o reflexión. |

#### 3.1.4. Pantalla: Inventario (Mochila)

**Descripción**: Colección de habilidades desbloqueadas (ej. "Escudo de Aceptación", "Brújula de Valores"). Cada habilidad es un nodo del Behavioral Twin que se ha fortalecido.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Grid de habilidades** | Iconos con nombres, organizados por proceso. | Click → abre la ficha de la habilidad. |
| **Ficha de habilidad** | Descripción, procesos asociados, ejercicios relacionados, progreso. | Click en ejercicio → inicia la misión. |
| **Contador de descubrimientos** | Número total de habilidades desbloqueadas. | Muestra en la parte superior. |
| **Efecto de "nuevo"** | Brillo y badge "¡Nuevo!" en habilidades recién desbloqueadas. | Desaparece después de 3 vistas. |

#### 3.1.5. Pantalla: Perfil

**Descripción**: Perfil del paciente, con información personal, configuraciones, historial de descubrimientos y acceso a la ayuda.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Foto y nombre** | Avatar y nombre del usuario. | Click → opciones de edición. |
| **Estadísticas** | Días activos, misiones completadas, descubrimientos. | Resumen visual. |
| **Diario de descubrimientos** | Lista cronológica de todos los descubrimientos. | Click → abre detalle del descubrimiento. |
| **Configuración** | Acceso a preferencias (idioma, notificaciones, accesibilidad). | Click → abre pantalla de configuración. |
| **Ayuda y soporte** | Enlace a FAQ y contacto con el terapeuta. | Click → abre pantalla de ayuda. |
| **Cerrar sesión** | Botón para cerrar sesión. | Confirmación antes de cerrar. |

### 3.2. Flujos Secundarios (Paciente)

#### 3.2.1. Flujo: Onboarding

1.  **Pantalla de bienvenida**: Presentación del viaje (con ilustraciones animadas).
2.  **Selección de avatar**: Personalización del compañero y del avatar del usuario.
3.  **Preferencias iniciales**: Edad, intereses, nivel de experiencia con videojuegos.
4.  **Conexión con terapeuta**: Invitación a vincular con un terapeuta (si ya existe) o mostrar un mensaje de espera.
5.  **Primera misión**: Misión introductoria (muy fácil) para familiarizarse con la navegación.
6.  **Pantalla de bienvenida (home)**: El mapa se muestra con la primera región iluminada.

#### 3.2.2. Flujo: Realización de una Misión

1.  **Pantalla de misión (detalle)**: El usuario ve la descripción de la misión, su duración y la recompensa.
2.  **Click en "Iniciar"**: El ejercicio se carga (Godot) dentro de la aplicación (no redirige a otra app).
3.  **Experiencia de juego**: El usuario interactúa con el minijuego. La telemetría se envía en tiempo real.
4.  **Finalización**: El juego muestra un resumen (puntuación, tiempo, descubrimiento).
5.  **Pantalla de descubrimiento**: El sistema muestra un nuevo descubrimiento (ej. "Hoy permaneciste 40 segundos más en una situación incómoda").
6.  **Actualización del Atlas**: El mapa se actualiza, iluminando nuevas regiones.
7.  **Diario**: El descubrimiento se guarda en el Diario de Descubrimientos.

#### 3.2.3. Flujo: Chat con el Compañero

1.  **El compañero inicia**: Con una observación basada en el Behavioral Twin (ej. "He notado que evitaste la reunión de ayer. ¿Qué pasó?").
2.  **Respuesta del usuario**: El usuario escribe o selecciona una opción rápida.
3.  **Procesamiento (TCCN)**: El sistema analiza la respuesta, actualiza el Behavioral Twin y genera una nueva respuesta.
4.  **Respuesta del compañero**: El compañero ofrece validación, hace una pregunta de seguimiento o sugiere una misión.
5.  **Cierre**: El compañero finaliza con una invitación ("¿Te gustaría explorar esto con una misión?").

#### 3.2.4. Flujo: Videoterapia (con el terapeuta)

1.  **Notificación**: El paciente recibe una notificación de que su sesión está a punto de comenzar.
2.  **Click en "Entrar"**: Abre la pantalla de videoterapia (integrada con Google Meet/Zoom).
3.  **Pantalla de videollamada**: Ventana de video, chat lateral, HUD clínico (visible para el paciente de forma simplificada).
4.  **Durante la sesión**: El paciente ve al terapeuta y puede compartir pantalla si es necesario.
5.  **Fin de la sesión**: El terapeuta finaliza la llamada. El paciente ve un resumen de la sesión (opcional).
6.  **Post-sesión**: El sistema actualiza el Behavioral Twin con la información de la sesión.

### 3.3. Navegación y Transiciones (Paciente)

| Transición | Descripción | Animación |
|------------|-------------|-----------|
| **Entre pestañas** | Cambio entre las 5 secciones principales (Mapa, Misiones, Compañero, Inventario, Perfil). | Slide horizontal con aceleración (300ms). |
| **Apertura de detalle** | Click en una región del mapa o en una tarjeta de misión. | Fade + scale up (200ms). |
| **Inicio de misión** | Click en "Iniciar" → carga del minijuego (Godot). | Fade out de la UI, fade in del juego. |
| **Finalización de misión** | Vuelta a la pantalla de mapa o de misiones. | Slide up con confeti (500ms). |
| **Apertura de chat** | Click en el avatar del compañero. | Slide up desde la parte inferior (300ms). |

---

## 4. Mapa de Pantallas – Terapeuta (Experiencia Apple)

### 4.1. Sidebar (Colapsable)
┌─────────────────────────────────────────────────────────────────────────┐
│ Sidebar (Terapeuta) │
├─────────────────────────────────────────────────────────────────────────┤
│ 🏠 Dashboard │
│ 👥 Pacientes │
│ 📅 Agenda │
│ 🎥 Videoterapia │
│ 📝 Notas │
│ 📊 Informes │
│ ⚙️ Configuración │
│ 📈 Analítica │
│ 💰 Facturación │
│ ❓ Ayuda │
└────────────────

#### 4.1.1. Pantalla: Dashboard

**Descripción**: Vista de resumen del consultorio. Muestra KPIs clave (pacientes activos, sesiones de hoy, ingresos, retención, etc.) y alertas clínicas.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **KPIs** | Tarjetas con números y tendencias (ej. "Pacientes activos: 12 ↑"). | Click → abre la vista detallada correspondiente. |
| **Sesiones de hoy** | Lista de sesiones programadas para hoy. | Click → abre la agenda. |
| **Alertas clínicas** | Pacientes con riesgo de abandono o recaída. | Click → abre el perfil del paciente. |
| **Gráficos de procesos** | Resumen de procesos más trabajados (global). | Click → abre la analítica. |
| **Notificaciones** | Últimas notificaciones (ej. "Paciente completó 5 ejercicios"). | Click → abre el centro de notificaciones. |

#### 4.1.2. Pantalla: Pacientes

**Descripción**: Lista de pacientes con filtros y búsqueda. Cada paciente tiene un resumen de su estado.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Filtros** | Por estado (activo, alta, transferido), por terapeuta, por riesgo. | Click → filtra la lista. |
| **Búsqueda** | Campo de búsqueda por nombre o ID. | Escribir → resultados en tiempo real. |
| **Tarjeta de paciente** | Nombre, foto, última sesión, estado, indicador de riesgo (color). | Click → abre el perfil completo del paciente. |
| **Acciones rápidas** | Botones para agendar cita, enviar mensaje, ver expediente. | Click → abre la acción correspondiente. |

#### 4.1.3. Pantalla: Perfil del Paciente

**Descripción**: Vista completa del paciente. Incluye información personal, Behavioral Twin, historial de sesiones, evaluaciones, hipótesis, valores, objetivos y ejercicios.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Información personal** | Nombre, edad, contacto, terapeuta asignado. | Editable (con permisos). |
| **Behavioral Twin** | Visualización del Twin (Hexaflex, redes RFT, trayectorias de procesos). | Interactivo (click para ver detalles). |
| **Historial de sesiones** | Lista cronológica de sesiones con notas resumidas. | Click → abre la nota completa. |
| **Evaluaciones** | Lista de evaluaciones (MPFI, AAQ-II, etc.) con puntuaciones y tendencias. | Click → abre el detalle de la evaluación. |
| **Hipótesis activas** | Lista de hipótesis funcionales con niveles de confianza. | Click → abre el detalle de la hipótesis. |
| **Valores y objetivos** | Valores ACT y objetivos terapéuticos con progreso. | Editable. |
| **Ejercicios realizados** | Lista de ejercicios completados con telemetría resumida. | Click → abre el detalle del ejercicio. |
| **Acciones** | Agendar cita, enviar mensaje, generar informe, etc. | Click → abre la acción correspondiente. |

#### 4.1.4. Pantalla: Agenda

**Descripción**: Calendario de citas con vistas diaria, semanal y mensual. Integración con Google Calendar/Outlook.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Vistas** | Día, Semana, Mes. | Click → cambia la vista. |
| **Citas** | Bloques de tiempo con información del paciente y modalidad. | Click → abre el detalle de la cita. |
| **Crear cita** | Botón para crear una nueva cita (paciente, fecha, hora, modalidad). | Click → abre un modal de creación. |
| **Integración** | Sincronización con Google Calendar/Outlook. | Automática. |
| **Disponibilidad** | Bloqueos de tiempo (vacaciones, descansos). | Configurable. |

#### 4.1.5. Pantalla: Videoterapia (Workspace)

**Descripción**: Pantalla de videollamada con HUD clínico integrado. Durante la sesión, el terapeuta ve indicadores en tiempo real (procesos, CRB, oportunidades).

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Ventana de video** | Video del paciente y del terapeuta. | Control de cámara, micrófono, compartir pantalla. |
| **HUD clínico** | Panel lateral o flotante con: proceso dominante, CRB detectadas, oportunidades de intervención. | Click → abre detalles de la oportunidad. |
| **Transcripción en tiempo real** | Texto de la conversación (con identificación de hablante). | Scroll para ver historial. |
| **Notas rápidas** | Botón para tomar notas durante la sesión. | Click → abre un mini editor. |
| **IA copiloto** | Sugerencias de preguntas o intervenciones (en panel lateral). | Click → inserta en el chat o en las notas. |
| **Finalizar sesión** | Botón para terminar la sesión y generar automáticamente un borrador de notas. | Click → confirma y genera notas. |

#### 4.1.6. Pantalla: Notas Clínicas

**Descripción**: Editor de notas de sesión (SOAP/DAP) con plantillas y autocompletado de procesos y CRB.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Editor** | Área de texto con formato básico. | Escribir y editar. |
| **Plantillas** | Selección de plantillas (SOAP, DAP, FAP, ACT). | Click → carga la estructura de la plantilla. |
| **Autocompletado** | Sugerencias de procesos, CRB, valores mientras se escribe. | Aparece automáticamente. |
| **Firma** | Botón para firmar electrónicamente las notas. | Click → firma con OTP o biometría. |
| **Versiones** | Historial de versiones de la nota. | Click → ver versiones anteriores. |
| **Guardar** | Guarda automáticamente (borrador) o manualmente. | Click → guarda la nota. |

#### 4.1.7. Pantalla: Informes

**Descripción**: Gestión y generación de informes clínicos (Functional Behavioral Report, evaluaciones neuropsicológicas, etc.).

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Lista de informes** | Informes generados con fecha, tipo y estado. | Click → abre el informe. |
| **Generar informe** | Botón para crear un nuevo informe (seleccionar tipo y paciente). | Click → abre el wizard de generación. |
| **Plantillas** | Selección de plantillas de informe. | Click → carga la plantilla. |
| **Exportar** | Exportar a PDF (con CFDI si aplica). | Click → descarga el PDF. |
| **Firmar** | Firma electrónica del terapeuta. | Click → firma. |

#### 4.1.8. Pantalla: Configuración

**Descripción**: Configuración del perfil del terapeuta, precios, servicios, consentimientos, facturación y preferencias.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Perfil profesional** | Licencia, especialidades, bio, tarifa. | Editable. |
| **Servicios** | Lista de servicios ofrecidos (terapia individual, pareja, neuropsicología, etc.) con precios. | Editable. |
| **Consentimientos** | Plantillas de consentimientos informados. | Editable. |
| **Facturación** | Configuración de Stripe/Mercado Pago, facturación CFDI. | Editable. |
| **Preferencias** | Tema (claro/oscuro), notificaciones, idioma. | Editable. |
| **Integraciones** | Conexión con Google Calendar, Zoom, etc. | Configurable. |

#### 4.1.9. Pantalla: Analítica (BIP)

**Descripción**: Dashboards avanzados con gráficos de procesos, tendencias de adherencia, predicciones y KPIs clínicos.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Gráficos de procesos** | Evolución de procesos por paciente o global. | Click → filtra por proceso o paciente. |
| **Adherencia** | Gráficos de adherencia (ejercicios, sesiones). | Click → filtra por período. |
| **Predicciones** | Riesgo de abandono, recaída, etc. | Click → abre el detalle de la predicción. |
| **Exportar** | Exportar datos a CSV o PDF. | Click → descarga el archivo. |
| **Filtros** | Por paciente, terapeuta, fecha, etc. | Click → aplica filtros. |

#### 4.1.10. Pantalla: Facturación

**Descripción**: Gestión de suscripciones, facturas, pagos y reembolsos.

| Elemento | Descripción | Comportamiento |
|----------|-------------|----------------|
| **Suscripciones activas** | Lista de pacientes con suscripción activa. | Click → abre el detalle de la suscripción. |
| **Facturas** | Lista de facturas emitidas con estado. | Click → abre el detalle de la factura. |
| **Pagos** | Historial de pagos. | Click → abre el detalle del pago. |
| **Generar factura** | Botón para generar una factura manual (si aplica). | Click → abre el wizard de facturación. |
| **Reembolsos** | Gestión de reembolsos. | Click → inicia el proceso de reembolso. |

### 4.2. Flujos Secundarios (Terapeuta)

#### 4.2.1. Flujo: Gestión de un Paciente

1.  **Buscar o filtrar paciente**: En la pantalla de "Pacientes".
2.  **Click en la tarjeta del paciente**: Abre el perfil completo del paciente.
3.  **Ver Behavioral Twin**: Explora el Twin (Hexaflex, redes RFT, trayectorias).
4.  **Agendar cita**: Desde el perfil, click en "Agendar cita" → redirige a la agenda con los datos precargados.
5.  **Enviar mensaje**: Click en "Enviar mensaje" → abre el chat con el paciente.
6.  **Generar informe**: Click en "Generar informe" → selecciona el tipo de informe y lo genera.
7.  **Actualizar hipótesis**: Click en "Hipótesis" → edita o crea una nueva hipótesis.

#### 4.2.2. Flujo: Videoterapia

1.  **Notificación**: El terapeuta recibe un recordatorio de la sesión (correo, push).
2.  **Click en "Iniciar sesión"**: Abre la pantalla de videoterapia.
3.  **Configuración de la videollamada**: El terapeuta inicia la llamada (Google Meet/Zoom).
4.  **Durante la sesión**: El terapeuta ve al paciente, el HUD clínico muestra indicadores en tiempo real.
5.  **Acciones durante la sesión**: El terapeuta toma notas rápidas, usa el copiloto IA para sugerencias.
6.  **Finalizar sesión**: Click en "Finalizar sesión". El sistema genera automáticamente un borrador de notas.
7.  **Revisión de notas**: El terapeuta revisa y edita las notas generadas automáticamente.
8.  **Firma**: El terapeuta firma las notas y las guarda.

#### 4.2.3. Flujo: Generación de un Informe (FBR)

1.  **Seleccionar paciente**: En el perfil del paciente o en la pantalla de informes.
2.  **Seleccionar tipo de informe**: Functional Behavioral Report, Evaluación Neuropsicológica, etc.
3.  **Seleccionar plantilla**: El sistema carga la plantilla con datos precargados del Behavioral Twin.
4.  **Revisión y edición**: El terapeuta revisa y edita el informe (agrega observaciones, ajusta interpretaciones).
5.  **Firma**: El terapeuta firma electrónicamente el informe.
6.  **Exportar**: El informe se exporta a PDF y se almacena en el expediente del paciente.
7.  **Enviar al paciente**: El informe se envía al paciente (correo, portal del paciente).

### 4.3. Navegación y Transiciones (Terapeuta)

| Transición | Descripción | Animación |
|------------|-------------|-----------|
| **Entre secciones (sidebar)** | Cambio entre las secciones principales. | Slide horizontal suave (200ms). |
| **Apertura de perfil de paciente** | Click en la tarjeta del paciente. | Fade + slide up (200ms). |
| **Apertura de modal** | Click en "Agendar cita", "Generar informe", etc. | Fade + scale up (150ms). |
| **Apertura de videoterapia** | Click en "Iniciar sesión". | Fade out de la UI, fade in de la videollamada. |
| **Guardar nota** | Click en "Guardar". | Indicador de éxito (checkmark) y cierre del modal. |

---

## 5. Flujos de Usuario Transversales

### 5.1. Autenticación y Registro

1.  **Pantalla de login**: Email/contraseña, OAuth (Google), WebAuthn (passkeys).
2.  **Registro**: Selección de rol (paciente, terapeuta, administrador). Dependiendo del rol, el flujo de registro cambia.
3.  **Verificación de email**: Envío de correo de verificación.
4.  **Onboarding** (paciente): Presentación del viaje, selección de avatar, preferencias iniciales.
5.  **Onboarding** (terapeuta): Configuración del perfil profesional, conexión con Stripe/Mercado Pago, etc.
6.  **Redirección**: Según el rol, redirige a la pantalla de inicio correspondiente.

### 5.2. Recuperación de Contraseña

1.  **Pantalla de "Olvidé mi contraseña"**: Ingreso de email.
2.  **Envío de correo**: Enlace de restablecimiento con token.
3.  **Nueva contraseña**: Ingreso y confirmación de la nueva contraseña.
4.  **Redirección**: A la pantalla de login.

### 5.3. Notificaciones

1.  **Generación de notificación**: El sistema o un motor (BPOS, TCCN, BCE) genera una notificación.
2.  **Almacenamiento**: La notificación se guarda en la base de datos (tabla `notifications`).
3.  **Envío**: La notificación se envía al usuario a través de:
    - **In-app**: Centro de notificaciones (campana).
    - **Push**: Firebase Cloud Messaging (móvil).
    - **Correo**: Para recordatorios de sesiones y facturas.
4.  **Visualización**: El usuario ve la notificación en el centro de notificaciones. Click en la notificación → abre la pantalla correspondiente.

**Tipos de notificaciones**:
- **Recordatorio de sesión**: Alerta al paciente y al terapeuta.
- **Misión completada**: Felicitación al paciente.
- **Nuevo descubrimiento**: Notificación al paciente.
- **Nuevo mensaje**: Notificación de chat (paciente ↔ terapeuta).
- **Alerta clínica**: Riesgo de abandono, recaída (para el terapeuta).
- **Factura emitida**: Notificación al paciente.
- **Pago fallido**: Notificación al paciente.

---

## 6. Integración con el Behavioral Twin y el TCCN

### 6.1. Personalización de la Navegación

- **Mapa del Atlas**: El estado del Behavioral Twin determina qué regiones están iluminadas y qué descubrimientos están disponibles.
- **Misiones**: El sistema sugiere misiones basadas en los procesos con menor confianza o mayor relevancia.
- **Compañero**: El TCCN inicia conversaciones basadas en eventos del Behavioral Twin (ej. "He notado que tu aceptación ha mejorado esta semana").

### 6.2. Contextualidad

- **Pantalla de inicio (paciente)**: Cambia según la hora del día, el estado de ánimo estimado y las misiones pendientes.
- **Videoterapia (terapeuta)**: El HUD clínico se actualiza en tiempo real según el Behavioral Twin y las interacciones del paciente durante la sesión.
- **Agenda (terapeuta)**: Muestra el estado de los pacientes (ej. "Riesgo de abandono: alto") junto a sus citas.

---

## 7. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Profundidad de navegación** | ≤ 3 clics para llegar a cualquier pantalla. | Pruebas de usabilidad. |
| **Tiempo de carga de pantalla** | < 2s en 3G. | Lighthouse. |
| **Transiciones** | Animaciones fluidas (≥ 60 FPS). | Framer Motion (performance). |
| **Accesibilidad** | Navegación por teclado y lectores de pantalla. | axe-core. |
| **Adaptatividad (AHEE)** | La navegación cambia correctamente según el perfil del usuario. | Pruebas de integración. |
| **Consistencia** | Los patrones de navegación son consistentes en todas las pantallas. | Revisión de diseño. |

---

## 8. El Manifiesto de la Navegación

> *"La navegación no es un medio para llegar a un destino. Es parte de la experiencia misma.*
>
> *Para el paciente, navegar debe sentirse como explorar un mundo desconocido, donde cada paso revela algo nuevo sobre sí mismo.*
>
> *Para el terapeuta, navegar debe sentirse como gestionar un consultorio eficiente, donde la información está siempre al alcance.*
>
> *La navegación debe ser invisible cuando funciona bien, y guiar cuando el usuario se pierde.*
>
> *Nuestra responsabilidad es diseñar caminos que sean intuitivos, adaptativos y significativos."*

---

## 9. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Diseño UX/UI | Creación del documento. Definición de mapa de pantallas, flujos de navegación, patrones de navegación para paciente y terapeuta, y flujos de usuario clave. |

---

**Fin del documento `ui-graph.md`**