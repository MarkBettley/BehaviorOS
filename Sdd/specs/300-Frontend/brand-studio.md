---
id: BBS-001
title: Behavioral Brand Studio (BBS)
version: 1.0.0
status: Stable
owner: Diseño UX/UI & Experiencia de Marca
last_updated: 2026-07-02
depends_on:
  - 000-Core/philosophy.md (Filosofía - identidad del terapeuta)
  - 300-Frontend/design-system.md (BDS - tokens de diseño)
  - 300-Frontend/therapist-app.md (Experiencia Apple - interfaz del terapeuta)
  - 300-Frontend/patient-app.md (Experiencia Nintendo - personalización para pacientes)
  - 600-Commerce/website-builder.md (BWB - integración con sitio web)
  - 700-PracticeOS/practice-os.md (BPOS - comunicaciones y portal del paciente)
  - 000-Infrastructure/selection.md (Infraestructura - opciones gratuitas)
exports:
  - Arquitectura del Brand Studio
  - Gestión de identidad visual (colores, logo, tipografía, iconografía)
  - Personalización de la experiencia del paciente
  - Integración con BWB, BPOS y Patient App
  - Gestión de activos de marca
  - Políticas de uso y gobernanza de marca
  - Criterios de validación
used_by:
  - Terapeutas y clínicas (personalización de marca)
  - Patient App (experiencia personalizada)
  - Therapist App (dashboard con la identidad del terapeuta)
  - BWB (sitio web del terapeuta)
  - BPOS (comunicaciones y portal del paciente)
---

# BehavioralOS – Behavioral Brand Studio (BBS)

> *"La marca de un terapeuta no es solo un logo. Es la promesa de confianza, de cuidado y de profesionalismo. El Behavioral Brand Studio permite a los terapeutas y clínicas construir una identidad visual coherente y memorable que se extiende a todos los puntos de contacto con el paciente: el sitio web, la aplicación, las comunicaciones y el portal del paciente."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Brand Studio (BBS)** , una herramienta que permite a los terapeutas y clínicas personalizar la identidad visual de su marca dentro del ecosistema BehavioralOS. Su objetivo es:

- **Permitir la personalización de la identidad visual** del terapeuta o clínica (colores, logo, tipografía, iconografía).
- **Garantizar una experiencia coherente** para el paciente en todos los puntos de contacto (sitio web, app, comunicaciones).
- **Facilitar la diferenciación** de los terapeutas en el marketplace y en la plataforma.
- **Mantener la calidad y consistencia** del diseño, respetando las guías del Behavioral Design System (BDS).
- **Centralizar la gestión de activos de marca** (logo, imágenes, documentos, etc.).

### 1.2. Alcance
El documento cubre:

- **Arquitectura del Brand Studio**: Componentes, flujos de personalización.
- **Gestión de identidad visual**: Colores, logo, tipografía, iconografía, imágenes.
- **Personalización de la experiencia del paciente**: Aplicación de la marca en la Patient App.
- **Integración con BWB**: Sincronización de la marca con el sitio web del terapeuta.
- **Integración con BPOS**: Personalización de comunicaciones y portal del paciente.
- **Gestión de activos de marca**: Almacenamiento y versionado de activos.
- **Políticas de uso y gobernanza**: Límites y estándares de calidad.
- **Criterios de validación**: Métricas de consistencia, usabilidad y satisfacción.

### 1.3. Principio Fundamental
> *"La identidad de un terapeuta es su firma digital. El Behavioral Brand Studio permite que cada terapeuta tenga una presencia única y profesional, sin sacrificar la coherencia y calidad del ecosistema BehavioralOS. La marca no es un lujo; es una herramienta de confianza."*

---

## 2. Filosofía del Brand Studio

