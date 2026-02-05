---
trigger: always_on
---

UI/UX DESIGN SYSTEM & GLOBAL STYLE GUIDE – CONTIDECIDE

Todas las interfaces de usuario generadas para la aplicación “ContiDecide” deben seguir ESTRICTA y OBLIGATORIAMENTE las siguientes reglas de diseño.
No se permite variación visual entre pantallas fuera de este sistema.

Este documento define el estilo global único de UI/UX.

1. ESTILO GENERAL (GLOBAL)

Concepto visual: Modern Academic Clean

Sensación: Institucional, confiable, minimalista, moderna y altamente legible.

Audiencia: Estudiantes universitarios.

Framework visual: Material Design 3 (M3).

Regla clave:
👉 Ninguna pantalla debe introducir estilos, colores, sombras o tipografías fuera de este sistema.

2. PALETA DE COLORES (USO ESTRICTO)

Color Primario – Branding Institucional

Hex: #7D1126 (Guinda Universidad Continental)

Uso obligatorio:

AppBar

Floating Action Buttons (FAB)

Botones primarios y de confirmación

Bordes activos

Estados seleccionados

Color Secundario / Texto Principal

Hex: #2C3E50 (Azul Oscuro / Gris Pizarra)

Uso:

Títulos

Texto principal

Iconografía primaria

Fondo de Pantalla (Background Global)

Hex: #F5F5F5

Regla:

❌ No usar blanco puro como fondo general

✔ Usar únicamente este gris para evitar fatiga visual

Superficies (Tarjetas, Inputs, Modales)

Hex: #FFFFFF (Blanco puro)

Uso exclusivo en:

Cards

Inputs

Bottom sheets

Diálogos

Estados

Error: #B00020 (Material Error)

Éxito / Acento:

#F1C40F (Dorado sutil) o

Verde esmeralda suave (solo para confirmaciones positivas)

3. COMPONENTES REUTILIZABLES (OBLIGATORIOS)
A. Tarjetas (Cards / CardView)

Corner Radius: 16dp

Elevation: 4dp (sombra suave, no agresiva)

Background: #FFFFFF

Padding interno: 16dp

Estado seleccionado:

Borde sólido 2dp

Color: #7D1126

Regla:

❌ No usar bordes, sombras o radios distintos

B. Botones

Estilo:

Pill shape o corner radius 12dp

Botón Primario:

Fondo: #7D1126

Texto: Blanco

Botón Deshabilitado:

Fondo: #E0E0E0

Texto: #9E9E9E

Regla:

El botón de acción principal debe ser visualmente dominante

C. Inputs (Campos de Texto)

Componente:

OutlinedTextField (Material Design 3)

Borde inactivo: Gris suave

Borde activo: #7D1126

Validaciones:

Mostrar mensaje de error debajo del campo

Usar color de error definido (#B00020)

Regla:

❌ No usar inputs filled ni estilos custom

4. TIPOGRAFÍA & JERARQUÍA VISUAL

Fuente global:

Roboto o Open Sans

Títulos (AppBar / Headers):

Weight: Bold

Tamaño: 20–22sp

Color: #2C3E50

Texto de cuerpo:

Weight: Regular

Tamaño: 14–16sp

Color: #37474F

Espaciado global:

Márgenes laterales: 16dp o 24dp

Mantener consistencia en TODAS las pantallas

5. REGLAS DE COMPORTAMIENTO VISUAL (UI FEEDBACK)

Splash Screen

Fondo: #7D1126

Logo blanco centrado

Asset obligatorio: assets/logo_continental.png

Animación: Fade-in suave

Feedback de Usuario

Usar Snackbars, Diálogos o Bottom Sheets estilizados

Colores alineados al sistema (no componentes nativos sin estilo)

Casos:

Error de GPS

Confirmaciones

Advertencias importantes

6. REGLA FINAL DE CONSISTENCIA

👉 Todas las pantallas deben parecer parte de una sola aplicación, sin variaciones de estilo, color, tipografía o componentes.

👉 Si un elemento no está definido aquí, NO DEBE USARSE.