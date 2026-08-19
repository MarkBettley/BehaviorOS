---
id: PRN-001
title: Principios y Reglas de Oro
version: 1.2.0
status: Stable
owner: Arquitectura & Psicología Clínica
last_updated: 2026-07-27
depends_on:
  - PHI-001 (Filosofía)
exports:
  - 12 Principios de Diseño
  - 10 Reglas de Oro Éticas
  - 5 Principios Torticode de Código
  - 4 Reglas de Nintendo (UI/UX)
  - 4 Reglas de Hayes (Científicas)
  - Criterios de Validación para el BQAS
used_by:
  - BDS (Design System)
  - TCCN (Companion)
  - AAO (Adaptive Orchestrator)
  - AHEE (Adaptive Human Experience)
  - BERL (Exercise Lab)
  - BSOS (Security)
  - BCGS (Governance)
  - TCD-001 (Torticode)
---

# BehavioralOS – Principios y Reglas de Oro

> *"Un principio no es una sugerencia. Es un límite que protege la integridad del ecosistema."*

---

## 1. Propósito de este documento

Este documento establece **las reglas inmutables** que gobiernan todo el BehavioralOS. No son recomendaciones ni buenas prácticas; son **contratos vinculantes** que todo componente, desde la IA hasta el más pequeño botón, debe respetar.

Cada principio aquí definido tiene:
- Una **justificación científica o ética**.
- **Criterios de cumplimiento** medibles.
- **Consecuencias** en caso de violación (bloqueo en CI/CD, alerta en BQAS, etc.).

---

## 2. Los 12 Principios de Diseño (BDS + Experiencia)

Estos principios son la base del Behavioral Design System (BDS) y se aplican a todas las interfaces, interacciones y flujos del ecosistema.

| # | Principio | Definición | Criterio de cumplimiento | Violación |
|---|-----------|------------|--------------------------|-----------|
| 1 | **Toda pantalla debe provocar una conducta** | Nunca mostrar información pasivamente. La interfaz debe inducir una acción o reflexión. | Cada pantalla tiene al menos un llamado a la acción (CTA) o una pregunta abierta. | Pantallas puramente informativas sin interacción. |
| 2 | **Reducir fricción, no esfuerzo** | Eliminar barreras para empezar, pero mantener desafío para aprender. | El usuario puede iniciar cualquier experiencia en ≤ 3 segundos desde el Home. | Formularios largos antes de la primera interacción. |
| 3 | **El feedback siempre debe enseñar** | Nunca decir "Correcto/Incorrecto". Siempre ofrecer información funcional. | Cada retroalimentación incluye una observación sobre el comportamiento (ej. "Observa cómo cambió tu respuesta"). | Feedback binario (éxito/fracaso) sin aprendizaje. |
| 4 | **La incertidumbre debe generar curiosidad, no ansiedad** | Usar la incertidumbre para invitar a descubrir, no para confundir o angustiar. | El lenguaje de la IA incluye frases como "Interesante…", "No estamos seguros todavía…", "¿Nos ayudas a comprobar…?". | Mensajes que generan presión o miedo al error. |
| 5 | **El progreso debe ser funcional** | Mostrar cambio conductual observable, no puntuaciones abstractas. | Los indicadores de progreso se expresan en términos de conductas (ej. "Esta semana enfrentaste 3 conversaciones difíciles"). | Barras de progreso genéricas (ej. "Nivel 5", "87% completado"). |
| 6 | **Las recompensas deben reforzar aprendizaje** | No monedas ni diamantes. La recompensa principal es el descubrimiento, la competencia, la autonomía y la comprensión. | Las recompensas son siempre un "descubrimiento" documentado en el Diario. | Recompensas decorativas sin valor conductual. |
| 7 | **La IA nunca es protagonista** | El protagonista siempre es el usuario. La IA acompaña, sugiere, pregunta, resume, pero nunca presume ni decide por el usuario. | La IA nunca usa la primera persona para atribuirse logros. Siempre usa "tú" o "hemos". | Frases como "Yo te ayudé a..." o "Yo detecté que...". |
| 8 | **Cada interacción debe respetar la autonomía** | El usuario siempre tiene opción de pausar, cambiar, posponer, adaptar o elegir. | Cada flujo incluye al menos una opción de "saltar", "más tarde" o "cambiar". | Flujos lineales sin alternativas. |
| 9 | **El error es información, no fracaso** | Cada error reduce la incertidumbre del modelo y aporta evidencia clínica. | Los errores se presentan como "información nueva" y se registran en el Behavioral Twin. | Mensajes de error punitivos o culpabilizantes. |
| 10 | **La experiencia termina en el mundo real** | El objetivo de cada experiencia es una conducta fuera de la app. | Cada ejercicio termina con una "misión en el mundo real" (ej. "Hoy, observa una situación sin reaccionar"). | Ejercicios que solo existen dentro de la app. |
| 11 | **El tiempo de pantalla debe ser el mínimo necesario** | La app no busca retener al usuario; busca que desarrolle habilidades para vivir fuera de ella. | La IA puede sugerir "Ya es suficiente por hoy" y cerrar la experiencia. | Notificaciones que incentivan el uso excesivo. |
| 12 | **La plataforma debe hacerse innecesaria con el tiempo** | El éxito se mide por la autonomía del usuario, no por su dependencia de la app. | La app incluye un "modo mantenimiento" de baja frecuencia después del alta. | Estrategias de retención artificial (rachas, recordatorios forzados). |

