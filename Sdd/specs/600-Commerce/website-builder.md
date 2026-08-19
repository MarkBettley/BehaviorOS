---
id: WBS-001
title: Behavioral Website Builder (BWB)
version: 1.0.0
status: Stable
owner: Comercio & Experiencia de Usuario
last_updated: 2026-07-02
depends_on:
  - 000-Core/philosophy.md (Filosofía - autonomía del terapeuta)
  - 300-Frontend/design-system.md (BDS - componentes visuales)
  - 300-Frontend/therapist-app.md (Experiencia Apple - interfaz del terapeuta)
  - 600-Commerce/business-model.md (BCE - integración con pagos y suscripciones)
  - 700-PracticeOS/practice-os.md (BPOS - agenda y gestión de citas)
  - 000-Infrastructure/selection.md (Infraestructura - opciones gratuitas)
exports:
  - Arquitectura del Website Builder
  - Editor visual (drag & drop)
  - Plantillas de sitios web (temas)
  - Integración con BCE (pagos, suscripciones, marketplace)
  - Integración con BPOS (agenda, citas, CRM)
  - Gestión de SEO y analytics
  - Publicación y hosting
  - Criterios de validación
used_by:
  - Terapeutas (creación y gestión de su sitio web)
  - Pacientes (visita y reserva de citas)
  - BCE (comercialización de servicios)
  - BPOS (sincronización de agenda)
---

# BehavioralOS – Behavioral Website Builder (BWB)

> *"El sitio web del terapeuta no es solo una tarjeta de presentación. Es el primer punto de contacto con el paciente, la puerta de entrada a la práctica clínica. El Behavioral Website Builder permite a cualquier terapeuta, sin conocimientos técnicos, crear un sitio web profesional que refleje su identidad, sus servicios y su forma de trabajar, todo integrado con el ecosistema BehavioralOS."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Website Builder (BWB)** , una herramienta que permite a los terapeutas crear y gestionar su propio sitio web profesional, integrado con la plataforma BehavioralOS. Su objetivo es:

- **Capacitar a los terapeutas** para que tengan presencia online sin necesidad de conocimientos técnicos.
- **Personalizar la identidad digital** del terapeuta (marca, colores, logo, mensaje).
- **Mostrar servicios, precios y disponibilidad** de forma clara y atractiva.
- **Permitir la reserva de citas** directamente desde el sitio web, sincronizada con la agenda del BPOS.
- **Gestionar pagos** (suscripciones, productos, sesiones) a través del BCE.
- **Mejorar el posicionamiento SEO** y la captación de pacientes.
- **Integrar analytics** para medir el rendimiento del sitio.

### 1.2. Alcance
El documento cubre:

- **Arquitectura del Website Builder**: Componentes, flujos de creación y publicación.
- **Editor visual (drag & drop)**: Interfaz para construir el sitio sin código.
- **Plantillas y temas**: Diseños predefinidos adaptados a psicólogos y terapeutas.
- **Integración con BCE**: Pagos, suscripciones, productos del marketplace.
- **Integración con BPOS**: Agenda, citas, CRM, notificaciones.
- **Gestión de SEO**: Metadatos, URLs amigables, sitemap.
- **Analytics**: Métricas de visitas, conversiones, reservas.
- **Publicación y hosting**: Alojamiento del sitio en la infraestructura de BehavioralOS.
- **Criterios de validación**: Métricas de usabilidad, rendimiento y satisfacción.

### 1.3. Principio Fundamental
> *"Cada terapeuta merece una presencia digital que refleje quién es y cómo trabaja. El BWB democratiza la creación de sitios web profesionales, eliminando las barreras técnicas y permitiendo que los terapeutas se enfoquen en lo que mejor saben hacer: cuidar a sus pacientes."*

---

## 2. Filosofía del Website Builder

