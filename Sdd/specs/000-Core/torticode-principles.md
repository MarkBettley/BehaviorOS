---
id: TCD-001
title: Principios de Código e Implementación (Torticode)
version: 1.1.0
status: Stable
owner: Arquitectura de Software
last_updated: 2026-07-27
depends_on:
  - PRN-001 (Principios y Reglas de Oro)
exports:
  - 5 Principios Torticode de Código
  - Reglas DRY/KISS/YAGNI
  - Tabla Encoding vs Hashing vs Encryption
  - Guía de Big O por contexto
  - Patrones POO/DDD
used_by:
  - 1300-Libraries (generación de código)
  - BQAS (quality gates de código)
  - 100-Architecture (patrones de diseño)
---

# BehavioralOS – Principios de Código e Implementación (Torticode)

> *"Los principios de código no son sugerencias estéticas. Son contratos que garantizan mantenibilidad, seguridad y rendimiento en cada línea del BehavioralOS."*

---

## 1. Propósito

> Los principios de código no son sugerencias estéticas. Son contratos que garantizan mantenibilidad, seguridad y rendimiento en cada línea del BehavioralOS. Todo código generado por IA o por desarrolladores debe cumplirlos.

---

## 2. DRY / KISS / YAGNI / Bajo Acoplamiento y Alta Cohesión

### 2.1. DRY — Don't Repeat Yourself

Una sola fuente de verdad para cada pieza de conocimiento o lógica de negocio. Si un concepto está duplicado, se extrae a una función, clase o módulo compartido.

**Regla de 3**: No se abstrae hasta la tercera repetición. Las primeras dos ocurrencias son aceptables; la tercera obliga a refactorizar.

### 2.2. KISS — Keep It Simple, Stupid

La solución más directa y legible es siempre la preferida. Menos líneas legibles superan a complejidad técnica rebuscada. Un desarrollador nuevo debe entender el código sin esfuerzo.

### 2.3. YAGNI — You Ain't Gonna Need It

Eliminar funciones, parámetros, configuración o lógica "para el futuro". Cero sobreingeniería. Si no se necesita hoy, no se escribe.

### 2.4. Bajo Acoplamiento y Alta Cohesión

- **Bajo Acoplamiento**: Las dependencias entre módulos son explícitas mediante inyección de dependencias. Las clases no crean sus propias herramientas internas; las reciben por contrato (interfaces).
- **Alta Cohesión**: Cada módulo/clase tiene una responsabilidad única y bien definida. Todo lo que contiene está al servicio de esa responsabilidad.

### 2.5. Tabla de Criterios de Cumplimiento

| Principio | Criterio de cumplimiento | Consecuencia de violación |
|-----------|--------------------------|---------------------------|
| **DRY** | No hay bloques de código duplicados > 5 líneas idénticas en más de 2 archivos | Bloqueo en code review. Requiere refactorización antes de merge |
| **KISS** | Complejidad ciclomática por función ≤ 10 | Falla en BQAS si supera el límite |
| **YAGNI** | No hay parámetros/funciones sin uso en producción | Alerta de código muerto en CI. Se elimina en la siguiente limpieza |
| **Bajo Acoplamiento** | Todas las dependencias externas se inyectan por constructor/función. Sin imports directos a implementaciones concretas fuera del módulo | Rechazo en revisión arquitectónica |
| **Alta Cohesión** | Cada clase/módulo responde a una única responsabilidad (SRP) | Refactorización obligatoria. Se documenta en deuda técnica |

---

## 3. Encoding vs Hashing vs Encriptación

| Tipo | Propósito | ¿Reversible? | ¿Con qué? | Ejemplo en BehavioralOS | ¿Seguro para datos sensibles? |
|------|-----------|-------------|-----------|------------------------|------------------------------|
| **Encoding** | Transporte/representación | Sí, sin llave | Base64, URL Encode, Hex | Base64 de JWT | NO |
| **Hashing** | Verificación sin revelar original | NO (irreversible) | Bcrypt, Argon2id, SHA-256 | Passwords con Bcrypt, integridad con SHA-256 | SÍ (si algoritmo correcto) |
| **Encriptación** | Confidencialidad reversible | Sí, con llave | AES-256-GCM, RSA | Datos en reposo, backups | SÍ (si llave protegida) |

### Reglas de Transformación

- **Passwords**: NUNCA SHA-256. Usar Bcrypt (costo >= 12) o Argon2id
- **Hash de auditoría**: SHA-256 es ACEPTABLE para integridad de eventos (no almacena secretos)
- **JWT**: NO es cifrado. Contenido legible en Base64. No poner datos sensibles en payload
- **Encoding**: CERO seguridad, solo para transporte de datos binarios