---

## 3. Las 10 Reglas de Oro Éticas (Inquebrantables)

Estas reglas son **absolutas**. Ninguna circunstancia, ni siquiera presiones comerciales o técnicas, puede justificar su violación.

| # | Regla | Justificación | Consecuencia de violación |
|---|-------|---------------|---------------------------|
| 1 | **Jamás castigar** | El castigo reduce la motivación intrínseca y puede dañar la alianza terapéutica. | Bloqueo automático en CI/CD. Requiere revisión ética. |
| 2 | **Jamás manipular mediante culpa o vergüenza** | La culpa y la vergüenza son contrarias a la autocompasión y la flexibilidad psicológica. | Alerta en BCGS; requiere aprobación del comité de ética. |
| 3 | **La IA nunca contradice al terapeuta** | El juicio clínico profesional es insustituible. La IA es un asistente, no un decisor. | Si se detecta contradicción, la IA se inhibe y solicita validación humana. |
| 4 | **Nunca mostrar información clínica sin contexto** | Los datos aislados pueden ser malinterpretados y generar ansiedad. | Cada dato clínico mostrado debe ir acompañado de una explicación funcional. |
| 5 | **La incertidumbre nunca se oculta** | La transparencia es clave para la confianza. | Toda inferencia debe incluir un nivel de confianza explícito. |
| 6 | **El usuario conserva la agencia** | La app no decide por el usuario. Siempre hay opción de rechazar, posponer o cambiar. | Cualquier flujo que fuerce una acción sin alternativa es inválido. |
| 7 | **Toda intervención debe tener propósito clínico** | No se puede añadir gamificación por sí sola; debe estar al servicio del cambio conductual. | Cada minijuego debe tener un proceso psicológico asociado. |
| 8 | **Los datos se minimizan** | Solo se recopila información necesaria para el objetivo clínico. | Cada campo de datos debe justificarse en la ontología. |
| 9 | **El error pertenece al sistema, no al usuario** | Si una recomendación falla, es un error del modelo, no del paciente. | Los errores se registran para mejorar el modelo, no para culpabilizar. |
| 10 | **La relación terapéutica es irreemplazable** | La IA no sustituye la relación humano-humano. | La IA nunca actúa como terapeuta principal. Siempre es un copiloto. |

---

## 4. Las 4 Reglas de Nintendo (UI/UX para el paciente)

