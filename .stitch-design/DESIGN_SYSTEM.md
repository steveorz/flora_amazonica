# Amazon Flora Identifier — Design System Reference

> Fuente: proyecto Stitch `projects/3220143442203567793` ("Amazon Flora Identifier")
> Fetched: 2026-05-06 vía MCP `stitch.googleapis.com/mcp`
> Design philosophy: **"The Modern Explorer's Field Journal" / "Botanical Monograph"**

---

## 1. North Star

App móvil-first para botánicos / exploradores en campo amazónico (Iquitos, Loreto). Estética de monografía científica de alta gama: tipografía editorial, asimetría intencional, capas tipo "papel orgánico apilado" en lugar de bordes/divisores. Persona: **"Digital Curator"**. Mobile (todas las screens son `MOBILE`, ancho ~780px en mockups que escalan a 390px reales).

---

## 2. Tokens de color (Material Design 3, light)

Paleta declarada en `tailwind.config.colors` y replicada en cada HTML. Origen: bosque amazónico + papel envejecido + advertencia naranja/tierra.

### Marca
| Token | Hex | Uso |
|---|---|---|
| `primary` | `#012D1D` | Verde bosque profundo. Texto principal, headers, botones primarios |
| `primary-container` | `#1B4332` | Verde medio. Tarjetas oscuras, FABs, "Chlorophyll Gradient" stop |
| `secondary` | `#A23F00` | **Tierra/óxido oscuro**. Énfasis científico (italic), acentos, eyebrows |
| `secondary-container` | `#FC7127` | Naranja vibrante. **NO usar como acento puro** — el override es `#D35400` |
| `tertiary` | `#002D1C` / `tertiary-container` `#00452E` | Verde alterno para datos taxonómicos profundos |
| `error` | `#BA1A1A` / `error-container` `#FFDAD6` | |

> **CTA naranja real en HTMLs:** `#D35400` (override del designTheme). Es el color de acción más visible.

### Superficie (jerarquía sin bordes)
| Token | Hex | Uso |
|---|---|---|
| `background` / `surface` / `surface-bright` | `#F9FAF3` | "Bone white" — base |
| `surface-container-low` | `#F3F4ED` | Secciones |
| `surface-container` | `#EDEEE8` | |
| `surface-container-high` | `#E8E9E2` | Chips, contenedores de íconos |
| `surface-container-highest` | `#E2E3DC` | Inputs (trough) |
| `surface-container-lowest` | `#FFFFFF` | Tarjetas elevadas (pop) |
| `surface-dim` | `#D9DBD4` | |

### Tipografía/outlines
| Token | Hex |
|---|---|
| `on-background` / `on-surface` | `#1A1C18` (negro tinta — **nunca `#000`**) |
| `on-surface-variant` | `#414844` |
| `outline` | `#717973` |
| `outline-variant` | `#C1C8C2` (usado al **20% opacidad** como "ghost border") |

### Inversos / fixed
`inverse-primary` `#A5D0B9`, `inverse-surface` `#2F312D`, `inverse-on-surface` `#F0F1EA`,
`primary-fixed` `#C1ECD4`, `primary-fixed-dim` `#A5D0B9`,
`secondary-fixed` `#FFDBCD`, `secondary-fixed-dim` `#FFB595`,
`tertiary-fixed` `#B1F0CE`, `tertiary-fixed-dim` `#95D4B3`.

### "Chlorophyll Gradient" (firma)
```css
.chlorophyll-gradient { background: linear-gradient(155deg, #012D1D 0%, #1B4332 100%); }
```
Solo para CTAs primarios y headers de identidad.

---

## 3. Tipografía

| Familia | Pesos | Uso |
|---|---|---|
| **Space Grotesk** | 300/400/500/600/700 | `font-headline` — display, títulos, números clave |
| **Public Sans** | 300/400/600/700 + italic 400 | `font-body`, `font-label` — todo lo demás |
| **Material Symbols Outlined** | wght 100-700, FILL 0-1 | íconos (1.5pt stroke) |

Tailwind:
```js
fontFamily: { headline: ["Space Grotesk"], body: ["Public Sans"], label: ["Public Sans"] }
```

