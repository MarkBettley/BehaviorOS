---
id: BSOS-001
title: Behavioral Security Operating System (BSOS)
version: 2.0.0
status: Stable
owner: Seguridad & Cumplimiento Normativo
last_updated: 2026-07-14
depends_on:
  - 000-Core/philosophy.md (Filosofía - dignidad, respeto, autonomía)
  - 000-Core/principles.md (Principios - seguridad, privacidad, ética)
  - 100-Architecture/system-architecture.md (BEA - capa de seguridad)
  - 200-Backend/database-graph.md (Database Graph - RLS, cifrado)
  - 200-Backend/api-graph.md (API Graph - autenticación, autorización)
  - 300-Frontend/accessibility.md (Accesibilidad - consentimiento accesible)
  - 400-AI/guardrails.md (Guardrails - seguridad de IA, Crisis Interceptor)
  - 600-Commerce/business-model.md (BCE - seguridad financiera)
  - 000-Infrastructure/selection.md (Infraestructura)
exports:
  - Arquitectura del BSOS (componentes, flujos)
  - Identidad y autenticación (JWT, OAuth, WebAuthn, 2FA, SSO)
  - Autorización (RBAC + ABAC + ReBAC + RLS)
  - Consentimientos granulares (BCPOS)
  - Cifrado y protección de datos (AES-256, TLS 1.3)
  - Auditoría y trazabilidad (logs inmutables)
  - Protocolo de crisis (suicidio/autolesión)
  - Compliance FDA y EU MDR/AI Act
  - Human-in-the-loop obligatorio
  - Términos y Condiciones / Disclaimer legal
  - Cumplimiento normativo (LFPDPPP, GDPR, HIPAA)
  - Gestión de incidentes de seguridad
used_by:
  - Todos los módulos (autenticación, autorización, cifrado)
  - Patient App (consentimientos, autenticación, protocolo de crisis)
  - Therapist App (autenticación, autorización, auditoría)
  - Admin Dashboard (gestión de usuarios, auditoría)
  - BCGS (cumplimiento normativo)
  - BQAS (pruebas de seguridad)
---

# BehavioralOS – Behavioral Security Operating System (BSOS) (v2.0.0)

> *"La seguridad no es un complemento. Es la base sobre la que se construye toda la confianza del ecosistema. Los pacientes confían sus datos más íntimos, los terapeutas confían la práctica clínica, y la plataforma debe proteger esa confianza con los más altos estándares."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Security Operating System (BSOS)**, el sistema de seguridad y gobernanza del BehavioralOS. Su objetivo es:

- **Proteger la identidad y los datos** de todos los usuarios.
- **Garantizar la privacidad** mediante consentimientos granulares, cifrado y anonimización.
- **Controlar el acceso** con políticas RBAC, ABAC, ReBAC y RLS.
- **Asegurar el cumplimiento normativo** con regulaciones aplicables.
- **Implementar el protocolo de crisis** para situaciones de ideación suicida/autolesión.
- **Establecer el compliance** con FDA (enforcement discretion) y EU MDR/AI Act.
- **Definir los Términos y Condiciones** / Disclaimer legal obligatorio.
- **Auditar todas las acciones críticas** para garantizar trazabilidad.

### 1.2. Alcance
El documento cubre:

- **Identidad y autenticación**: JWT, OAuth2, WebAuthn, 2FA, SSO.
- **Autorización**: RBAC, ABAC, ReBAC, RLS (PostgreSQL).
- **Consentimientos granulares (BCPOS)**: Consentimiento explícito, reversible y auditado.
- **Cifrado**: AES-256 en reposo, TLS 1.3 en tránsito.
- **Auditoría**: Registro inmutable de acciones críticas con hash y firma.
- **Protocolo de crisis**: Detección, contención, notificación al terapeuta, recursos de emergencia.
- **Compliance normativo**: FDA, EU MDR/AI Act, LFPDPPP, GDPR, HIPAA.
- **Human-in-the-loop**: Validación obligatoria del psicólogo para decisiones clínicas.
- **Términos y Condiciones**: Disclaimer legal que debe aceptar el usuario al abrir la app.
- **Gestión de incidentes**: Detección, respuesta, recuperación.