### 2.1. Principios de Diseño

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Sin código** | No se requiere programación para crear un sitio web. | Editor visual drag & drop. |
| 2 | **Personalización** | Cada terapeuta puede adaptar el sitio a su identidad. | Colores, tipografía, logo, imágenes. |
| 3 | **Integración nativa** | El sitio se conecta automáticamente con el BPOS y el BCE. | Agenda, pagos, CRM sincronizados. |
| 4 | **Rendimiento** | El sitio debe cargar rápido y ser responsive. | Optimización de assets, CDN, diseño mobile-first. |
| 5 | **SEO amigable** | El sitio debe ser fácilmente indexable por motores de búsqueda. | Metadatos, sitemap, URLs amigables. |
| 6 | **Seguridad** | El sitio debe ser seguro (HTTPS, protección de datos). | TLS 1.3, cifrado de datos de pacientes. |
| 7 | **Escalabilidad** | El sitio debe soportar tráfico creciente. | Hosting en la nube de BehavioralOS. |

### 2.2. Inspiración

El BWB se inspira en plataformas como **Wix**, **Squarespace** y **Shopify**, pero adaptado específicamente a las necesidades de psicólogos y terapeutas:

- **Wix**: Facilidad de uso y variedad de plantillas.
- **Squarespace**: Elegancia y diseño.
- **Shopify**: Integración con comercio y pagos.
- **Calendly**: Reserva de citas integrada.
- **WordPress**: SEO y flexibilidad.

---

## 3. Arquitectura del Website Builder

### 3.1. Visión General

┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Website Builder (BWB) │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Editor Visual (Drag & Drop) │ │
│ │ • Componentes: Texto, Imagen, Botón, Video, Formulario, │ │
│ │ Cita, Precios, Testimonios, Blog, Contacto. │ │
│ │ • Plantillas predefinidas │ │
│ │ • Personalización de colores, tipografía, logo │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Integración con BCE (Comercio) │ │
│ │ • Módulo de precios y suscripciones │ │
│ │ • Botones de pago (Stripe, Mercado Pago) │ │
│ │ • Marketplace de productos digitales │ │
│ │ • Cupones y promociones │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Integración con BPOS (Práctica Clínica) │ │
│ │ • Widget de reserva de citas (Calendly-like) │ │
│ │ • Sincronización con la agenda del terapeuta │ │
│ │ • Formulario de contacto → CRM │ │
│ │ • Notificaciones automáticas │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ SEO & Analytics │ │
│ │ • Metadatos (título, descripción, keywords) │ │
│ │ • Sitemap XML │ │
│ │ • URLs amigables │ │
│ │ • Google Analytics integrado │ │
│ │ • Conversiones y métricas de reservas │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Publicación y Hosting │ │
│ │ • Subdominio personalizado (terapeuta.behavioralos.com) │ │
│ │ • Dominio propio (opcional) │ │
│ │ • CDN para assets estáticos │ │
│ │ • SSL/TLS automático │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 3.2. Componentes del BWB

| Componente | Descripción | Tecnología | Notas (Gratuito) |
|------------|-------------|------------|------------------|
| **Editor Visual** | Herramienta drag & drop para construir el sitio. | React + GrapesJS | Open source |
| **Temas y Plantillas** | Colección de diseños predefinidos. | HTML/CSS/React | Open source |
| **Integración BCE** | Módulos de pago y productos. | FastAPI + Stripe/Mercado Pago | Stripe/Mercado Pago (pago por transacción) |
| **Integración BPOS** | Widget de agenda y CRM. | FastAPI + Supabase | Open source |
| **SEO & Analytics** | Gestión de metadatos y analítica. | React + Google Analytics | Google Analytics (gratis) |
| **Hosting** | Alojamiento del sitio en la nube. | Supabase Storage + CDN | Supabase (gratis) |

---

## 4. Editor Visual (Drag & Drop)

### 4.1. Componentes Disponibles