### Escala editorial observada
- **Display hero**: `text-4xl md:text-6xl font-bold text-primary leading-[1.1]` (Catálogo Virtual de Flora Amazónica)
- **Headline section**: `font-headline text-2xl md:text-3xl font-bold` (CTAs grandes)
- **Headline card**: `font-headline text-3xl font-bold` (nombres de especie en imagen)
- **Headline subsection**: `font-headline text-xl font-semibold text-primary`
- **Stat**: `font-headline text-xl font-bold text-primary` con span `text-xs font-normal` para unidades
- **Eyebrow / metadata**: `text-[10px] uppercase tracking-[0.2em] text-secondary font-bold` (location, IDs)
- **Body**: `text-on-surface-variant text-lg leading-relaxed italic` (descripciones)
- **Label small**: `text-[12px] font-medium` o `text-xs uppercase tracking-widest`

### Reglas tipográficas
- **Nomenclatura científica → italic + `text-secondary`** (`#A23F00`). Ej: *Ceiba pentandra*, *Calycophyllum spruceanum*.
- Eyebrows con `tracking-[0.2em]` o `tracking-widest`.
- Descripciones largas en *italic* (sensación de "field notes").
- Números grandes con unidad pequeña al lado (`88%` + "Promedio Iquitos").

---

## 4. Border radius (override del default Tailwind)

```js
borderRadius: { DEFAULT: "0.125rem", lg: "0.25rem", xl: "0.5rem", full: "0.75rem" }
```
Sí, `rounded-full` aquí significa **0.75rem (12px)**, no circular. Para circular real se usa el shape natural (w/h iguales + radius alto vía clases).

- Tarjetas / botones grandes: `rounded-xl` (8px)
- Imágenes: `rounded-xl` (8px)
- Chips: `rounded-full` (12px en este sistema)
- Bottom nav: `rounded-t-xl` o `rounded-t-2xl`

---

## 5. Espaciado, layout y elevación

- **Roundness preset**: `ROUND_FOUR`, **spacingScale**: `3` (sistema "generoso").
- Mobile: padding lateral `px-6`, top `pt-8`, bottom `pb-24` (deja espacio al bottom nav).
- Container central: `max-w-5xl mx-auto`.
- Grid responsivo: `grid grid-cols-1 md:grid-cols-12 gap-8` (7+5 split típico).
- Separación entre secciones: `mb-12` ó `mb-16`; entre items: `space-y-6` / `space-y-8`.
- Chips horizontales: `flex gap-3 overflow-x-auto pb-2 no-scrollbar`.

### Elevación: Tonal Layering, **NO sombras agresivas**
- Pop suave: `shadow-sm`. Bottom nav: `shadow-[0_-4px_24px_rgba(26,28,24,0.04)]`.
- **Prohibido** `border` 1px sólido como divisor → usar cambio de superficie (`surface-container-low` sobre `surface`).
- **Prohibido** `#000` puro y sombras Material clásicas.
- Sombra cuando algo "flota": 24px blur, 4% opacidad, color tintado de `#1A1C18`.

### Glassmorphism (bottom nav)
```html
class="fixed bottom-0 ... bg-[#F9FAF3]/80 backdrop-blur-md border-t border-[#EDEEE8]/20"
```

### "Ghost Border" (única forma válida de borde)
`outline-variant` al 20% opacidad. En focus de input pasa a `secondary` 100%.

---

## 6. Componentes core

### Header sticky
- Altura fija, `bg-[#F9FAF3]` (puede volverse glass al scroll), `sticky top-0 z-50`.
- Izquierda: ícono brand (`park`/`menu`/`arrow_back`) + título `font-['Space_Grotesk'] text-xl/2xl font-bold text-primary`.
- Derecha: 1-2 íconos (search, account_circle).

### Bottom nav (glass + rounded top)
- 2 a 4 botones. **Activo**: pill con `bg-[#1B4332] text-white rounded-xl px-4-6 py-2`, ícono FILL 1.
- Inactivo: ícono outline + label `text-[10px]-text-[12px] uppercase tracking-widest`.
- Iconos típicos: `eco`, `search_check`, `biotech`, `center_focus_strong`, `potted_plant`, `settings`.

### Search input ("trough")
```html
<div class="bg-surface-container-highest rounded-xl p-1 flex items-center shadow-sm">
  <span class="material-symbols-outlined px-4 text-outline">search</span>
  <input class="bg-transparent border-none focus:ring-0 w-full py-4 placeholder:text-outline" />
  <button class="bg-primary text-white px-6 py-3 rounded-xl font-semibold mr-1">Explorar</button>
</div>
```

