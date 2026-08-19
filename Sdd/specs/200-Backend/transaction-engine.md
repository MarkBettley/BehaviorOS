---
id: BTE-001
title: Behavioral Transaction Engine (BTE)
version: 1.0.0
status: Stable
owner: Arquitectura de Backend & Infraestructura
last_updated: 2026-07-02
depends_on:
  - 000-Core/principles.md (Principios - integridad, confianza)
  - 100-Architecture/system-architecture.md (BEA - capa de datos)
  - 200-Backend/api-graph.md (API Graph - endpoints transaccionales)
  - 200-Backend/database-graph.md (Database Graph - consistencia de datos)
  - 200-Backend/events-and-workflows.md (Eventos y workflows - Sagas)
  - 600-Commerce/business-model.md (BCE - pagos y suscripciones)
  - 700-PracticeOS/practice-os.md (BPOS - expedientes clínicos)
  - 900-Security/security.md (BSOS - integridad y auditoría)
  - 1000-Integration/bril-spec.md (BRIL - eventos y colas)
  - 000-Infrastructure/selection.md (Infraestructura - Redis, PostgreSQL)
exports:
  - Arquitectura del BTE (componentes, flujos)
  - Patrón Saga para transacciones distribuidas
  - Idempotencia (claves, verificación, almacenamiento)
  - Colas de reintentos y Dead Letter Queue (DLQ)
  - Aislamiento de transacciones (optimistic locking, versionado)
  - Auditoría y trazabilidad transaccional
  - Integración con BCE, BPOS y otros módulos
  - Criterios de validación
used_by:
  - BCE (pagos, suscripciones, facturación)
  - BPOS (expedientes, notas, sesiones)
  - BIP (actualización de modelos predictivos)
  - BRIL (eventos críticos)
  - Todos los módulos que requieren consistencia ACID
---

# BehavioralOS – Behavioral Transaction Engine (BTE)

> *"La confianza en un sistema clínico se construye sobre la integridad de sus datos. Un pago duplicado, un expediente inconsistente o una suscripción desincronizada pueden erosionar la confianza del paciente y del terapeuta. El Behavioral Transaction Engine garantiza que cada operación crítica se ejecute de forma atómica, consistente, aislada y duradera, incluso en un entorno distribuido."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define el **Behavioral Transaction Engine (BTE)** , el motor de consistencia transaccional del BehavioralOS. Su objetivo es:

- **Garantizar la integridad** de las operaciones críticas (pagos, suscripciones, expedientes, etc.) mediante transacciones ACID.
- **Manejar transacciones distribuidas** utilizando el patrón Saga para coordinar múltiples servicios.
- **Prevenir operaciones duplicadas** mediante idempotencia basada en claves únicas.
- **Gestionar fallos** con colas de reintentos, backoff exponencial y Dead Letter Queues (DLQ).
- **Asegurar el aislamiento** de transacciones concurrentes mediante optimistic locking y versionado.
- **Proveer trazabilidad** de cada transacción para auditoría y depuración.

### 1.2. Alcance
El documento cubre:

- **Arquitectura del BTE**: Componentes, flujos de transacciones.
- **Patrón Saga**: Coordinación de transacciones distribuidas (orquestación y coreografía).
- **Idempotencia**: Generación y verificación de claves de idempotencia, almacenamiento.
- **Colas de reintentos y DLQ**: Manejo de fallos transitorios y permanentes.
- **Aislamiento de transacciones**: Optimistic locking, versionado de registros.
- **Auditoría y trazabilidad**: Registro de cada paso de la transacción.
- **Integración con BCE, BPOS y otros módulos**: Casos de uso específicos.
- **Criterios de validación**: Métricas de consistencia, rendimiento y resiliencia.

### 1.3. Principio Fundamental
> *"La confianza en un sistema clínico se construye sobre la integridad de sus datos. Un pago duplicado, un expediente inconsistente o una suscripción desincronizada pueden erosionar la confianza del paciente y del terapeuta. El BTE es la garantía de que cada operación crítica se ejecute correctamente, una sola vez, y que el sistema pueda recuperarse de cualquier fallo."*

---

## 2. Filosofía del BTE

### 2.1. Principios de Diseño

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Atomicidad** | Una transacción se completa completamente o no se realiza. | Patrón Saga para transacciones distribuidas. |
| 2 | **Consistencia** | Los datos siempre están en un estado válido. | Validaciones pre y post-transacción. |
| 3 | **Aislamiento** | Las transacciones concurrentes no interfieren entre sí. | Optimistic locking, versionado. |
| 4 | **Durabilidad** | Una vez confirmada, la transacción persiste. | Confirmación en base de datos + logs. |
| 5 | **Idempotencia** | Una operación puede repetirse sin efectos secundarios. | Claves de idempotencia únicas. |
| 6 | **Resiliencia** | El sistema se recupera automáticamente de fallos. | Reintentos, circuit breakers, DLQ. |
| 7 | **Trazabilidad** | Cada transacción es auditada y rastreable. | Logs detallados con correlation_id. |

