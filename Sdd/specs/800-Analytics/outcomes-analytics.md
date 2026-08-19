---
id: BIP-001
title: Behavioral Intelligence Platform (BIP)
version: 1.0.0
status: Stable
owner: Ciencia de Datos & Investigación
last_updated: 2026-07-01
depends_on:
  - 000-Core/ontology.md (Ontología - procesos)
  - 100-Architecture/behavioral-twin.md (Behavioral Twin - datos de pacientes)
  - 400-AI/adaptive-orchestrator.md (AAO - evaluaciones)
  - 400-AI/rag-knowledge-graph.md (BKGE - conocimiento científico)
  - 500-Experiencies/experience-engine.md (BERL - telemetría de ejercicios)
  - 600-Commerce/business-model.md (BCE - datos comerciales)
  - 700-PracticeOS/practice-os.md (BPOS - datos clínicos y operativos)
  - 200-Backend/database-graph.md (Database Graph - series temporales)
  - 000-Infrastructure/selection.md (Infraestructura - TimescaleDB, Grafana, PyTorch)
exports:
  - Arquitectura del BIP (componentes, flujos)
  - Dashboards de KPIs (clínicos, operativos, comerciales)
  - Modelos predictivos (riesgo de abandono, recaída, adherencia)
  - Análisis de efectividad de intervenciones
  - Reportes personalizados (generación, plantillas)
  - Integración con el ecosistema
  - Criterios de validación y métricas de éxito
used_by:
  - Therapist App (dashboards clínicos y de negocio)
  - Admin Dashboard (KPIs globales)
  - BSC (investigación y mejora de modelos)
  - BROS (experimentos y validación)
---

# BehavioralOS – Behavioral Intelligence Platform (BIP)

> *"Los datos no son solo números. Son la historia del cambio. Cada proceso que mejora, cada ejercicio que completa, cada sesión que termina es un dato que cuenta la historia del crecimiento de un paciente. El BIP convierte los datos en inteligencia, y la inteligencia en acción."*

---

## 1. Propósito y Alcance

### 1.1. Propósito
Este documento define la **Behavioral Intelligence Platform (BIP)**, el sistema de inteligencia analítica del BehavioralOS. Su objetivo es:

- **Proveer dashboards de KPIs** para que terapeutas, administradores e investigadores puedan monitorear el rendimiento clínico, operativo y comercial de la plataforma.
- **Desarrollar modelos predictivos** para anticipar riesgos (abandono, recaída, baja adherencia) y facilitar intervenciones tempranas.
- **Analizar la efectividad** de intervenciones y ejercicios para mejorar continuamente la práctica clínica.
- **Generar reportes personalizados** para terapeutas, clínicas e investigadores.

### 1.2. Alcance
El documento cubre:

- **Arquitectura del BIP**: Componentes, flujos de datos, integración con el ecosistema.
- **Dashboards de KPIs**: Clínicos (procesos, adherencia, evolución), operativos (pacientes, sesiones, carga de trabajo) y comerciales (ingresos, retención, LTV).
- **Modelos predictivos**: Riesgo de abandono, recaída, adherencia, mejora esperada.
- **Análisis de efectividad**: Comparación de intervenciones, análisis N-of-1, tamaño del efecto.
- **Reportes personalizados**: Generación de informes con plantillas, exportación a PDF/CSV.
- **Integración con el ecosistema**: AAO, BERL, BCE, BPOS, BKGE, BROS.
- **Criterios de validación**: Métricas de precisión, usabilidad y escalabilidad.

### 1.3. Principio Fundamental
> **"El BIP no es un simple dashboard. Es el termómetro del ecosistema. Mide la salud de la práctica clínica, identifica oportunidades de mejora y guía las decisiones basadas en evidencia. Datos sin acción son solo ruido; el BIP convierte el ruido en música."**

---

## 2. Filosofía del BIP

### 2.1. Principios de Diseño