---

## 4. Big O y Optimización de Rendimiento

| Complejidad | Nombre | ¿Cuándo usarlo? | Peligro |
|-------------|--------|-----------------|---------|
| O(1) | Constante | Acceso a dict/set, arrays indexados | Ideal |
| O(log n) | Logarítmica | Búsqueda binaria, árboles | Excelente |
| O(n) | Lineal | Un bucle simple, filter/map/reduce | Aceptable |
| O(n²) | Cuadrática | Bucle anidado sobre mismo N | PROHIBIDO en producción |
| O(2ⁿ) | Exponencial | Recursión ingenua (Fibonacci) | PESADILLA, prohibido |

### Reglas de Complejidad

- Si detectas O(n²), refactorizar usando Map/Set para bajar a O(n)
- Recursión ingenua prohibida: usar memoización (`functools.lru_cache`) o iteración
- Toda función > O(n) debe documentar su complejidad en el docstring
- Trade-off tiempo por memoria es aceptable si reduce complejidad

---

## 5. POO + DDD (Principios de Diseño de Objetos)

Los cuatro pilares de la POO no son teoría académica: son las herramientas que mantienen el código predecible, seguro y mantenible. Cada uno resuelve un problema concreto de diseño.

### 5.1. Abstracción

Modelar solo lo esencial del negocio. Eliminar detalles irrelevantes. Cada clase representa un concepto del dominio con nombre y responsabilidad claros.

**Analogía**: manejar un auto. Vos interactuás con el volante y los pedales (el *qué* hace) sin necesidad de saber cómo funciona el motor o los inyectores adentro (el *cómo* lo hace). No necesitás entender el ciclo Otto para doblar en una esquina.

**Propósito**: sacar peso mental. El código cliente programa contra un contrato (interfaz), no contra una implementación concreta. Podés cambiar el *cómo* (ej. motor naftero → eléctrico) sin romper ni una línea del código que consume el objeto.

**Diferencia clave con Encapsulación**: la Encapsulación *esconde datos para protegerlos* (la caja fuerte). La Abstracción *esconde complejidad para simplificar* (el volante). Una protege el estado, la otra reduce la carga cognitiva.

### 5.2. Encapsulación

Prohibido setters genéricos. Usar métodos semánticos (`activarCuenta()`, NO `setEstado()`). Atributos estrictamente privados. La mutación del estado interno ocurre solo a través de mensajes con significado de negocio.

**Analogía de la caja fuerte (cajero automático)**: la caja fuerte está sellada y vos solo ves cuatro botones en la pantalla. No podés meter la mano y sacar billetes — pasás por el proceso: ingresás tarjeta, ponés PIN, pedís plata. Si tuvieras acceso directo al saldo (`saldo = -500`), podrías dejarlo en un estado imposible en la vida real. El cajero te obliga a pasar por un "guardia" (el método público) que valida las reglas de negocio en un solo lugar.

**WHY?** No es por orden, es por protección. Si `saldo` fuera público, cualquier línea de código en cualquier archivo podría setear `saldo = -500`. Con atributos privados y métodos semánticos, la validación está en un solo lugar y es imposible esquivarla.

**Soporte por lenguaje**:

| Lenguaje | Mecanismo | ¿Privacidad real? |
|----------|-----------|-------------------|
| JavaScript | `#` (campos privados ES2022+) | Sí, real |
| Python | `__` (name mangling) | No, es convención — accesible con `_Clase__atributo` |
| Java | `private` keyword | Sí, a nivel de clase |
| C# | `private` + `public get; private set;` | Sí, con azúcar sintáctico en una línea |

### 5.3. Herencia

Clases base limpias que encapsulan comportamiento común. Sin duplicación de estructura. Preferir composición sobre herencia salvo que exista una relación "es-un" real del dominio.

**Analogía**: heredás rasgos físicos de tus padres. Tenés el color de ojos de tu vieja y la altura de tu viejo. No elegís qué heredar — te viene todo junto. Lo mismo pasa en código: cuando heredás, te llevás TODOS los métodos y atributos de la clase padre, los que necesites Y los que no.

**Regla de oro**: la herencia solo aplica cuando hay una relación "es-un" genuina del dominio. `Un Perro es un Animal` → herencia válida. `Una Factura es un PDF` → NO, una factura *usa* un PDF, no *es* un PDF. Ahí va composición.

**Abuso de herencia**: si la usás solo para "robarle" funciones a otra clase, estás creando acoplamiento innecesario. Cuando el padre cambia, todos los hijos se rompen. Si una clase no necesita TODO lo que el padre ofrece, no heredes.