### 2.2. Tipos de Transacciones

| Tipo | Descripción | Ejemplos |
|------|-------------|----------|
| **Transacción simple** | Opera sobre un solo servicio o base de datos. | Crear un paciente, actualizar una nota. |
| **Transacción distribuida (Saga)** | Opera sobre múltiples servicios. | Pago + suscripción + facturación. |
| **Transacción de larga duración** | Puede durar minutos u horas (ej. esperar confirmación de pago). | Pago con tarjeta + webhook. |

---

## 3. Arquitectura del BTE

### 3.1. Visión General
┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Transaction Engine (BTE) │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Transaction Coordinator (Saga Orchestrator) │ │
│ │ • Inicia transacciones distribuidas │ │
│ │ • Coordina pasos (actividades) │ │
│ │ • Ejecuta compensaciones en caso de fallo │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Idempotency Manager │ │
│ │ • Genera y valida claves de idempotencia │ │
│ │ • Almacena claves procesadas │ │
│ │ • Previene duplicados │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Retry & DLQ Manager │ │
│ │ • Reintentos con backoff exponencial │ │
│ │ • Dead Letter Queue para fallos permanentes │ │
│ │ • Monitorización de reintentos │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Lock & Isolation Manager │ │
│ │ • Optimistic locking (versionado) │ │
│ │ • Distributed locks (Redis) │ │
│ │ • Prevención de condiciones de carrera │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Audit & Traceability Manager │ │
│ │ • Registro de cada paso de la transacción │ │
│ │ • Correlation ID para trazabilidad │ │
│ │ • Logs inmutables │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 3.2. Componentes del BTE

| Componente | Descripción | Tecnología | Notas (Gratuito) |
|------------|-------------|------------|------------------|
| **Transaction Coordinator** | Orquesta transacciones distribuidas (Saga). | Temporal.io | Open source (autohospedado) |
| **Idempotency Manager** | Gestiona claves de idempotencia. | Redis + PostgreSQL | Redis (gratis), PostgreSQL (gratis) |
| **Retry & DLQ Manager** | Gestiona reintentos y Dead Letter Queue. | BullMQ (Redis) | Redis (gratis) |
| **Lock & Isolation Manager** | Gestiona locks y versionado. | Redis (distributed locks) + PostgreSQL | Redis (gratis), PostgreSQL (gratis) |
| **Audit & Traceability Manager** | Registra transacciones para auditoría. | PostgreSQL | Open source |

---

## 4. Patrón Saga (Transacciones Distribuidas)

### 4.1. Descripción

El patrón Saga coordina transacciones distribuidas dividiendo la transacción en una secuencia de pasos (actividades) con compensaciones para cada paso. Si un paso falla, se ejecutan las compensaciones de los pasos anteriores para deshacer la transacción.

### 4.2. Tipos de Saga

| Tipo | Descripción | Cuándo usarlo |
|------|-------------|---------------|
| **Orquestación** | Un coordinador central (orquestador) dirige cada paso y maneja los fallos. | Transacciones complejas con muchos pasos. |
| **Coreografía** | Cada servicio escucha eventos y decide qué hacer sin un coordinador central. | Transacciones más simples o cuando se prefiere menor acoplamiento. |

### 4.3. Ejemplo de Saga (Suscripción + Pago + Facturación)

**Pasos de la Saga**:

1. **Iniciar pago** (Stripe/Mercado Pago) → Crea un intento de pago.
2. **Esperar confirmación de pago** (webhook) → Confirma que el pago fue exitoso.
3. **Crear suscripción** (BCE) → Registra la suscripción en la base de datos.
4. **Generar factura** (Facturapi) → Crea la factura CFDI.
5. **Activar servicios** (BPOS) → Activa el acceso a servicios para el paciente.
6. **Enviar confirmación** → Correo/push al paciente.

**Compensaciones (en caso de fallo)**:

| Paso fallido | Compensación |
|--------------|--------------|
| Paso 1 falla | No hay compensación (no se ha creado nada). |
| Paso 2 falla (webhook no llega) | Reintentar; si falla, cancelar el intento de pago. |
| Paso 3 falla | Reembolsar el pago (Stripe/Mercado Pago), cancelar suscripción. |
| Paso 4 falla | Marcar factura como pendiente; no compensar, se reintenta. |
| Paso 5 falla | Desactivar servicios; notificar al equipo. |
| Paso 6 falla | Registrar error; no compensar, se reintenta. |

### 4.4. Implementación con Temporal.io

