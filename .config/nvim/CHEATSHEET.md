# Neovim cheatsheet

Leader = Espacio.
  cheat            -> todo
  cheat git        -> solo las secciones que matcheen

## Flujo diario
  Space sf        buscar archivos
  Space sg        buscar texto en el proyecto (grep)
  Space Space     cambiar entre buffers abiertos
  Space gs        archivos con cambios / pendientes de commit
  Space gL        historial de commits
  Space f         formatear el buffer
  grn             renombrar el simbolo bajo el cursor
  grd / grr       ir a definicion / ver referencias
  K               documentacion del simbolo (hover)
  Ctrl s          guardar
  Space ft        abrir terminal (o Ctrl /)
  Space qq        salir de todo

## Navegar un proyecto
  Space e         explorador de carpetas (Snacks, raiz del proyecto)
  Space E         explorador de carpetas (cwd)
  Space sf        buscar archivos (raiz del proyecto)
  Space sF        buscar archivos (solo el directorio actual)
  Space sG        buscar solo archivos versionados (git)
  Space sT        simbolos del archivo actual (treesitter, sin LSP)
  Space sg        live grep (texto en todo el proyecto)
  Space sw        palabra bajo el cursor en el proyecto
  gO              outline: simbolos del archivo (LSP)
  gW              simbolos del workspace (LSP)
  grd / grr       ir a definicion / ver referencias
  Ctrl o / Ctrl i atras / adelante (jumplist)

## Git
  Space gs        archivos modificados / pendientes de commit (preview del diff)
  Space gL        commits del repo
  Space gl        commits del archivo actual
  ]c / [c         hunk siguiente / anterior
  Space hs / hr   stage / reset hunk
  Space hS / hR   stage / reset buffer entero
  Space hp        preview del hunk
  Space hb        blame de la linea
  Space hd / hD   diff contra el index / contra el ultimo commit
  Space hq / hQ   hunks del archivo / del repo a quickfix
  Space tb        toggle blame de la linea
  Space tw        toggle word diff
  ih              text object: hunk
  Para commitear: Space ft y ahi "git add -p" / "git commit".

## Buscar  (telescope)
  Space sf   archivos (raiz del proyecto)
  Space sF   archivos (solo el directorio actual)
  Space sg   live grep
  Space sw   palabra bajo el cursor
  Space sd   diagnosticos
  Space sh   ayuda (:help)
  Space sk   keymaps
  Space ss   lista de pickers
  Space sc   comandos
  Space sr   reanudar ultimo picker
  Space s.   archivos recientes
  Space s/   live grep en archivos abiertos
  Space sn   archivos de tu config
  Space Space  buffers abiertos
  Space /    fuzzy find dentro del buffer

## Dentro de telescope
  Ctrl n / Ctrl p   siguiente / anterior
  Enter             abrir
  Ctrl x            split horizontal
  Ctrl v            split vertical
  Ctrl t            nueva tab
  Ctrl u / Ctrl d   scroll del preview
  Esc               cerrar
  Ctrl / o ?        ver todos los atajos
  q                 cerrar (modo normal)

## LSP  (buffers con server activo)
  grd    definicion
  grr    referencias
  gri    implementaciones
  grt    definicion de tipo
  gO     simbolos del documento
  gW     simbolos del workspace
  grn    renombrar
  gra    code action
  grD    declaracion
  K      hover
  Space th  toggle inlay hints

## Diagnosticos
  ]d / [d   siguiente / anterior
  ]e / [e   siguiente / anterior error
  ]w / [w   siguiente / anterior warning
  Space cd  diagnostico de la linea
  Space q   mandar a quickfix

## Buffers
  ]b / [b        siguiente / anterior
  Shift h / l    buffer anterior / siguiente
  Space bb       buffer alterno
  Space bd       cerrar buffer

## Ventanas
  Ctrl h/j/k/l    mover foco
  Ctrl flechas    redimensionar
  Space -         split abajo
  Space |         split a la derecha
  Space wd        cerrar ventana

## Edicion
  Ctrl s         guardar
  Alt j / Alt k  mover linea abajo / arriba
  < / >          indentar manteniendo seleccion (visual)
  gc / gb        comentar (nativo)
  Space fn       archivo nuevo
  Ctrl + / -     zoom (solo Neovide)

## Multicursor / ocurrencias
  * / #            seleccionar y buscar la palabra bajo el cursor
  gn / gN          seleccionar siguiente / anterior ocurrencia (nativo)
  cgn  +  .        cambiar ocurrencia y repetir con .  (cambiar TODAS)
  dgn              borrar la siguiente ocurrencia
  Ctrl n / Ctrl p  multicursor: agregar en ocurrencia sig / anterior
  Space mc         multicursor: cursor en TODAS las ocurrencias
  Space md         multicursor: duplicar cursors
  Space ma         multicursor: alinear columnas
  Space mx         multicursor: borrar cursor principal
  Space mr         multicursor: restaurar cursors
  Alt abajo/arriba multicursor: agregar cursor en linea de abajo / arriba
  Ctrl click       multicursor: agregar / quitar cursor con el mouse
  Flecha izq/der   con varios cursors: mover el cursor principal
  Esc              con varios cursors: limpiar
  aa / ii          text objects: around / inside (mini.ai)
  viw vap vaf ...  seleccion visual normal

## Formateo
  Space f   formatear el buffer (conform / LSP)

## Mantenimiento
  :lua vim.pack.update()                         actualizar plugins
  :lua vim.pack.update(nil, { offline = true })   ver actualizaciones pendientes
  :Mason                                          gestionar LSP / formatters / tools
  :checkhealth                                    diagnostico general

## Varios
  Esc   limpiar busqueda