### 2.1. Principios de Diseño

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Coherencia** | La marca debe ser consistente en todos los puntos de contacto. | La paleta de colores y tipografía se aplican automáticamente en toda la plataforma. |
| 2 | **Personalización** | Cada terapeuta debe poder expresar su identidad única. | Colores, logo, tipografía, imágenes personalizadas. |
| 3 | **Calidad** | La personalización debe mantener los estándares de diseño del BDS. | Validación automática de colores, contraste y legibilidad. |
| 4 | **Simplicidad** | La personalización debe ser fácil y sin necesidad de conocimientos técnicos. | Interfaz intuitiva con previsualización en tiempo real. |
| 5 | **Centralización** | Todos los activos de marca deben gestionarse desde un solo lugar. | Panel de control unificado en el Brand Studio. |
| 6 | **Escalabilidad** | El sistema debe soportar desde terapeutas independientes hasta grandes clínicas. | Gestión de múltiples marcas (clínicas, sub-marcas). |

### 2.2. Inspiración

El BBS se inspira en herramientas de personalización de marca como **Canva (para diseño de activos)**, **Wix (para personalización de sitios web)** y **Shopify (para gestión de identidad de tienda)** , pero adaptado específicamente a las necesidades de psicólogos y terapeutas.

---

## 3. Arquitectura del Brand Studio

### 3.1. Visión General

┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Brand Studio (BBS) │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Identity Visual Manager │ │
│ │ • Colores (primario, secundario, acento, fondo, texto) │ │
│ │ • Logo (subida y gestión de versiones) │ │
│ │ • Tipografía (fuentes, tamaños, estilos) │ │
│ │ • Iconografía (estilo, color, tamaño) │ │
│ │ • Imágenes (fotos de portada, perfiles, fondos) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Experience Personalization Engine │ │
│ │ • Aplicación de la marca en la Patient App │ │
│ │ • Personalización del portal del paciente (BPOS) │ │
│ │ • Personalización del sitio web (BWB) │ │
│ │ • Personalización de comunicaciones (correos, notificaciones) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Asset Management │ │
│ │ • Almacenamiento de activos (logo, imágenes, documentos) │ │
│ │ • Versionado de activos │ │
│ │ • Uso y distribución de activos │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Brand Governance & Quality │ │
│ │ • Validación de contraste y legibilidad │ │
│ │ • Verificación de accesibilidad (WCAG) │ │
│ │ • Recomendaciones de mejora │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 3.2. Componentes del BBS

| Componente | Descripción | Tecnología | Notas (Gratuito) |
|------------|-------------|------------|------------------|
| **Identity Visual Manager** | Gestión de colores, logo, tipografía e iconografía. | React + Supabase | Open source |
| **Experience Personalization Engine** | Aplicación de la marca en todos los puntos de contacto. | React + CSS Variables + Supabase | Open source |
| **Asset Management** | Almacenamiento y versionado de activos de marca. | Supabase Storage | Plan gratuito (1 GB) |
| **Brand Governance & Quality** | Validación de contraste, legibilidad y accesibilidad. | Python + Color Contrast Checker | Open source |

---

## 4. Gestión de Identidad Visual

### 4.1. Colores

| Elemento | Descripción | Configuración |
|----------|-------------|---------------|
| **Primario** | Color principal de la marca (ej. botones, enlaces, encabezados). | Selector de color (hex, rgb). |
| **Secundario** | Color secundario (ej. acentos, badges, destacados). | Selector de color (hex, rgb). |
| **Acento** | Color de acento (ej. llamadas a la acción, elementos destacados). | Selector de color (hex, rgb). |
| **Fondo** | Color de fondo (ej. fondos de pantalla, tarjetas). | Selector de color (hex, rgb). |
| **Texto** | Color de texto (ej. títulos, párrafos). | Selector de color (hex, rgb). |
| **Texto secundario** | Color de texto secundario (ej. descripciones, subtítulos). | Selector de color (hex, rgb). |

**Validación automática**:
- Contraste mínimo WCAG AA (4.5:1 para texto normal, 3:1 para texto grande).
- Recomendaciones de mejora de contraste si no se cumple.

### 4.2. Logo

| Elemento | Descripción | Configuración |
|----------|-------------|---------------|
| **Logo principal** | Logo principal de la marca (horizontal). | Subida de archivo (PNG, SVG, JPG). |
| **Logo alternativo** | Logo para fondos oscuros o espacios reducidos. | Subida de archivo (PNG, SVG). |
| **Favicon** | Icono para la pestaña del navegador. | Subida de archivo (ICO, PNG). |
| **Logo para redes** | Logo para redes sociales (cuadrado). | Subida de archivo (PNG, JPG). |