### 1.3. Principio Fundamental
> **"La confianza es el activo más valioso del BehavioralOS. Cada usuario confía sus datos más íntimos a la plataforma. Cada interacción, cada dato, cada conversación debe estar protegida como si fuera la nuestra."**

---

## 2. Protocolo de Crisis (NUEVO v2.0.0)

### 2.1. Concepto

El **Protocolo de Crisis** es un conjunto de mecanismos de seguridad diseñados para proteger la vida del paciente cuando el sistema detecta indicadores de ideación suicida o autolesión. Es la prioridad absoluta del sistema.

### 2.2. Flujo del Protocolo

```
[Mensaje del paciente con indicadores de crisis]
         │
         ▼
┌───────────────────────────────────────────────────┐
│     CRISIS INTERCEPTOR (Guardrails)              │
│     Filtro regex + Clasificación semántica        │
└────────────────┬──────────────────────────────────┘
                 │
         ┌───────┴───────┐
         │               │
    [Sin crisis]    [Crisis detectada]
         │               │
         ▼               ▼
  [Pipeline normal]  [Protocolo de Contención]
                         │
                         ├─→ Congelar gamificación
                         ├─→ Mostrar números de emergencia
                         ├─→ Notificar al psicólogo
                         ├─→ Bloquear juegos
                         ├─→ Registrar incidente
                         └─→ Activar modo crisis
```

### 2.3. Acciones del Protocolo

| Acción | Descripción | Tiempo objetivo |
|--------|-------------|-----------------|
| **Congelar gamificación** | Se desactivan todos los elementos de juego y recompensas | Inmediato |
| **Inyectar mensaje de crisis** | Respuesta empática con recursos de ayuda | < 500ms |
| **Mostrar números de emergencia** | Líneas de ayuda localizadas por país | Inmediato |
| **Notificar al psicólogo** | Alerta en tiempo real con evidencia | < 2 segundos |
| **Bloquear juegos** | Se ocultan misiones, minijuegos y elementos lúdicos | Inmediato |
| **Registrar incidente** | Log inmutable con toda la información del evento | < 1 segundo |
| **Activar modo crisis** | Interfaz cambia a modo neutro de apoyo | Inmediato |

### 2.4. Recursos de Emergência

El sistema mantiene una base de datos actualizada de líneas de ayuda por país:

| País | Línea | Número |
|------|-------|--------|
| México | SAPTEL | 800-290-0024 |
| Argentina | Línea de la Vida | 135 |
| España | Línea de la Salud Mental | 024 |
| Colombia | Línea 106 | 106 |
| Chile | Salud Responde | 600-360-7777 |
| Perú | Línea de la Vida | 0800-2-9000 |
| Estados Unidos | National Suicide Prevention | 988 |
| Brasil | CVV | 188 |

### 2.5. Modo Crisis

Cuando se activa el modo crisis:

- **Se desactivan todos los juegos y misiones**.
- **Se ocultan elementos de gamificación**.
- **La interfaz cambia a modo neutro** (colores suaves, sin animaciones de celebración).
- **El companion cambia de tono** a modo de apoyo emocional directo.
- **Se muestran recursos de ayuda** de forma prominente.
- **El modo crisis permanece activo** hasta que el psicólogo lo desactive manualmente.

---

## 3. Compliance FDA y EU MDR/AI Act (NUEVO v2.0.0)

### 3.1. FDA (Estados Unidos)

Bajo la guía de la FDA para **Clinical Decision Support Software**:

| Criterio | Implementación |
|----------|----------------|
| **Enforcement Discretion** | Aplicable: el psicólogo puede revisar y entender la base de las recomendaciones (citas textuales de la charla). |
| **Clasificación** | Software de Soporte a la Decisión Clínica (CDSS). |
| **Requisito principal** | Transparencia: el profesional debe ver las evidencias que justifican el análisis. |
| **Human-in-the-loop** | Toda información y propuestas deben ser validadas por el psicólogo. |
| **Ventaja** | Reducción drástica de barreras burocráticas para salir al mercado. |