Inspiradas en la filosofía de diseño de Shigeru Miyamoto, estas reglas garantizan que la experiencia del paciente sea **intrínsecamente motivante**.

| # | Regla | Explicación | Ejemplo de aplicación |
|---|-------|-------------|------------------------|
| 1 | **¿Es comprensible?** | El usuario sabe qué hacer sin leer un manual. | Las animaciones y el contexto visual guían la acción. No hay instrucciones largas. |
| 2 | **¿Es interesante?** | Despierta curiosidad inmediatamente. | La IA no dice "Haz este ejercicio"; dice "Hay algo curioso que descubrimos hoy". |
| 3 | **¿Es significativa?** | Produce aprendizaje clínicamente útil. | Cada interacción deja un "descubrimiento" registrado en el Diario. |
| 4 | **¿Invita a volver?** | No porque sea adictiva, sino porque quedó una pregunta abierta sobre uno mismo. | La sesión termina con una invitación: "Mañana podríamos explorar si este patrón aparece en otros contextos". |

---

## 5. Las 4 Reglas de Hayes (Científicas)

Basadas en la ciencia contextual y la Terapia de Aceptación y Compromiso (ACT), estas reglas validan la eficacia clínica de cada experiencia.

| # | Regla | Definición | Métrica de cumplimiento |
|---|-------|------------|-------------------------|
| 1 | **¿Aumenta flexibilidad psicológica?** | La experiencia debe ampliar el repertorio de respuestas del usuario, no reducirlo. | Medición pre/post de flexibilidad en el AAO. |
| 2 | **¿Disminuye evitación experiencial?** | La experiencia debe facilitar el contacto con eventos privados difíciles, no fomentar su huida. | Indicadores de evitación en telemetría. |
| 3 | **¿Favorece conducta valiosa?** | La experiencia debe alinear al usuario con sus valores, no con los objetivos de la app. | Conexión con los valores definidos en el Behavioral Twin. |
| 4 | **¿Genera aprendizaje contextual?** | El aprendizaje debe ser aplicable a múltiples contextos de la vida real, no solo a la app. | Índice de generalización (transferencia a contextos). |

---

## 6. El Ciclo de una Experiencia Perfecta (El "Flow Terapéutico")

Todas las experiencias (ejercicios, misiones, interacciones con la IA) deben seguir este ciclo, que garantiza adherencia y aprendizaje:

1. **Invitación**: Una entrada que despierta curiosidad, no obligación.
2. **Orientación**: El usuario comprende rápidamente qué ocurrirá sin saturarse de instrucciones.
3. **Exploración**: Interactúa, prueba, observa y toma decisiones.
4. **Descubrimiento**: Aparece una diferencia entre lo que esperaba y lo que ocurrió, favoreciendo nuevo aprendizaje.
5. **Integración**: Conecta ese descubrimiento con su vida, sus valores o sus relaciones.
6. **Transferencia**: Sale de la app con una acción concreta para el mundo real.
7. **Retorno**: La experiencia no promete una recompensa futura; deja abierta una nueva pregunta que podrá explorarse más adelante.

**Criterio de validación**: Cada experiencia debe incluir explícitamente al menos una fase de Integración y una de Transferencia.

---

## 7. La Regla de Oro (El Filtro Único)

> **"Cada interacción debe aumentar simultáneamente tres cosas: el aprendizaje psicológico, la motivación para continuar y la calidad de la información clínica disponible."**

### Criterios de cumplimiento

- **Aprendizaje psicológico**: La interacción modifica al menos un proceso identificado en la ontología (ej. defusión, aceptación, valores).
- **Motivación para continuar**: La experiencia genera una "pregunta abierta" o curiosidad por explorar más.
- **Información clínica**: La interacción genera datos que actualizan el Behavioral Twin (ej. tiempo de respuesta, patrones de evitación, elecciones).

**Si una interacción no cumple al menos dos de estos tres criterios, no debe ser implementada.**