| # | Principio | Descripción | Manifestación |
|---|-----------|-------------|---------------|
| 1 | **Accionable** | La información debe poder ser utilizada para tomar decisiones. | Los dashboards incluyen recomendaciones basadas en los datos. |
| 2 | **Claro y comprensible** | Los datos deben ser fáciles de entender para clínicos y administradores. | Visualizaciones intuitivas, lenguaje claro, sin jerga técnica. |
| 3 | **En tiempo real** | Los datos deben estar disponibles cuando se necesiten. | Actualización casi en tiempo real (latencia < 5 minutos). |
| 4 | **Personalizable** | Cada usuario debe poder ver lo que es relevante para él. | Dashboards configurables, filtros, vistas personalizadas. |
| 5 | **Ético y privado** | Los datos se utilizan de manera ética y respetando la privacidad. | Datos anonimizados para investigación; consentimiento para uso de datos. |
| 6 | **Predictivo** | El sistema debe anticipar problemas antes de que ocurran. | Modelos predictivos de riesgo de abandono, recaída, etc. |

### 2.2. Fuentes de Datos

| Fuente | Datos | Frecuencia |
|--------|-------|------------|
| **Behavioral Twin** | Procesos, confianzas, valores, objetivos, hipótesis. | Continuo |
| **AAO** | Evaluaciones, confianzas de procesos, estado emocional. | Continuo |
| **BERL** | Telemetría de ejercicios (latencia, errores, persistencia, etc.). | Por ejercicio |
| **BPOS** | Sesiones, notas, agenda, pacientes. | Por sesión |
| **BCE** | Suscripciones, pagos, facturas, ingresos. | Por transacción |
| **TCCN** | Conversaciones, análisis de lenguaje, marcos RFT. | Por interacción |

---

## 3. Arquitectura del BIP

### 3.1. Visión General
┌─────────────────────────────────────────────────────────────────────────┐
│ Behavioral Intelligence Platform │
│ (BIP) │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Data Ingestion Layer │ │
│ │ • Recopilación de datos de fuentes (AAO, BERL, BPOS, BCE) │ │
│ │ • Normalización y limpieza │ │
│ │ • Almacenamiento en Data Warehouse (TimescaleDB) │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Analytics Engine │ │
│ │ • Cálculo de KPIs │ │
│ │ • Modelos predictivos (scikit-learn, PyTorch) │ │
│ │ • Análisis de efectividad (statsmodels) │ │
│ │ • Agregación y resumen de datos │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Dashboard & Reporting Layer │ │
│ │ • Dashboards interactivos (Grafana, Chart.js, Recharts) │ │
│ │ • Generación de reportes (PDF, CSV) │ │
│ │ • Alertas y notificaciones │ │
│ └─────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Integration Layer │ │
│ │ • APIs para consulta de datos │ │
│ │ • Integración con Therapist App, Admin Dashboard, BROS │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘


### 3.2. Componentes del BIP

| Componente | Descripción | Tecnología | Notas (Gratuito) |
|------------|-------------|------------|------------------|
| **Data Ingestion Layer** | Recopila y normaliza datos de todas las fuentes. | Python (FastAPI), Apache Airflow (opcional) | Open source |
| **Analytics Engine** | Calcula KPIs, ejecuta modelos predictivos y análisis de efectividad. | Python (scikit-learn, PyTorch, statsmodels) | Open source |
| **Dashboard & Reporting Layer** | Visualiza KPIs y reportes en dashboards interactivos. | Grafana, React (Recharts, Chart.js) | Grafana (gratis), React (open source) |
| **Integration Layer** | Expone datos a través de APIs para otros módulos. | FastAPI | Open source |

---

## 4. Dashboards de KPIs

### 4.1. Tipos de Dashboards