| Componente | Descripción | Configuración |
|------------|-------------|---------------|
| **Texto** | Bloque de texto con formato básico (títulos, párrafos, listas). | Fuente, tamaño, color, alineación. |
| **Imagen** | Imagen estática o galería. | URL, tamaño, posicionamiento, zoom. |
| **Botón** | CTA (llamada a la acción). | Texto, enlace, estilo, color. |
| **Video** | Video de YouTube, Vimeo o autoalojado. | URL, tamaño, controles. |
| **Formulario** | Formulario de contacto o captación de leads. | Campos (nombre, email, mensaje), destino (CRM). |
| **Citas** | Widget de reserva de citas (Calendly-like). | Duración, servicios, disponibilidad. |
| **Precios** | Tabla de precios y suscripciones. | Planes, precios, características, botón de pago. |
| **Testimonios** | Comentarios de pacientes (con consentimiento). | Nombre, texto, foto, calificación. |
| **Blog** | Artículos y publicaciones. | Título, contenido, fecha, categorías. |
| **Contacto** | Información de contacto y redes sociales. | Dirección, teléfono, email, redes. |
| **Mapa** | Ubicación del consultorio (Google Maps). | Dirección, zoom, tipo de mapa. |
| **Galería** | Colección de imágenes o videos. | Estilo (grid, carrusel), tamaño. |
| **FAQs** | Preguntas frecuentes. | Pregunta, respuesta, categoría. |
| **Integración BCE** | Módulo de pagos y productos del marketplace. | Productos, precios, botón de compra. |

### 4.2. Plantillas Predefinidas

| Plantilla | Descripción | Público objetivo |
|-----------|-------------|------------------|
| **Minimal** | Diseño limpio y moderno. | Psicólogos generales. |
| **ACT** | Inspirado en la Terapia de Aceptación y Compromiso. | Terapeutas ACT. |
| **Infantil** | Colores vivos, ilustraciones amigables. | Psicólogos infantiles. |
| **Profesional** | Estilo corporativo, formal. | Psicólogos organizacionales. |
| **Neuropsicología** | Enfoque en evaluaciones y rehabilitación. | Neuropsicólogos. |
| **Pareja** | Diseño cálido, enfocado en relaciones. | Terapeutas de pareja. |
| **Mindfulness** | Estilo zen, minimalista, colores tierra. | Meditación y mindfulness. |
| **Blog** | Enfoque en contenido escrito. | Psicólogos que escriben artículos. |

### 4.3. Personalización

| Elemento | Configuración | Descripción |
|----------|---------------|-------------|
| **Colores** | Paleta de colores (primario, secundario, fondo). | Aplicado globalmente al sitio. |
| **Tipografía** | Fuentes (Google Fonts). | Títulos, cuerpo, botones. |
| **Logo** | Logo del terapeuta. | Subida de archivo (PNG, SVG). |
| **Favicon** | Icono de la pestaña del navegador. | Subida de archivo (ICO, PNG). |
| **Encabezado** | Estilo del encabezado. | Logo + menú + CTA. |
| **Pie de página** | Estilo del pie de página. | Información de contacto, redes, enlaces. |
| **Fondo** | Color o imagen de fondo. | Aplicado a secciones específicas. |

---

## 5. Integración con BCE (Comercio)

### 5.1. Módulo de Precios

- **Tabla de precios**: Muestra los planes de suscripción del terapeuta (ej. "Plan Mensual", "Plan Trimestral", "Plan Anual").
- **Botón de pago**: Integrado con Stripe o Mercado Pago para que el paciente pueda suscribirse directamente desde el sitio web.
- **Productos del marketplace**: Los productos digitales del terapeuta (cursos, protocolos, etc.) aparecen como artículos en el sitio, con botón de "Comprar ahora".

### 5.2. Cupones y Promociones

- **Aplicación de cupones**: El terapeuta puede crear cupones de descuento desde el BWB y mostrarlos en el sitio.
- **Promociones destacadas**: Anunciar ofertas especiales (ej. "Mes de prueba gratis") en el sitio.

---

## 6. Integración con BPOS (Práctica Clínica)

### 6.1. Widget de Reserva de Citas

- **Calendario interactivo**: El paciente puede ver la disponibilidad del terapeuta y seleccionar una fecha/hora.
- **Sincronización con agenda**: La reserva se añade automáticamente a la agenda del BPOS.
- **Confirmación**: El paciente recibe un correo de confirmación con los detalles de la cita.
- **Recordatorios**: El sistema envía recordatorios automáticos (24h y 1h antes).

### 6.2. Formulario de Contacto

- **Captación de leads**: Los pacientes pueden enviar un mensaje a través del formulario de contacto.
- **CRM**: El mensaje se registra en el CRM del BPOS y se asigna al terapeuta.
- **Notificación**: El terapeuta recibe una notificación (correo, push) de nuevo mensaje.

