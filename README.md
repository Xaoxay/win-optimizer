# 🚀 Windows 10 & 11 Optimizer (Win-Optimizer)

Herramienta interactiva y automatizada para optimizar Windows 10 y Windows 11 en **PC de Escritorio** y **Notebooks / Laptops**.

## ⚡ Ejecución Rápida

### Opción 1: Comando directo en tu PC (Ya configurado)
Simplemente abrí cualquier consola (CMD, PowerShell o `Win + R`) y escribí:
```cmd
optimizar
```
*(Si no tenías permisos de Administrador, te pedirá confirmación de UAC automáticamente)*.

---

### Opción 2: Ejecutar vía PowerShell (One-liner local)
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\.gemini\antigravity\scratch\win-optimizer\Optimizar-Windows.ps1"
```

---

### Opción 3: Ejecutar desde cualquier PC vía GitHub (Web One-liner)
Una vez subido a tu repositorio de GitHub, podés ejecutarlo en cualquier máquina sin descargar nada:
```powershell
irm https://raw.githubusercontent.com/<TU_USUARIO>/win-optimizer/main/Optimizar-Windows.ps1 | iex
```

---

## 🎯 Características

- **Menú Interactivo**: Elegí entre **PC de Escritorio** o **Notebook/Laptop**.
- **Barra de Progreso Animada**: Visualizá en tiempo real el porcentaje y avance de cada tarea.
- **Paso a Paso o Todo Automático**: Vos decidís si querés confirmar cada paso (`S/N/T`) o hacer todo de una sola vez.
- **Punto de Restauración Automático**: Por seguridad, crea un respaldo del sistema antes de modificar nada.
- **Optimizaciones específicas**:
  - **Escritorio**: Plan Ultimate Performance, baja latencia de red para juegos, desactivación de Search Indexer y telemetría.
  - **Notebook**: Plan High Performance en AC y Balanced en batería, conservando GPS ("Encontrar mi dispositivo") y Windows Search, eliminando la hibernación para liberar gigabytes de almacenamiento.