### 3.2. EU MDR / AI Act (Europa)

| Criterio | Implementación |
|----------|----------------|
| **Clasificación MDR** | Clase I / IIa (herramienta de triaje secundario y soporte). |
| **AI Act** | No cae en categorías de alto riesgo (IA autónoma de salud mental). |
| **Proceso CE** | Significativamente más rápido y económico que clasificaciones de alto riesgo. |
| **Requisito** | Human-in-the-loop obligatorio. |
| **Responsabilidad** | El psicólogo conserva la responsabilidad clínica; la IA actúa como asistente. |

### 3.3. Human-in-the-Loop Obligatorio

El sistema está diseñado para que **toda la información y propuestas de juego sean validadas obligatoriamente por el psicólogo**:

| Flujo | Descripción |
|-------|-------------|
| 1. IA analiza charla casual | Gemma 4 procesa el mensaje y genera análisis |
| 2. Análisis se envía al panel del terapeuta | El psicólogo revisa el JSON con citas textuales |
| 3. Psicólogo valida o rechaza | Acepta, modifica o rechaza la propuesta |
| 4. Solo entonces se activa en la app | La misión o análisis llega al paciente |
| 5. Psicólogo conserva responsabilidad clínica | La IA actúa solo como asistente de preparación |

---

## 4. Términos y Condiciones / Disclaimer Legal (NUEVO v2.0.0)

### 4.1. Disclaimer Obligatorio

Al abrir la app por primera vez, el usuario **debe aceptar** los Términos y Condiciones que incluyen:

```markdown
TÉRMINOS Y CONDICIONES - BEHAVIORALOS

1. NATURALEZA DEL SERVICIO
BehavioralOS es una herramienta de soporte a la decisión clínica (CDSS) 
que funciona como complemento a la terapia presencial o remota con un 
profesional de la salud mental. NO sustituye la atención profesional.

2. LIMITACIÓN DE RESPONSABILIDAD
El análisis realizado por la inteligencia artificial es orientativo y 
debe ser validado por un profesional de la salud mental. Los resultados 
no constituyen diagnóstico médico ni recomendación de tratamiento.

3. PROTOCOLO DE CRISIS
En caso de emergencia, Contacte inmediatamente a los servicios de 
emergencia de su país. La aplicación proporciona números de ayuda 
pero NO garantiza disponibilidad inmediata.

4. PRIVACIDAD DE DATOS
Sus datos son procesados conforme a nuestra Política de Privacidad. 
Los datos clínicos son cifrados y accesibles exclusivamente por su 
profesional de salud mental asignado.

5. USO ACEPTABLE
La aplicación debe utilizarse únicamente para los fines descritos. 
Queda prohibido intentar manipular, engañar o explotar el sistema de IA.

6. EDAD MÍNIMA
El servicio está destinado a usuarios mayores de 16 años. Para menores 
de edad, se requiere consentimiento del padre, madre o tutor legal.
```

### 4.2. Flujo de Aceptación

1. **Primera apertura**: Se muestra el disclaimer completo.
2. **Aceptación explícita**: El usuario debe hacer clic en "Acepto" (no pre-marcado).
3. **Registro de aceptación**: Se almacena timestamp y versión del disclaimer.
4. **Re-aceptación**: Si los términos cambian significativamente, se solicita re-aceptación.
5. **Acceso condicional**: Sin aceptación, no se permite el uso de la app.

### 4.3. Datos Almacenados del Consentimiento

| Campo | Descripción |
|-------|-------------|
| `usuario_id` | ID del usuario |
| `version_terminos` | Versión del disclaimer aceptado |
| `timestamp_aceptacion` | Fecha/hora de aceptación |
| `ip_address` | Dirección IP (para auditoría) |
| `metodo_aceptacion` | Clic en botón "Acepto" |

---

## 5. Filosofía del BSOS