---

## 7. SEO y Analytics

### 7.1. Configuración SEO

| Elemento | Descripción |
|----------|-------------|
| **Título de la página** | Título que aparece en la pestaña del navegador y en los resultados de búsqueda. |
| **Meta descripción** | Breve descripción de la página (máx. 160 caracteres). |
| **Palabras clave** | Keywords relevantes para el posicionamiento. |
| **URL amigable** | URL legible (ej. `/servicios-terapia-ansiedad`). |
| **Sitemap XML** | Generado automáticamente para facilitar la indexación. |
| **Robots.txt** | Instrucciones para los motores de búsqueda. |
| **Open Graph** | Metadatos para compartir en redes sociales. |

### 7.2. Analytics

- **Google Analytics integrado**: El terapeuta puede conectar su cuenta de Google Analytics para medir:
  - Visitas al sitio.
  - Fuentes de tráfico (orgánico, social, directo, referido).
  - Comportamiento de los usuarios (páginas más visitadas, tiempo de permanencia).
  - Conversiones (reservas de citas, compras, suscripciones).
- **Panel de estadísticas**: Resumen de métricas clave dentro del dashboard del terapeuta en el BWB.

---

## 8. Publicación y Hosting

### 8.1. Dominio y Subdominio

| Opción | Descripción | Costo |
|--------|-------------|-------|
| **Subdominio BehavioralOS** | `terapeuta.behavioralos.com` | Gratuito (incluido en la suscripción). |
| **Dominio propio** | `www.consultoriodelpsicologo.com` | Costo del dominio (externo) + configuración. |

### 8.2. Hosting

- **Alojamiento**: El sitio se aloja en la infraestructura de BehavioralOS (Supabase Storage + CDN).
- **SSL/TLS**: Certificado SSL automático (Let's Encrypt) para HTTPS.
- **CDN**: Distribución de contenido para carga rápida (Cloudflare).
- **Backup**: Copias de seguridad del sitio (diarias).

### 8.3. Publicación

1. **Previsualización**: El terapeuta puede previsualizar el sitio antes de publicarlo.
2. **Publicación**: Con un clic, el sitio se publica en el dominio configurado.
3. **Actualizaciones**: Los cambios se publican en tiempo real (sin downtime).

---

## 9. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Usabilidad** | El terapeuta puede crear un sitio web en < 30 minutos (sin conocimiento técnico). | Pruebas de usabilidad |
| **Rendimiento** | Tiempo de carga < 2s (en 3G). | Lighthouse, Web Vitals |
| **Disponibilidad** | Uptime del sitio > 99.9%. | Monitoreo |
| **Integración** | 100% de las reservas de citas se sincronizan con la agenda del BPOS. | Pruebas de integración |
| **Seguridad** | 100% de las páginas con HTTPS y TLS 1.3. | Pruebas de seguridad |
| **Accesibilidad** | El sitio cumple con WCAG 2.1 AA. | axe-core, Lighthouse |
| **Satisfacción del terapeuta** | ≥ 4.5/5 en encuestas de satisfacción. | Encuestas in-app |

---

## 10. El Manifiesto del BWB

> *"El sitio web del terapeuta no es solo una tarjeta de presentación. Es el primer punto de contacto con el paciente, la puerta de entrada a la práctica clínica.*
>
> *El Behavioral Website Builder permite a cualquier terapeuta, sin conocimientos técnicos, crear un sitio web profesional que refleje su identidad, sus servicios y su forma de trabajar.*
>
> *No se trata solo de tener presencia online. Se trata de conectar con las personas que necesitan ayuda, de ofrecer un espacio de confianza y de mostrar el camino hacia el bienestar.*
>
> *Nuestra responsabilidad es garantizar que el BWB sea fácil, rápido, seguro y esté perfectamente integrado con el ecosistema BehavioralOS. Que cada terapeuta pueda tener su propio rincón en internet, sin complicaciones."*

---

## 11. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-02 | Arquitectura Comercial | Creación del documento. Definición del Behavioral Website Builder: arquitectura, editor visual, plantillas, integración con BCE y BPOS, SEO, analytics, publicación y criterios de validación. |

---

**Fin del documento `website-builder.md`**