### Botón primario (CTA orange)
```html
<button class="w-full bg-[#D35400] text-white py-8 px-8 rounded-xl flex items-center
               justify-between gap-6 hover:scale-[1.01] shadow-xl shadow-secondary/10">
```
Mínimo 56px de alto (uso con guantes en campo).

### Botón secundario / ghost
Texto + `text-secondary font-bold tracking-widest uppercase`, hover underline.

### Specimen card (hero con imagen)
```html
<div class="group relative overflow-hidden rounded-xl bg-surface-container-low aspect-[16/9]">
  <img class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110 opacity-90" />
  <div class="absolute inset-0 bg-gradient-to-t from-primary/80 to-transparent flex flex-col justify-end p-8">
    <p class="text-secondary-fixed text-xs font-bold uppercase tracking-widest italic">Ceiba pentandra</p>
    <h5 class="text-white font-headline text-3xl font-bold">Gran Lupuna del Amazonas</h5>
    <!-- meta: location_on, height, etc. -->
  </div>
</div>
```

### Specimen card (lista resultado)
- `bg-surface-container-lowest` (blanco) con `rounded-xl` y `shadow-sm`.
- Imagen lateral o superior `rounded-lg` (en el sistema = 4px).
- Eyebrow porcentaje match (`98% de coincidencia`) en `text-secondary` o pill orange.
- Nombre científico italic + autor (`(Poepp.) J.C. Sowerby`) abreviado.
- Nombres comunes: `Nombre común: ...`.
- Trait icons inline (eco, location_on).

### Stat row (datos del ecosistema)
```html
<div class="flex items-center gap-4">
  <div class="w-12 h-12 bg-surface-container-high rounded-lg flex items-center justify-center text-secondary">
    <span class="material-symbols-outlined">humidity_percentage</span>
  </div>
  <div>
    <p class="text-xs text-on-surface-variant font-bold uppercase">Humedad Relativa</p>
    <p class="font-headline text-xl font-bold text-primary">88% <span class="text-xs font-normal">Promedio Iquitos</span></p>
  </div>
</div>
```

### Trait chips / filter chips (selección morfológica)
- Caja blanca grande (`bg-surface-container-lowest`) con ícono Material centrado y label debajo: `Árbol`, `Arbusto`, `Hierba`, `Liana`.
- Estado seleccionado: `bg-primary text-white` o `chlorophyll-gradient`.
- Chip color (color de exudado): círculos puros con borde `outline-variant`; selección con `secondary` ring.
- Chip texto pequeño: `bg-surface-container-high text-primary px-3 py-1 rounded-full text-xs font-semibold`.

### Info card (verde sólido)
```html
<div class="bg-primary text-white p-6 rounded-xl flex items-start gap-4">
  <span class="material-symbols-outlined text-secondary">info</span>
  <div>
    <p class="text-sm font-semibold text-on-primary-container">Contribución Científica</p>
    <p class="text-xs text-white/70 leading-relaxed">…APG IV…</p>
  </div>
</div>
```

### Lista de caracteres diagnósticos
Bullets manuales con ícono Material `fiber_manual_record` (mini punto) + texto, 16px gap vertical, **sin** `<hr>`.

---

## 7. Iconografía (Material Symbols Outlined, weight 400, opsz 24)

Usados a lo largo del sistema:
- Marca/nav: `park`, `eco`, `forest`, `nature`, `menu`, `arrow_back`, `search`, `search_check`, `account_circle`, `settings`
- Identificación: `biotech`, `center_focus_strong`, `potted_plant`
- Botánica: `grass`, `account_tree`, `water_drop`, `humidity_percentage`, `map`, `location_on`, `height`
- Etnobotánica: `medical_services` (medicinal), `home_work` (maderable), `psychology` (cultural)
- Datos: `info`, `share`, `fiber_manual_record`
- Filled (`FILL 1`) solo en estados activos / FABs.

---

## 8. Pantallas (12 instancias, 11 únicas reales + 1 asset)

> Existen **dos tracks paralelos** en el proyecto:
> - **Track A — "Herbarium Digital"**: versión completa/exploratoria (textos largos)
> - **Track B — "Catálogo digital" (Simplificado)**: versión depurada (header con ícono `park`, bottom nav 2 botones)
>
> La versión refinada/canónica es **Track B (Simplificado)** — el Inicio (Simplificado) y el Buscador Especializado (Botánico) representan la línea más actual.