### 5.1. Principios de Seguridad

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Zero Trust** | Nunca confiar, siempre verificar | Cada petición se autentica y autoriza |
| 2 | **Privacy by Design** | La privacidad es nativa | Datos minimizados, cifrados por defecto |
| 3 | **Security by Design** | Seguridad desde el diseño | Análisis de amenazas, pruebas de penetración |
| 4 | **Minimización de datos** | Solo información necesaria | Cada campo tiene justificación clara |
| 5 | **Transparencia** | Usuarios saben qué datos se recopilan | Políticas claras, consentimientos explícitos |
| 6 | **Responsabilidad** | Cada acción es trazable | Auditoría inmutable |
| 7 | **Resiliencia** | Resistir y recuperarse de incidentes | Backups cifrados, planes de recuperación |
| 8 | **Crisis como prioridad** | La vida del paciente supera todo | Protocolo de crisis se ejecuta primero |

---

## 6. Identidad y Autenticación

### 6.1. Métodos Soportados

| Método | Uso | Plataforma |
|--------|-----|------------|
| **JWT** | Tokens de sesión | Todas |
| **OAuth2** | Autenticación con terceros (Google, Apple) | Web, Móvil |
| **WebAuthn** | Autenticación biométrica (huella, rostro) | Móvil |
| **2FA** | Autenticación de dos factores | Todas |
| **SSO** | Single Sign-On para organizaciones | Web |

### 6.2. Flujo de Autenticación

```
[Usuario] → [Login] → [Verificación] → [Token JWT] → [Acceso]
                              │
                    ┌─────────┴─────────┐
                    │                   │
               [Credenciales]      [Biométrico]
               [OTP/2FA]           [WebAuthn]
```

---

## 7. Autorización

### 7.1. Modelo de Control de Acceso

| Capa | Tecnología | Propósito |
|------|------------|-----------|
| **RBAC** | Roles predefinidos | Acceso por rol (Paciente, Terapeuta, Admin) |
| **ABAC** | Atributos dinámicos | Acceso por contexto (ubicación, dispositivo, hora) |
| **ReBAC** | Relaciones | Acceso por relaciones (terapeuta-paciente) |
| **RLS** | PostgreSQL Row-Level Security | Aislamiento de datos a nivel de fila |

### 7.2. Roles

| Rol | Permisos |
|-----|----------|
| **Paciente** | Leer/escribir sus propios datos, interactuar con IA |
| **Terapeuta** | Leer/escribir datos de sus pacientes, validar propuestas IA |
| **Admin** | Gestionar usuarios, configuración, auditoría |
| **Investigador** | Leer datos anonimizados (con consentimiento) |

---

## 8. Cifrado y Protección de Datos

| Capa | Tecnología | Propósito |
|------|------------|-----------|
| **En reposo** | AES-256 | Proteger datos almacenados |
| **En tránsito** | TLS 1.3 | Proteger datos en movimiento |
| **Extremo a extremo** | Mensajería cifrada | Proteger conversaciones (futuro) |
| **Backups** | Cifrado + offsite | Proteger copias de seguridad |

---

## 9. Auditoría y Trazabilidad

### 9.1. Acciones Auditadas

| Acción | Prioridad |
|--------|-----------|
| Login/logout | Alta |
| Acceso a datos clínicos | Crítica |
| Validación de propuestas IA | Crítica |
| Activación de protocolo de crisis | Crítica |
| Cambios en configuración | Alta |
| Exportación de datos | Alta |
| Consentimientos | Crítica |

### 9.2. Formato de Log

```json
{
  "event_id": "uuid",
  "timestamp": "2026-07-14T10:30:00Z",
  "actor_id": "hashed_user_id",
  "actor_role": "terapeuta",
  "action": "validar_propuesta_ia",
  "resource": "propuesta_mision_123",
  "details": {...},
  "ip_address": "hashed_ip",
  "hash": "sha256_of_event"
}
```

---

## 10. Gestión de Incidentes

### 10.1. Flujo de Gestión

```
[Detección] → [Clasificación] → [Respuesta] → [Recuperación] → [Lecciones]
     │              │                │               │               │
  Automática    Nivel de         Inmediata      Restauración    Mejora
  o manual      severidad        o escalada     del servicio    continua
```