```python
from temporalio import workflow
from temporalio.common import RetryPolicy
from datetime import timedelta

@workflow.defn
class SubscriptionSaga:
    @workflow.run
    async def run(self, patient_id: str, plan_id: str, payment_method: str):
        # Paso 1: Iniciar pago
        payment_result = await workflow.execute_activity(
            initiate_payment,
            patient_id, plan_id, payment_method,
            start_to_close_timeout=timedelta(seconds=30),
            retry_policy=RetryPolicy(maximum_attempts=3)
        )

        # Paso 2: Esperar confirmación de pago
        confirmation = await workflow.execute_activity(
            wait_for_payment_confirmation,
            payment_result.payment_id,
            start_to_close_timeout=timedelta(minutes=5),
            retry_policy=RetryPolicy(maximum_attempts=5)
        )

        # Paso 3: Crear suscripción (con compensación)
        try:
            subscription_id = await workflow.execute_activity(
                create_subscription,
                patient_id, plan_id, confirmation.payment_id,
                start_to_close_timeout=timedelta(seconds=10)
            )
        except Exception as e:
            # Compensación: reembolsar pago
            await workflow.execute_activity(
                refund_payment,
                confirmation.payment_id,
                start_to_close_timeout=timedelta(seconds=30)
            )
            raise

        # Paso 4: Generar factura (con compensación)
        try:
            invoice_id = await workflow.execute_activity(
                generate_invoice,
                patient_id, subscription_id,
                start_to_close_timeout=timedelta(seconds=30),
                retry_policy=RetryPolicy(maximum_attempts=3)
            )
        except Exception as e:
            # Compensación: cancelar suscripción, reembolsar pago
            await workflow.execute_activity(
                cancel_subscription,
                subscription_id,
                start_to_close_timeout=timedelta(seconds=10)
            )
            await workflow.execute_activity(
                refund_payment,
                confirmation.payment_id,
                start_to_close_timeout=timedelta(seconds=30)
            )
            raise

        # Paso 5: Activar servicios
        await workflow.execute_activity(
            activate_services,
            patient_id,
            start_to_close_timeout=timedelta(seconds=30)
        )

        # Paso 6: Enviar confirmación
        await workflow.execute_activity(
            send_confirmation,
            patient_id,
            start_to_close_timeout=timedelta(seconds=30),
            retry_policy=RetryPolicy(maximum_attempts=5)
        )

        return {"subscription_id": subscription_id, "status": "active"}

5. Idempotencia
5.1. Propósito
La idempotencia garantiza que una operación pueda repetirse múltiples veces sin causar efectos secundarios no deseados (ej. cobros duplicados, registros duplicados).

5.2. Claves de Idempotencia
Generación: Clave única generada por el cliente (UUID v7) o por el servidor basada en los datos de la transacción (ej. payment_intent_id).

Almacenamiento: Tabla idempotency_keys en PostgreSQL con un TTL (ej. 7 días).

Verificación: Antes de ejecutar una operación, se verifica si la clave ya fue procesada. Si es así, se devuelve el resultado almacenado.

Tabla de idempotencia:

sql
CREATE TABLE system.idempotency_keys (
    key UUID PRIMARY KEY,
    operation_type VARCHAR(100) NOT NULL,
    result JSONB NOT NULL,
    processed_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP DEFAULT NOW() + INTERVAL '7 days'
);

5.3. Ejemplo de Uso

async def create_subscription_with_idempotency(patient_id, plan_id, idempotency_key):
    # Verificar si la clave ya fue procesada
    existing = await db.get_idempotency_key(idempotency_key)
    if existing:
        return existing.result

    # Ejecutar la operación
    try:
        result = await create_subscription(patient_id, plan_id)
        await db.store_idempotency_key(idempotency_key, result)
        return result
    except Exception as e:
        # No almacenar la clave en caso de error (permitir reintentos)
        raise

6. Colas de Reintentos y Dead Letter Queue (DLQ)
6.1. Reintentos con Backoff Exponencial
Intento	Retraso	Tiempo acumulado
1	100ms	100ms
2	200ms	300ms
3	400ms	700ms
4	800ms	1.5s
5	1.6s	3.1s
6	3.2s	6.3s
7	6.4s	12.7s
8	12.8s	25.5s
6.2. Dead Letter Queue (DLQ)
Propósito: Almacenar operaciones que fallaron permanentemente (después de todos los reintentos).

Almacenamiento: Tabla dlq_entries en PostgreSQL (o Redis para operaciones más ligeras).

Contenido: Datos de la operación, error, timestamp, intentos.

Procesamiento: Revisión manual por el equipo de operaciones.

Tabla DLQ:

sql

CREATE TABLE system.dlq_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operation_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    error TEXT NOT NULL,
    attempts INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'resolved', 'ignored'))
);

6.3. Ejemplo de Reintentos
Python

async def process_with_retry(operation, max_attempts=5):
    for attempt in range(max_attempts):
        try:
            return await operation()
        except Exception as e:
            if attempt == max_attempts - 1:
                # Último intento fallido → enviar a DLQ
                await db.insert_dlq(operation, str(e), attempt + 1)
                raise
            await asyncio.sleep(100 * (2 ** attempt))  # backoff exponencial

7. Aislamiento de Transacciones
7.1. Optimistic Locking (Versionado)
Propósito: Prevenir actualizaciones concurrentes en el mismo registro.

Implementación: Cada registro tiene un campo version que se incrementa en cada actualización.

Verificación: Al actualizar, se verifica que la versión en la base de datos coincida con la versión leída.

Tabla con versionado:

sql
CREATE TABLE clinical.patients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    version INTEGER DEFAULT 0,  -- Optimistic locking
    updated_at TIMESTAMP DEFAULT NOW()
);

Actualización con optimistic locking:

sql
UPDATE clinical.patients
SET status = 'active', version = version + 1, updated_at = NOW()
WHERE id = 'pat_001' AND version = 0;

7.2. Distributed Locks (Redis)
Propósito: Prevenir condiciones de carrera en operaciones distribuidas.

Implementación: Redlock o SETNX en Redis.

Uso: Para operaciones que no pueden ser manejadas con optimistic locking (ej. generación de números secuenciales).

8. Auditoría y Trazabilidad
8.1. Registro de Transacciones
Cada transacción registra:

Correlation ID: Identificador único para toda la transacción (compartido entre servicios).

Pasos: Cada paso de la transacción (actividad de Saga) con estado, timestamp y resultados.

Errores: Si un paso falla, se registra el error y las compensaciones ejecutadas.

8.2. Tabla de Auditoría
sql
CREATE TABLE system.transaction_audit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    correlation_id UUID NOT NULL,
    transaction_type VARCHAR(100) NOT NULL,
    step VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('started', 'completed', 'failed', 'compensated')),
    payload JSONB,
    result JSONB,
    error TEXT,
    timestamp TIMESTAMP DEFAULT NOW()
);

9. Integración con el Ecosistema
9.1. BCE (Comercio)
Casos de uso: Pagos, suscripciones, facturación, reembolsos.

Patrón: Saga orquestada (Temporal.io) para coordinar Stripe/Mercado Pago + BCE + Facturapi.

9.2. BPOS (Práctica Clínica)
Casos de uso: Creación de expedientes, actualización de notas, cambio de estado de pacientes.

Patrón: Transacciones simples con optimistic locking.

9.3. BIP (Analítica)
Casos de uso: Actualización de modelos predictivos, generación de reportes.

Patrón: Transacciones de larga duración con reintentos.

9.4. BRIL (Integración)
Casos de uso: Publicación de eventos críticos (ej. PAYMENT_SUCCEEDED).

Patrón: Eventos con idempotencia (clave idempotency_key en el evento).

10. Criterios de Validación y Cumplimiento
Criterio	Métrica	Herramienta
Consistencia	0% de inconsistencias en datos críticos (pagos, expedientes).	Auditoría automática
Idempotencia	0% de operaciones duplicadas.	Pruebas de integración
Tiempo de recuperación	< 30 segundos para recuperación de fallos transitorios.	Monitoreo
Tasa de fallos	< 1% de transacciones fallan después de reintentos.	Monitoreo
Tiempo de respuesta	< 200ms para transacciones simples, < 5s para transacciones distribuidas.	Monitoreo de rendimiento
Trazabilidad	100% de las transacciones tienen auditoría completa.	Auditoría automática
11. El Manifiesto del BTE
"La confianza en un sistema clínico se construye sobre la integridad de sus datos.

Un pago duplicado, un expediente inconsistente o una suscripción desincronizada pueden erosionar la confianza del paciente y del terapeuta.

El Behavioral Transaction Engine es la garantía de que cada operación crítica se ejecute correctamente, una sola vez, y que el sistema pueda recuperarse de cualquier fallo.

No se trata solo de transacciones; se trata de la integridad de la práctica clínica.

Nuestra responsabilidad es garantizar que el BTE sea robusto, confiable, auditado y perfectamente integrado con el ecosistema BehavioralOS."

12. Historial de Cambios
Versión	Fecha	Autor	Cambios
1.0.0	2026-07-02	Arquitectura Backend	Creación del documento. Definición del Behavioral Transaction Engine: arquitectura, patrón Saga, idempotencia, colas de reintentos y DLQ, aislamiento de transacciones, auditoría y trazabilidad, integración con el ecosistema y criterios de validación.
Fin del documento transaction-engine.md