| Dashboard | Usuario | Propósito |
|-----------|---------|-----------|
| **Clínico** | Terapeuta | Monitorear la evolución de los pacientes y la efectividad de las intervenciones. |
| **Operativo** | Terapeuta, Administrador | Gestionar la carga de trabajo, la agenda y la productividad. |
| **Comercial** | Terapeuta, Administrador | Medir ingresos, retención y crecimiento del negocio. |

### 4.2. Dashboard Clínico

#### 4.2.1. KPIs Clínicos

| KPI | Descripción | Fórmula | Frecuencia |
|-----|-------------|---------|------------|
| **Progreso de procesos** | Evolución de los procesos psicológicos del paciente (Aceptación, Defusión, etc.). | Valor del proceso (0-1) a lo largo del tiempo. | Continuo |
| **Adherencia a ejercicios** | Porcentaje de ejercicios completados vs. asignados. | (Ejercicios completados / Ejercicios asignados) * 100 | Semanal |
| **Mejora promedio** | Cambio promedio en los procesos clave después de N sesiones. | (Valor final - Valor inicial) / Valor inicial | Por sesión |
| **Tasa de generalización** | Porcentaje de pacientes que aplican habilidades en la vida real. | Reportado por el terapeuta o inferido por AAO. | Mensual |
| **Riesgo de abandono** | Probabilidad estimada de que el paciente abandone la terapia. | Modelo predictivo (0-1). | Continuo |
| **Riesgo de recaída** | Probabilidad estimada de recaída en pacientes en mantenimiento. | Modelo predictivo (0-1). | Continuo |

#### 4.2.2. Visualizaciones

- **Evolución de procesos (gráfico de líneas)**: Muestra la trayectoria de cada proceso a lo largo del tiempo.
- **Hexaflex en tiempo real**: Visualización dinámica del Hexaflex con valores actuales de cada proceso.
- **Adherencia a ejercicios (gráfico de barras)**: Compara los ejercicios completados vs. asignados por semana.
- **Riesgo de abandono (indicador de semáforo)**: Verde (bajo), Amarillo (medio), Rojo (alto).
- **Riesgo de recaída (indicador de semáforo)**: Verde (bajo), Amarillo (medio), Rojo (alto).

### 4.3. Dashboard Operativo

#### 4.3.1. KPIs Operativos

| KPI | Descripción | Fórmula | Frecuencia |
|-----|-------------|---------|------------|
| **Pacientes activos** | Número de pacientes con sesiones en los últimos 30 días. | Conteo de pacientes con sesiones en los últimos 30 días. | Mensual |
| **Sesiones por semana** | Número de sesiones realizadas por semana. | Conteo de sesiones completadas por semana. | Semanal |
| **Tasa de no-show** | Porcentaje de citas no atendidas. | (Citas no atendidas / Total de citas) * 100 | Mensual |
| **Carga de trabajo** | Tiempo total dedicado a sesiones y tareas administrativas. | Horas de sesión + horas de documentación. | Semanal |
| **Tiempo de documentación** | Tiempo promedio dedicado a documentación por sesión. | Tiempo total de documentación / Número de sesiones. | Mensual |
| **Tasa de retención** | Porcentaje de pacientes que continúan después de 3 meses. | (Pacientes activos a los 3 meses / Pacientes al inicio) * 100 | Trimestral |

#### 4.3.2. Visualizaciones

- **Pacientes activos (gráfico de líneas)**: Evolución del número de pacientes activos en el tiempo.
- **Sesiones por semana (gráfico de barras)**: Número de sesiones realizadas cada semana.
- **Tasa de no-show (gráfico circular)**: Proporción de citas atendidas vs. no atendidas.
- **Carga de trabajo (gráfico de barras apiladas)**: Tiempo de sesión vs. tiempo administrativo.
- **Tasa de retención (gráfico de barras)**: Retención a 1, 3, 6 y 12 meses.

### 4.4. Dashboard Comercial

#### 4.4.1. KPIs Comerciales