### 10.2. Niveles de Severidad

| Nivel | Descripción | Tiempo de respuesta |
|-------|-------------|---------------------|
| **Crítico** | Riesgo de vida, pérdida de datos masiva | < 1 hora |
| **Alto** | Vulnerabilidad de seguridad, fallo de sistema | < 4 horas |
| **Medio** | Bug con impacto parcial | < 24 horas |
| **Bajo** | Mejora menor, cosmético | Siguiente sprint |

---

## 11. Criterios de Validación

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| Autenticación | 100% endpoints protegidos | Pruebas de penetración |
| Cifrado | 100% datos en reposo cifrados | Auditoría de infraestructura |
| Auditoría | 100% acciones críticas registradas | Revisión de logs |
| Crisis Interceptor | >99% recall en ideación suicida | Evaluación clínica |
| Compliance FDA | 100% trazabilidad verificada | Auditoría interna |
| Compliance EU MDR | 100% human-in-the-loop verificado | Logs de validación |
| Consentimiento | 100% usuarios con disclaimer aceptado | Métricas de uso |
| Incidentes | Tiempo de respuesta < SLA | Monitoreo |

---

## 12. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Seguridad | Creación inicial: identidad, autorización, cifrado, auditoría, cumplimiento. |
| 2.0.0 | 2026-07-14 | Seguridad | Agregado: Protocolo de crisis (suicidio/autolesión), compliance FDA/EU MDR/AI Act, human-in-the-loop obligatorio, Términos y Condiciones / Disclaimer legal. |
| 2.1.0 | 2026-07-23 | Arquitectura de Software | Nueva sección §13: Tipos de Transformación Criptográfica. Distinción clara entre Encoding, Hashing y Encriptación con reglas de uso. Referencia a TCD-001. |

---

## 13. Tipos de Transformación Criptográfica

El BSOS distingue claramente tres tipos de transformación. Usar la incorrecta constituye una **violación de seguridad**.

| Tipo | Propósito | ¿Reversible? | Ejemplo en BehavioralOS | Algoritmo | ¿Seguro para datos sensibles? |
|------|-----------|-------------|------------------------|-----------|------------------------------|
| **Encoding** | Transporte/representación | Sí, sin llave | Base64 del payload JWT, URL encoding | Base64, URL Encode, Hex | NO — cero seguridad |
| **Hashing** | Verificación sin revelar original | NO (irreversible) | Hash de eventos de auditoría, passwords | SHA-256 (integridad), **Bcrypt/Argon2id** (passwords) | SÍ, pero elegir algoritmo correcto |
| **Encriptación** | Confidencialidad reversible | Sí, con llave | Datos en reposo (AES-256), backups | AES-256-GCM, RSA (intercambio) | SÍ, si la llave está protegida |

### 13.1. Reglas de uso

| Regla | Descripción | Consecuencia de violación |
|-------|-------------|---------------------------|
| **Passwords con hash lento** | NUNCA SHA-256. Usar Bcrypt (costo ≥ 12) o Argon2id. | Vulnerabilidad crítica — Rainbow Tables y GPU brute force |
| **Hash de auditoría** | SHA-256 es ACEPTABLE para integridad de eventos porque no almacena secretos. | Seguro — solo integridad |
| **JWT no es cifrado** | El contenido del payload JWT es legible en Base64. No almacenar datos sensibles. | Exposición de datos si se pone información sensible en el payload |
| **Encoding no es seguridad** | Base64, URL Encode, Hex son representación, no protección. | Vulnerabilidad crítica si se usa como medida de seguridad |
| **Cifrado con llave protegida** | AES-256-GCM para datos en reposo. La llave nunca debe estar en código fuente. | Exposición de datos si la llave se compromete |

### 13.2. Referencias

Estas reglas son una aplicación directa del principio **Encoding vs Hashing vs Encriptación** definido en `torticode-principles.md` (TCD-001 §3).

---

**Fin del documento `security.md`**
