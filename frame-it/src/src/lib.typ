#import "styling.typ" as styling
#import "bundled-layout.typ": divide, breakable-frames

#let styles = {
  import "styles/boxy.typ": boxy
  import "styles/hint.typ": hint
  (boxy: boxy, hint: hint)
}

// DEPRECATED. Use `frames` and `show: frame-style()` instead
#let make-frames(
  kind,
  style: styles.boxy,
  base-color: red.lighten(60%).desaturate(40%),
  ..frames,
) = {
  import "parse.typ": fill-missing-colors
  import "bundled-layout.typ": bundled-factory

  for (id, supplement, color) in fill-missing-colors(base-color, frames) {
    ((id): bundled-factory(style, supplement, kind, color))
  }
}

#let default-kind = "frame"

#let frames(
  kind: default-kind,
  base-color: red.lighten(60%).desaturate(40%),
  ..frames,
) = {
  import "parse.typ": fill-missing-colors
  import "layout.typ": frame-factory

  for (id, supplement, color) in fill-missing-colors(base-color, frames) {
    // ((id): frame-factory(kind, supplement, color))
    ((id): frame-factory(id, supplement, color))
  }
}

#let frame-style(kind: default-kind, style) = {
  import "layout.typ" as layout
  layout.frame-style(kind, style)
}