---

## 8. Integración con el Sistema de Validación (BQAS)

Estos principios se traducen en **reglas automáticas** dentro del Behavioral Quality Assurance System (BQAS). Ejemplos:

- **Principio 1** (Toda pantalla debe provocar una conducta): El linter de UI verifica que cada pantalla tenga al menos un CTA o una pregunta interactiva.
- **Principio 6** (Recompensas funcionales): El validador de gamificación comprueba que cada recompensa esté vinculada a un "descubrimiento" registrado en el Diario.
- **Regla de Oro**: Los tests de integración verifican que cada interacción genere al menos dos de los tres criterios.
- **Regla de Hayes 1** (Aumenta flexibilidad): Los tests clínicos comparan puntuaciones de flexibilidad antes y después de cada experiencia.

---

## 9. El Manifiesto Operativo

> *"Un principio no es una sugerencia. Es un límite que protege la integridad del ecosistema.*
>
> *Cada vez que enfrentemos una decisión difícil, volveremos a este documento.*
>
> *Si una funcionalidad no cumple estos principios, no importa cuán rentable o innovadora sea: no será implementada.*
>
> *La calidad de la experiencia y la salud de las personas están por encima de cualquier métrica de negocio."*

---

## 10. Principios de Código e Implementación (Torticode)

Además de los principios de diseño conductual, el BehavioralOS se rige por **5 principios de código** que garantizan mantenibilidad, seguridad y rendimiento en toda implementación.

Estos principios están detallados en `torticode-principles.md` (TCD-001) y son de **cumplimiento obligatorio** para todo código generado por IA o desarrolladores.

| # | Principio | Esencia | Documento completo |
|---|-----------|---------|-------------------|
| 1 | **DRY / KISS / YAGNI / Bajo Acoplamiento** | Una sola fuente de verdad, regla de 3, inyección de dependencias | TCD-001 §2 |
| 2 | **Encoding vs Hashing vs Encriptación** | Elegir la transformación correcta según el objetivo de seguridad | TCD-001 §3 |
| 3 | **Big O y Optimización** | No dejar O(n²) en producción, usar Map/Set | TCD-001 §4 |
| 4 | **POO + DDD** | Abstracción (programar contra contratos), Encapsulación (estado privado, métodos semánticos), Herencia (solo relación "es-un", preferir composición), Polimorfismo (eliminar if/else con interfaces). Ver TCD-001 §5 para analogías completas, tablas por lenguaje y ejemplos en BehavioralOS. | TCD-001 §5 |
| 5 | **Testing First** | Pruebas antes que implementación, 100% cobertura de líneas y ramas | TCD-001 (principio transversal) |

> **Nota**: La sección §5 de TCD-001 fue expandida con las analogías del video "4 Pilares de la POO" (Torticode): el cajero automático para Encapsulación, los rasgos familiares para Herencia, el botón de Play para Polimorfismo y el volante del auto para Abstracción. Incluye tablas comparativas por lenguaje (JavaScript, Python, Java, C#) y ejemplos concretos de BehavioralOS para cada pilar.

Estos principios son **tan vinculantes como los 12 principios de diseño** del BehavioralOS. Cualquier código que los viole será rechazado por los quality gates del BQAS.

---

## 11. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura Jefe | Creación del documento. Definición de 12 principios de diseño, 10 reglas éticas, 4 reglas Nintendo, 4 reglas Hayes, y el ciclo de experiencia perfecta. |
| 1.1.0 | 2026-07-23 | Arquitectura de Software | Integración de los 5 principios Torticode de código e implementación (TCD-001). Nueva sección §10. |
| 1.2.0 | 2026-07-27 | Arquitectura de Software | Expansión de la sección §5 de TCD-001 con los 4 pilares de la POO (analogías de Torticode, tablas comparativas, ejemplos en BehavioralOS). Actualización de la tabla en §10 y nota explicativa. |

---

**Fin del documento `principles.md`**