| KPI | Descripción | Fórmula | Frecuencia |
|-----|-------------|---------|------------|
| **MRR (Monthly Recurring Revenue)** | Ingresos recurrentes mensuales de suscripciones. | Suma de todos los pagos de suscripciones activas. | Mensual |
| **ARR (Annual Recurring Revenue)** | Ingresos recurrentes anuales. | MRR * 12 | Anual |
| **Churn Rate** | Porcentaje de pacientes que cancelan su suscripción. | (Cancelaciones en el período / Total de suscripciones al inicio del período) * 100 | Mensual |
| **LTV (Lifetime Value)** | Valor total de un paciente. | Ingresos promedio por mes * Duración promedio de la relación (en meses). | Trimestral |
| **CAC (Customer Acquisition Cost)** | Costo de adquirir un nuevo paciente. | (Gastos de marketing + ventas) / Número de nuevos pacientes. | Trimestral |
| **Ingresos por terapeuta** | Ingresos totales generados por cada terapeuta. | Suma de suscripciones + ventas del marketplace. | Mensual |
| **Marketplace Revenue** | Ingresos generados por el marketplace (comisiones). | Suma de comisiones de productos vendidos. | Mensual |

#### 4.4.2. Visualizaciones

- **MRR y ARR (gráfico de líneas)**: Evolución de los ingresos recurrentes.
- **Churn Rate (gráfico de barras)**: Tasa de cancelación por mes.
- **LTV (gráfico de barras)**: Valor de vida del paciente por cohorte.
- **Ingresos por terapeuta (gráfico de barras)**: Comparación de ingresos entre terapeutas.
- **Marketplace Revenue (gráfico de barras)**: Ingresos del marketplace por categoría de producto.

---

## 5. Modelos Predictivos

### 5.1. Tipos de Modelos

| Modelo | Propósito | Variables de entrada | Salida | Frecuencia de actualización |
|--------|-----------|----------------------|--------|-----------------------------|
| **Riesgo de abandono** | Predecir la probabilidad de que un paciente abandone la terapia en los próximos 30 días. | Frecuencia de sesiones, adherencia a ejercicios, cambios en procesos (AAO), estado emocional. | Probabilidad (0-1). | Diaria |
| **Riesgo de recaída** | Predecir la probabilidad de recaída en pacientes en mantenimiento. | Procesos (Aceptación, Defusión, Evitación), adherencia, eventos estresantes reportados. | Probabilidad (0-1). | Semanal |
| **Adherencia** | Predecir la probabilidad de que un paciente complete los ejercicios asignados en la próxima semana. | Historial de adherencia, estado emocional, nivel de fatiga. | Probabilidad (0-1). | Diaria |
| **Mejora esperada** | Predecir la mejora esperada en un proceso específico después de N sesiones. | Estado inicial del proceso, historial de mejora, características del paciente. | Valor esperado del proceso en N sesiones. | Por solicitud |

### 5.2. Algoritmos Utilizados

| Modelo | Algoritmo | Librería | Justificación |
|--------|-----------|----------|---------------|
| **Riesgo de abandono** | XGBoost, Random Forest | scikit-learn, xgboost | Manejo de datos tabulares, interpretabilidad. |
| **Riesgo de recaída** | LSTM (deep learning) | PyTorch, TensorFlow | Datos de series temporales (trayectorias de procesos). |
| **Adherencia** | Regresión Logística, XGBoost | scikit-learn, xgboost | Interpretabilidad y rendimiento. |
| **Mejora esperada** | Modelos de series temporales (ARIMA, Prophet) | statsmodels, Prophet | Análisis de trayectorias longitudinales. |

### 5.3. Entrenamiento y Actualización

- **Entrenamiento inicial**: Modelos entrenados con datos históricos de la plataforma (agregados y anonimizados).
- **Actualización continua**: Los modelos se reentrenan automáticamente cada mes con nuevos datos agregados.
- **Validación**: Precisión (AUC) ≥ 0.70 para modelos de clasificación; error RMSE ≤ 0.10 para modelos de regresión.