**Recomendaciones**:
- Tamaño recomendado: 500x200 px (logo principal).
- Formato: PNG con transparencia o SVG (vectorial).
- Fondo: transparente para mejor integración.

### 4.3. Tipografía

| Elemento | Descripción | Configuración |
|----------|-------------|---------------|
| **Títulos** | Fuente para títulos y encabezados. | Google Fonts (selección de fuentes). |
| **Cuerpo** | Fuente para texto principal. | Google Fonts (selección de fuentes). |
| **Botones** | Fuente para botones y CTAs. | Google Fonts (selección de fuentes). |
| **Tamaños** | Tamaños de fuente para diferentes elementos (títulos, cuerpo, botones). | Escala tipográfica (ej. 16px, 24px, 32px). |

**Recomendaciones**:
- Legibilidad: Fuentes sans-serif recomendadas (ej. Inter, Roboto, Open Sans).
- Combinaciones: Sugerencias de combinaciones de fuentes.

### 4.4. Iconografía

| Elemento | Descripción | Configuración |
|----------|-------------|---------------|
| **Estilo** | Estilo de los iconos (línea, relleno, duotono). | Selección de estilo. |
| **Color** | Color de los iconos (basado en la paleta de colores). | Automático (primario, secundario). |
| **Tamaño** | Tamaño de los iconos (16px, 24px, 32px, 48px). | Selección de tamaño. |

### 4.5. Imágenes

| Elemento | Descripción | Configuración |
|----------|-------------|---------------|
| **Foto de perfil** | Foto del terapeuta o clínica. | Subida de archivo (JPG, PNG). |
| **Foto de portada** | Imagen de portada para el sitio web y la app. | Subida de archivo (JPG, PNG). |
| **Fotos de fondo** | Imágenes de fondo para el sitio web. | Subida de archivo (JPG, PNG). |
| **Fotos de equipo** | Fotos del equipo de terapeutas (si aplica). | Subida de archivo (JPG, PNG). |

---

## 5. Personalización de la Experiencia del Paciente

### 5.1. Aplicación en la Patient App (Nintendo)

| Elemento | Personalización | Ejemplo |
|----------|-----------------|---------|
| **Colores primarios/secundarios** | La paleta de colores del terapeuta se aplica a los elementos de la app. | Los botones y encabezados usan el color primario del terapeuta. |
| **Logo** | El logo del terapeuta aparece en la pantalla de inicio y en el perfil. | Logo en el encabezado de la Patient App. |
| **Avatar del compañero** | Personalización del avatar del compañero (TCCN) con colores de la marca. | Colores de la marca en el avatar del compañero. |
| **Temas** | Temas visuales que reflejan la identidad del terapeuta. | Estilo "cálido" o "profesional" según la marca. |

### 5.2. Aplicación en el Portal del Paciente (BPOS)

| Elemento | Personalización | Ejemplo |
|----------|-----------------|---------|
| **Encabezado** | Logo y colores de la marca en el encabezado del portal. | Portal del paciente con logo del terapeuta. |
| **Comunicaciones** | Correos y notificaciones con los colores y logo de la marca. | Correo de confirmación con los colores de la clínica. |
| **Formularios** | Formularios con los colores de la marca. | Formulario de consentimiento con los colores de la clínica. |

### 5.3. Aplicación en el Sitio Web (BWB)

| Elemento | Personalización | Ejemplo |
|----------|-----------------|---------|
| **Diseño** | Plantilla del sitio web con los colores y logo de la marca. | Sitio web del terapeuta con su identidad visual. |
| **Tipografía** | Fuentes seleccionadas por el terapeuta. | Títulos con la fuente de la marca. |
| **Imágenes** | Imágenes de portada y perfil del terapeuta. | Foto de portada del consultorio. |

---

## 6. Gestión de Activos de Marca

### 6.1. Almacenamiento

