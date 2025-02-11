import
  x11 / [x, xlib],
  client,
  area

# TODO: Put this in the config file
const systrayIconSpacing*: int = 4

type
  Systray* = ref object
    window*: Window
    icons*: seq[Icon]
  Icon* = ref object of Client
    isMapped*: bool

proc newIcon*(window: Window): Icon =
  Icon(window: window)

proc getWidth*(this: Systray): int =
  for icon in this.icons:
    result += icon.width.int + systrayIconSpacing
  result = max(1, result + systrayIconSpacing)

proc windowToIcon*(this: Systray, window: Window): Icon =
  let index = this.icons.find(window)
  if index != -1:
    return this.icons[index]

proc addIcon*(this: Systray, icon: Icon) =
  if icon == nil:
    return
  this.icons.insert(icon, 0)

proc removeIcon*(this: Systray, icon: Icon) =
  if icon == nil:
    return
  let index = this.icons.find(icon)
  if index != -1:
    this.icons.delete(index)

proc show*(this: Systray, display: PDisplay, barArea: Area) =
  ## Moves the status bar off screen.
  discard XMoveWindow(
    display,
    this.window,
    barArea.x + barArea.width - this.getWidth(),
    barArea.y
  )

proc hide*(this: Systray, display: PDisplay, barArea: Area) =
  ## Moves the status bar off screen.
  discard XMoveWindow(
    display,
    this.window,
    -this.getWidth() * 2,
    -barArea.height * 2
  )