**Default**: composición sobre herencia siempre. Un objeto contiene a otro ("tiene-un") en vez de heredar ("es-un"). Es más flexible, menos acoplado, y no arrastra comportamiento que no corresponde.

**Soporte por lenguaje**:

| Lenguaje | Herencia múltiple | Mecanismo |
|----------|-------------------|-----------|
| Python | Sí | C3 linearization (MRO) — resuelve el problema del diamante con un orden predecible |
| Java | No (solo simple) | Usá interfaces para contratos compartidos — evita el problema del diamante |
| C# | No (solo simple) | Interfaces para contratos, clases base para comportamiento compartido |

### 5.4. Polimorfismo

Eliminar `if/else` y `switch` para decidir comportamiento. Usar interfaces/clases abstractas. Cada hijo responde al mismo método de forma distinta. El código cliente invoca el contrato sin conocer la implementación concreta.

**Analogía del botón Play (▶)**: apretás play en una canción → escuchás música. Apretás play en un video → ves imagen y sonido. Apretás play en un podcast → escuchás voz. El mismo gesto, tres respuestas completamente distintas. El objeto decide CÓMO responder; vos solo sabés que responde.

**WHY?** Elimina cadenas interminables de `if/else if/else` que crecen con cada nuevo tipo. En vez de:

```python
if tipo == "musica":
    reproducirMusica()
elif tipo == "video":
    reproducirVideo()
elif tipo == "podcast":
    reproducirPodcast()
```

Hacés:

```python
contenidos = [Musica(), Video(), Podcast()]
for c in contenidos:
    c.reproducir()  # Cada uno sabe lo suyo
```

Cero condicionales. Agregar un nuevo tipo (ej. `Audiolibro`) no toca el código existente — solo creás la clase y la incluís en la colección. Esto es **Open/Closed Principle** en acción: abierto a extensión, cerrado a modificación.

**Soporte por lenguaje**:

| Lenguaje | Estilo | ¿Qué necesita? |
|----------|--------|----------------|
| JavaScript | Duck Typing | Si camina como pato y suena como pato, tratalo como pato. No requiere interfaz explícita. |
| Python | Duck Typing | Protocol/ABC opcional para contratos formales, pero el lenguaje no exige nada. |
| Java | Interfaz explícita | Requiere `interface` o clase abstracta común — chequeo en compilación. |
| C# | Interfaz explícita + `virtual/override` | `virtual` en el padre, `override` en el hijo, o `interface` con implementación directa. |

---

### 5.5. Ejemplos en BehavioralOS

| Pilar | Ejemplo concreto en BehavioralOS |
|-------|----------------------------------|
| **Encapsulación** | Behavioral Twin: la mutación del estado ocurre exclusivamente a través de métodos de dominio (`PatchContext`, `EvalCondition`). Nadie setea propiedades directamente. |
| **Herencia** | `Engine` base → `BPEEngine`, `BPOEngine`, `BPGEngine`. Cada uno hereda el ciclo de vida y el contrato, pero especializa el comportamiento de cada fase. |
| **Polimorfismo** | Todos los engines implementan `process(context)`. El orquestador itera engines y llama `process()` sin saber cuál es cuál. Cada engine responde distinto al mismo mensaje. |
| **Abstracción** | BRIL (BehavioralOS Runtime Integration Layer): los engines consumen el bus de eventos a través de un contrato abstracto. No saben si el transporte es Redis, RabbitMQ o un mock de testing — solo conocen la interfaz. |

---

## 6. Integración con el Ecosistema

| Módulo | Cómo aplica Torticode |
|--------|-----------------------|
| **1300-Libraries** | Reglas DRY/KISS/YAGNI, Big O y POO/DDD vinculantes en generación de código |
| **BQAS (Testing)** | Quality gates bloquean violaciones: código muerto, O(n²), complejidad ciclomática |
| **BSOS (Security)** | Clasificación correcta de Encoding vs Hashing vs Encryption |
| **100-Architecture** | Patrones de diseño con complejidad documentada |

---

## 7. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-23 | Arquitectura de Software | Creación del documento. Definición de 5 principios Torticode, tablas de transformación criptográfica, Big O y POO/DDD. |
| 1.1.0 | 2026-07-27 | Arquitectura de Software | Expansión de §5 con analogías completas de los 4 pilares POO (Torticode): cajero automático (Encapsulación), rasgos familiares (Herencia), botón Play (Polimorfismo), volante del auto (Abstracción). Tablas comparativas por lenguaje y ejemplos en BehavioralOS. |

---

**Fin del documento `torticode-principles.md`**