- **Ubicación**: Supabase Storage (bucket `brand-assets`).
- **Estructura**: `{tenant_id}/{asset_type}/{version}/{filename}`.
- **Seguridad**: Acceso solo al terapeuta y a los usuarios autorizados.

### 6.2. Versionado

| Versión | Descripción | Acción |
|---------|-------------|--------|
| **v1** | Versión inicial del logo. | Subida inicial. |
| **v2** | Logo actualizado (ej. cambio de diseño). | Subida de nueva versión; la anterior queda como historial. |
| **v3** | Logo optimizado para diferentes formatos. | Subida de múltiples versiones (ej. horizontal, cuadrado). |

### 6.3. Uso y Distribución

- **CDN**: Los activos se sirven a través de un CDN para carga rápida.
- **Formatos**: PNG (para imágenes), SVG (para logos vectoriales), ICO (para favicon).

---

## 7. Políticas de Uso y Gobernanza

### 7.1. Estándares de Calidad

| Estándar | Descripción | Verificación |
|----------|-------------|--------------|
| **Contraste** | Contraste mínimo WCAG AA (4.5:1 para texto normal, 3:1 para texto grande). | Validación automática en el BBS. |
| **Legibilidad** | Tamaño de fuente mínimo de 14px para texto normal. | Verificación automática. |
| **Formato de logo** | PNG con transparencia o SVG. | Validación de formato al subir. |
| **Tamaño de imagen** | Tamaño máximo de 5MB por imagen. | Validación de tamaño al subir. |
| **Coherencia** | Los colores deben ser accesibles y no generar confusión. | Recomendaciones de mejora. |

### 7.2. Límites de Personalización

| Elemento | Límite | Justificación |
|----------|--------|---------------|
| **Colores** | El color primario y secundario deben tener contraste suficiente. | Accesibilidad. |
| **Tipografía** | Solo fuentes de Google Fonts (para garantizar rendimiento). | Rendimiento y coherencia. |
| **Logo** | El logo debe ser profesional y no contener elementos ofensivos. | Revisión manual (opcional) y políticas de uso. |

### 7.3. Gobernanza

- **Revisión automática**: El BBS valida automáticamente los elementos de marca.
- **Revisión manual (opcional)**: Para clínicas grandes, se puede solicitar una revisión manual por el equipo de BehavioralOS.
- **Políticas de uso**: El terapeuta acepta los términos de uso de la marca al personalizar su identidad.

---

## 8. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Consistencia** | 100% de los puntos de contacto (app, web, comunicaciones) muestran la marca correctamente. | Pruebas de integración |
| **Accesibilidad** | 100% de las combinaciones de colores cumplen con WCAG AA. | Validación automática |
| **Rendimiento** | Los activos de marca se cargan en < 200ms. | Monitoreo de rendimiento |
| **Usabilidad** | El terapeuta puede personalizar su marca en < 15 minutos. | Pruebas de usabilidad |
| **Satisfacción** | ≥ 4.5/5 en encuestas de satisfacción con la personalización. | Encuestas in-app |

---

## 9. El Manifiesto del BBS

> *"La marca de un terapeuta no es solo un logo. Es la promesa de confianza, de cuidado y de profesionalismo.*
>
> *El Behavioral Brand Studio permite a los terapeutas y clínicas construir una identidad visual coherente y memorable que se extiende a todos los puntos de contacto con el paciente: el sitio web, la aplicación, las comunicaciones y el portal del paciente.*
>
> *No se trata solo de personalización. Se trata de coherencia, de profesionalismo y de crear una experiencia unificada que genere confianza.*
>
> *Nuestra responsabilidad es garantizar que el BBS sea fácil, rápido, seguro y que mantenga los estándares de calidad del ecosistema BehavioralOS. Que cada terapeuta pueda tener una identidad digital única, sin sacrificar la excelencia."*

---

## 10. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-02 | Diseño UX/UI | Creación del documento. Definición del Behavioral Brand Studio: gestión de identidad visual, personalización de la experiencia del paciente, integración con BWB y BPOS, gestión de activos de marca, políticas de uso y criterios de validación. |

---

**Fin del documento `brand-studio.md`**