### 5.4. Interpretabilidad

- **Importancia de variables**: Los modelos proporcionan una lista de las variables más importantes para la predicción.
- **Explicaciones individuales**: Para cada predicción (ej. "Riesgo de abandono: 85%"), el sistema proporciona una explicación de los factores que contribuyen a esa predicción.

**Ejemplo de explicación**:

> *"El riesgo de abandono para María González es del 85%. Los principales factores que contribuyen son: (1) baja adherencia a ejercicios en las últimas 2 semanas (0/4 ejercicios completados), (2) disminución de la confianza en Aceptación (de 0.65 a 0.45), y (3) aumento de la evitación reportada en la última sesión."*

---

## 6. Análisis de Efectividad

### 6.1. Propósito

El análisis de efectividad evalúa si las intervenciones (ejercicios, protocolos) están produciendo los resultados esperados en los pacientes.

### 6.2. Tipos de Análisis

| Tipo | Descripción | Método estadístico | Frecuencia |
|------|-------------|-------------------|------------|
| **N-of-1** | Análisis de un solo paciente a lo largo del tiempo. | Series temporales (ARIMA, CUSUM). | Por solicitud |
| **Pre-post** | Comparación de procesos antes y después de una intervención. | Prueba t de Student para muestras apareadas, Cohen's d (tamaño del efecto). | Por intervención |
| **Comparación de intervenciones** | Comparación de la efectividad de dos o más intervenciones para un mismo proceso. | ANOVA, pruebas post-hoc. | Trimestral |
| **Meta-análisis** | Análisis agregado de múltiples estudios o N-of-1. | Métodos de meta-análisis. | Anual |

### 6.3. Tamaño del Efecto (Cohen's d)

| Rango | Interpretación | Acción del sistema |
|-------|----------------|-------------------|
| 0.0 - 0.2 | Efecto muy pequeño. | Revisar la intervención; considerar cambios. |
| 0.2 - 0.5 | Efecto pequeño. | Monitorear; puede ser clínicamente significativo en algunos casos. |
| 0.5 - 0.8 | Efecto moderado. | Mantener; buena evidencia de efectividad. |
| 0.8 - 1.2 | Efecto grande. | Sólida evidencia; recomendar ampliamente. |
| > 1.2 | Efecto muy grande. | Evidencia muy sólida; priorizar. |

---

## 7. Reportes Personalizados

### 7.1. Tipos de Reportes

| Reporte | Usuario | Propósito | Formato |
|---------|---------|-----------|---------|
| **Reporte de progreso del paciente** | Terapeuta | Resumir la evolución del paciente para revisión clínica. | PDF (con gráficos y tablas) |
| **Reporte de efectividad de intervención** | Terapeuta, Investigador | Evaluar la efectividad de una intervención específica. | PDF (con estadísticas y gráficos) |
| **Reporte de KPIs del terapeuta** | Terapeuta | Resumir el rendimiento clínico y comercial del terapeuta. | PDF, CSV |
| **Reporte de KPIs de la plataforma** | Administrador | Resumir el rendimiento global de la plataforma. | PDF, CSV |
| **Reporte de investigación** | Investigador | Datos anonimizados para investigación (BROS). | CSV, JSON |

### 7.2. Generación de Reportes

- **Plantillas**: Los reportes se generan a partir de plantillas configurables (con variables que se reemplazan con datos reales).
- **Exportación**: Los reportes se pueden exportar a PDF (con gráficos y tablas) o CSV (para análisis en hojas de cálculo).
- **Programación**: Los reportes se pueden programar para su generación automática (ej. mensual).
- **Notificaciones**: Cuando un reporte está listo, se envía una notificación al usuario.

---

## 8. Integración con el Ecosistema

