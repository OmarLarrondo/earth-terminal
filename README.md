# Earth Terminal

Un planeta Tierra girando en vivo, renderizado con bloques de color de 24 bits en una
pane dedicada de tmux, mientras sigues usando tu shell normal al lado.

```
┌──────────────────────────────┬───────────────────────┐
│ omar@infiniteaux:~$           │                       │
│                               │          ▄▄▄▄         │
│                               │      ▄▄████████▄▄     │
│                               │    ▄██████████████▄   │
│                               │   ██████████████████  │
│                               │   ██████████████████  │
│                               │    ▀██████████████▀   │
│                               │      ▀▀████████▀▀     │
│                               │                       │
│                               │      EARTH • LIVE     │
└──────────────────────────────┴───────────────────────┘
```

Sin dependencias de Python: solo la librería estándar. Solo necesitas `bash` y `tmux`.

## Características

- Globo terráqueo animado a 10 FPS dibujado con caracteres `▀` y color RGB de 24 bits.
- Continentes definidos con polígonos de longitud/latitud, sombreado con terminador,
  casquetes polares, bandas de nubes y estrellas de fondo.
- La animación vive en su propia pane de tmux, así que **nunca borra ni interfiere con
  la línea de comandos** que estás escribiendo.
- Se adapta al tamaño de la ventana y se degrada con elegancia: si la terminal es
  pequeña o falta `tmux`, arranca un shell normal sin romper nada.
- Limpia la sesión de tmux al salir y restaura el terminal correctamente.

## Requisitos

- Linux o macOS
- `bash`
- `tmux`
- `python3` (3.10 o superior) para `spinning-earth`

## Instalación

```bash
git clone https://github.com/OmarLarrondo/earth-terminal.git
cd earth-terminal
./install.sh
```

El instalador copia los dos scripts a `~/bin` y añade el arranque automático a tu
`~/.bashrc` (solo si no estaba ya). Asegúrate de que `~/bin` esté en tu `PATH`.

Instalación manual:

```bash
mkdir -p ~/bin
cp earth-terminal spinning-earth ~/bin/
chmod +x ~/bin/earth-terminal ~/bin/spinning-earth
```

Y añade esto al final de tu `~/.bashrc`:

```bash
# Start the rotating Earth in a dedicated tmux pane for interactive terminals.
# Set NO_EARTH_TERMINAL=1 before launching Bash to opt out temporarily.
if [[ $- == *i* ]] \
    && [ -t 0 ] && [ -t 1 ] \
    && [ -z "${TMUX:-}" ] \
    && [ -z "${NO_EARTH_TERMINAL:-}" ] \
    && [ "${TERM:-}" != "dumb" ] \
    && command -v earth-terminal >/dev/null 2>&1; then
    exec earth-terminal
fi
```

## Uso

Abre una terminal nueva (o ejecuta `exec bash`) y el globo aparecerá a la derecha.

| Variable | Por defecto | Descripción |
| --- | --- | --- |
| `EARTH_PANE_WIDTH` | `42` | Ancho en columnas de la pane del globo. |
| `NO_EARTH_TERMINAL` | _(vacío)_ | Ponlo a `1` para arrancar sin el globo. |

Ejemplos:

```bash
# Globo más estrecho
EARTH_PANE_WIDTH=34 exec bash

# Arrancar sin el globo esta vez
NO_EARTH_TERMINAL=1 exec bash
```

Para ver solo la animación a pantalla completa:

```bash
./spinning-earth
```

## Cómo funciona

- `earth-terminal`: script Bash que comprueba el tamaño de la terminal, crea una sesión
  de tmux, abre el shell a la izquierda y `spinning-earth` a la derecha. Un `trap` y un
  hook de tmux cierran la sesión cuando sales.
- `spinning-earth`: renderizador en Python que proyecta una esfera, consulta si cada
  punto es tierra u océano, aplica iluminación y escribe el frame con secuencias ANSI.

## Desinstalación

```bash
rm ~/bin/earth-terminal ~/bin/spinning-earth
```

Y elimina el bloque marcado con `# Start the rotating Earth` de tu `~/.bashrc`.

## Licencia

MIT. Ver [LICENSE](LICENSE).