| ID | Título | Track | Notas |
|---|---|---|---|
| `b07144121c79443d97e0693afd79324b` | Inicio | A (legacy) | Header con `menu` + `account_circle`; bottom nav 4 botones (Explorar/Identificar/Favoritos/Ajustes) |
| `ffad8d75e94347d5a58efbc396659b7f` | Inicio (Simplificado) | **B canónico** | Header con `park`; bottom nav 2 botones (Explorar/Identificar) |
| `90bad1afbaf24410bbd4ca42fbd626e6` | Amazon Flora Catalog & Identification | preview 390×884 | Sin screenshot — mockup pequeño |
| `402b969dd25e4a4faeaf0b42ea258c3c` | Buscador Morfológico | A | Filtros: Hábito / Exudado / Floración / Semilla |
| `79b6e72989cf464ab07cf29520cf5703` | Buscador Morfológico (Simplificado) | B | Idéntico estructuralmente a A; brand "Catálogo digital" |
| `2b3c14571a8341048de0270088c7e48b` | Buscador Especializado (Botánico) | **B avanzado** | Filtros: Hábito / Exudado / Floración / Dimensiones (más técnico) |
| `56c389f07f8d4daea8b837036916193c` | Resultados de Identificación | A | "4 coincidencias taxonómicas encontradas", 98%/85%/72%/64% |
| `5aa4f28bf00345e89a21af8ca84a60c7` | Resultados (Simplificado) | B | Mismas 4 especies, brand B |
| `30307013f70e43e1903d0f8d512b4750` | Ficha Técnica Especie | A | *Calycophyllum spruceanum* (Capirona) |
| `919a4ebc22914d5c8ccd8072337af3d1` | Ficha Técnica (Simplificado) | B | Misma especie, brand B |
| `7146fec4f3de4531a2814de91604682f` | Ficha Técnica Botánica (Actualizada) | **B v2** | Añade `Origen: Nativa` |
| `assets-d4950b00...` | (asset interno design system) | — | Ignorar para diseño |

### Pantalla 1 — Inicio (Simplificado, canónica)
- Header: `park` + "Catálogo digital" + `search`.
- Hero: eyebrow "Iquitos · Región Loreto" naranja, H2 `display` "Catálogo Virtual de Flora Amazónica", párrafo italic.
- Search bar trough con chips de búsquedas frecuentes (`Lupuna`, `Victoria amazonica`, `Ayahuasca`, `Cedrela odorata`).
- CTA naranja gigante "Identificación Morfológica Asistida" + ícono `biotech` filled.
- Sección dual: "Especies Destacadas" (specimen card hero con gradiente sobre imagen) + "Datos del Ecosistema" (stats: 88% humedad, 4,289 especies, 12 zonas).
- Info card verde "Contribución Científica" (APG IV).
- Bottom nav: Explorar (activo) / Identificar.

### Pantalla 2 — Buscador Morfológico / Especializado
- Header: `arrow_back` + brand + `search`.
- Eyebrow "Identificación Técnica" + título "Buscador Morfológico".
- Subtítulo: "Filtros botánicos especializados para la Flora Amazónica de Iquitos."
- Secciones colapsables / agrupadas:
  - **Hábito**: 4 tarjetas de selección (Árbol/Arbusto/Hierba/Liana) con ícono central.
  - **Exudado**: subgrupo "Tipo" (Látex/Resina) + "Color de Exudado" (chips de color: Blanco/Transp./Rojo/Amarillo).
  - **Floración**: Boca, Hermafrodita; Inflorescencia (Panícula/Umbela/Espiga).
  - **Dimensiones** (variante avanzada): Longitud del Peciolo, Longitud de Hojas, etc., en sliders/inputs.
  - **Semilla** (variante simplificada): Long, Ancho, Forma.
- CTA verde fijo inferior: "Ver Especies Filtradas" o "Identificar".

