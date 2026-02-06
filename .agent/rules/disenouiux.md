---
trigger: always_on
---

UI / UX MASTER PLAN & NAVIGATION FLOW (DOCUMENTO RECTOR)

Este documento define la única verdad válida sobre el diseño, flujo y comportamiento de la aplicación ContiDecide.
Cualquier código, pantalla o lógica generada DEBE cumplirlo estrictamente.

1. SISTEMA DE DISEÑO (NO NEGOCIABLE)
🎨 Paleta de Colores Institucional

Color Primario (Marca): #7D1126
Uso obligatorio en:

Botones principales

AppBar / Headers

CTA primarios

Fondo General: #FFFFFF o #F5F5F5
❌ Prohibido usar fondos oscuros, azules o degradados fuertes.

Texto Principal: #2D2D2D

Estado Éxito / Verificado: #2E7D32

Estado Error / Bloqueo: #C62828

Color Secundario / Acento: #FFC107
Uso limitado SOLO a:

Advertencias

Iconos de pasos

Indicadores de proceso

✨ Estilo Visual

Bordes: BorderRadius.circular(16) (obligatorio en Cards y Buttons)

Sombras:

BoxShadow(
  color: Colors.black12,
  blurRadius: 10,
  offset: Offset(0, 4),
)


Tipografía: Sans-serif moderna
Preferencia:

Poppins

Roboto

Estilo General: Limpio, institucional, moderno.
❌ Prohibido estilo “paint”, colores planos sin jerarquía o UI genérica.

2. FLUJO DE NAVEGACIÓN OBLIGATORIO (LINEAL)

🚫 La app NUNCA puede saltar fases.
🚫 No se puede acceder a Votación directamente.

ORDEN ESTRICTO DE PANTALLAS:

Login

Verificación de Identidad

Instrucciones

Validación de Ubicación

Votación

3. FASES DEL USER JOURNEY
🔐 FASE 1: AUTENTICACIÓN

Pantalla: LoginScreen

Objetivo: Acceso simple, elegante y confiable.

Elementos obligatorios:

Logo de la app centrado (grande).

Título: “Elección de Delegado”

ÚNICO botón de acción:

Texto: “Ingresar con Cuenta Institucional”

Estilo Google Sign-In (blanco, borde sutil, sombra suave).

Footer fijo:

“Ingeniería de Sistemas – Universidad Continental”

🚫 No formularios manuales
🚫 No email/password
👉 Si un elemento no está definido aquí, NO DEBE USARSE.