### 8.1. AAO (Evaluación Adaptativa)
- **Uso**: El BIP utiliza los datos del AAO (confianzas de procesos, estado emocional) para los KPIs clínicos y los modelos predictivos.
- **Actualización**: El BIP no actualiza el AAO; solo consume sus datos.

### 8.2. BERL (Ejercicios)
- **Uso**: El BIP utiliza la telemetría de ejercicios para calcular adherencia, efectividad de ejercicios, etc.
- **Actualización**: El BIP no actualiza el BERL; solo consume sus datos.

### 8.3. BPOS (Práctica Clínica)
- **Uso**: El BIP utiliza los datos de sesiones, pacientes y agenda para KPIs operativos.
- **Actualización**: El BIP no actualiza el BPOS; solo consume sus datos.

### 8.4. BCE (Comercio)
- **Uso**: El BIP utiliza los datos de suscripciones, pagos y facturas para KPIs comerciales.
- **Actualización**: El BIP no actualiza el BCE; solo consume sus datos.

### 8.5. BSC (Ciencia)
- **Uso**: El BIP alimenta al BSC con datos agregados y anonimizados para investigación.
- **Actualización**: El BIP no actualiza el BSC; envía datos para investigación.

### 8.6. BROS (Investigación)
- **Uso**: El BIP proporciona datos y análisis al BROS para experimentos y validación.
- **Actualización**: El BIP no actualiza el BROS; proporciona datos bajo demanda.

---

## 9. Seguridad y Privacidad

### 9.1. Anonimización de Datos

- **Datos de investigación**: Todos los datos utilizados para investigación (BSC, BROS) están anonimizados (eliminación de información identificable).
- **Consentimiento**: Los pacientes pueden optar por no participar en la investigación (consentimiento granular en BCPOS).

### 9.2. Control de Acceso

- **RLS (Row Level Security)**: Los terapeutas solo ven los datos de sus propios pacientes.
- **Roles**: Los administradores ven datos agregados (no individuales) a menos que tengan permisos específicos.
- **Auditoría**: Todos los accesos a datos sensibles se registran.

---

## 10. Criterios de Validación y Cumplimiento

| Criterio | Métrica | Herramienta |
|----------|---------|-------------|
| **Precisión de modelos predictivos** | AUC ≥ 0.70 para clasificación, RMSE ≤ 0.10 para regresión. | Validación de modelos |
| **Latencia de actualización de dashboards** | < 5 minutos desde la entrada de datos hasta la actualización del dashboard. | Monitoreo de rendimiento |
| **Satisfacción del usuario** | ≥ 4.0/5 en encuestas de usabilidad de dashboards. | Encuestas in-app |
| **Adopción** | ≥ 70% de los terapeutas utilizan los dashboards al menos una vez por semana. | Analítica de uso |
| **Privacidad** | 100% de los datos de investigación están anonimizados. | Auditoría de anonimización |

---

## 11. El Manifiesto del BIP

> *"Los datos no son solo números. Son la historia del cambio.*
>
> *Cada proceso que mejora, cada ejercicio que completa, cada sesión que termina es un dato que cuenta la historia del crecimiento de un paciente.*
>
> *El BIP convierte los datos en inteligencia, y la inteligencia en acción.*
>
> *No se trata de acumular datos; se trata de utilizarlos para tomar mejores decisiones clínicas, operativas y comerciales.*
>
> *Nuestra responsabilidad es garantizar que el BIP sea preciso, accionable, ético y fácil de usar. Que los terapeutas puedan ver el progreso de sus pacientes con claridad, los administradores puedan optimizar la plataforma con confianza, y los investigadores puedan generar nuevo conocimiento con rigor."*

---

## 12. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2026-07-01 | Arquitectura de Analítica | Creación del documento. Definición del BIP: dashboards de KPIs (clínicos, operativos, comerciales), modelos predictivos, análisis de efectividad, reportes personalizados, integración con el ecosistema y criterios de validación. |

---

**Fin del documento `outcomes-analytics.md`**