### Pantalla 3 — Resultados de Identificación
- Header con back + brand.
- Eyebrow "Búsqueda Avanzada" + título "Lista de Resultados".
- Tarjeta resumen superior con thumb "Imagen procesada" + "4 coincidencias taxonómicas encontradas".
- Lista de 4 specimen cards (blanco), cada una:
  - Imagen circular/rectangular pequeña.
  - Pill naranja con `XX% de coincidencia` (98%, 85%, 72%, 64%).
  - Nombre científico italic + autor abreviado (`(Poepp.) J.C. Sowerby`, `Liebm.`, `Ruiz & Pav.`, etc.).
  - Línea "Nombre común: …".
  - Mini-traits con íconos `eco`, `location_on`.
- CTA inferior: "Refinar Identificación".
- Especies de muestra: *Victoria amazonica*, *Monstera deliciosa*, *Heliconia rostrata*, *Hevea brasiliensis*.

### Pantalla 4 — Ficha Técnica Especie
- Header con back, brand, share.
- Galería superior 3 thumbnails (Hábito General / Morfología Foliar / Estructura Floral) — placement asimétrico.
- Bloque identidad:
  - Pill o eyebrow `potted_plant` + "Familia: Rubiaceae".
  - Display name: **Calycophyllum spruceanum** (italic, secondary, **HUGE**).
  - Subtítulo: "Origen: Nativa" (en versión actualizada).
  - "Nombres locales: Capirona de altura, Palo Mulato".
- "Descripción Botánica": párrafo largo *italic*.
- "Caracteres Diagnósticos": lista bullets con `fiber_manual_record`:
  - "Corteza lisa decorticante."
  - "Inflorescencias cimosas terminales."
  - "Estípulas interpeciolares caducas."
- "Estado de Conservación": card con texto IUCN.
- **"Valor Etnobotánico"**: tres tarjetas blancas con ícono coloreado:
  - `medical_services` — **Uso Medicinal**
  - `home_work` — **Uso Maderable**
  - `psychology` — **Valor Cultural**
- Sección "Ver Más Información" o galería al final (imagen full bleed).

---

## 9. Reglas de comportamiento (do/don't sintetizadas)

### DO
- Espacio en blanco generoso (≥ 16-32px entre items, ≥ 48-64px entre secciones).
- Color `secondary` (`#A23F00` o el override `#D35400`) **solo** para acción + nomenclatura científica.
- Asimetría intencional en galerías (tipo scrapbook).
- Bottom nav glass + rounded top.
- Botones primarios mínimo 56px alto.
- Imágenes con `aspect-[16/9]` o ratios naturales, `rounded-xl`, `object-cover`, hover `scale-110`.
- Italic para descripciones y nomenclatura.
- Pesos altos (600/700) en headlines; light/regular en body.

### DON'T
- No `border` 1px sólido como divisor → cambio de `surface-container-*`.
- No `#000` puro → `#1A1C18`.
- No sombras Material agresivas → `shadow-sm` o tonal layering.
- No bordes 100% opacos en inputs → ghost border 20%.
- No verde primario solo (#012D1D) en CTAs → usar gradient o naranja `#D35400`.
- No mezclar ambos tracks de branding ("Herbarium Digital" + "Catálogo digital") en la misma vista.

---

## 10. Stack técnico (de los HTMLs Stitch)

- **Tailwind CSS via CDN** + plugins `forms`, `container-queries`.
- Modo: `class` darkMode (light por defecto, dark color tokens declarados).
- Idioma: `lang="es"`.
- Viewport: `width=device-width, initial-scale=1.0`.
- Fuentes desde Google Fonts (Space Grotesk + Public Sans + Material Symbols Outlined).
- Imágenes: hospedadas en `lh3.googleusercontent.com/aida-public/...` (placeholders Stitch — reemplazar al implementar).

---

## 11. Archivos de referencia local

```
.stitch-design/
├── DESIGN_SYSTEM.md            (este archivo)
├── 01_project.json             metadata + designTheme + screenInstances
├── 02_screens_list.json        índice de screens
├── 03_design_systems.json      design system asset
├── _design_theme.json          designTheme extraído (incluye designMd con la filosofía)
├── _screens_index.json         mapping ID → título / dimensiones / URLs
├── _all_screen_ids.txt
├── html/<id>.html              11 HTMLs renderizables (Tailwind CDN, drop-in)
├── screen_<id>.json            respuesta MCP cruda por pantalla
└── screenshots/<id>.png        thumbnails Stitch
```

Para ver una pantalla en el navegador: `open html/<id>.html`. Los HTMLs son standalone — usan Tailwind CDN.
