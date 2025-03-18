#import "../styling.typ" as styling

#let body-inset = 0.8em
#let stroke-width = 0.13em
#let corner-radius = 5pt

#let boxy(title, tags, body, supplement, number, accent-color) = {
  assert(
    type(accent-color) == color,
    message: "Please provide a color as argument for the frame instance"
      + supplement,
  )

  let stroke = accent-color + stroke-width

  let round-bottom-corners-of-tags = body == []
  let display-supplement = supplement not in ([], "")
  let round-top-left-body-corner = supplement in ([], none) and title in ([], "")

  let header() = align(
    left,
    {
      let inset = 0.5em

      let additions = ()
      let supplement-str = supplement + number
      
      if display-supplement {
        let supplement-cell = grid.cell(fill: accent-color, supplement-str)
        additions.insert(0, supplement-cell)
      }

      if title not in ([], none) {
        additions.push(title)
      }

      let rounded-corners = (top: corner-radius)
      if round-bottom-corners-of-tags {
        rounded-corners.bottom = corner-radius
      }

      let rendered-tags = if additions == () [] else {
        let grid-cells = additions.intersperse(grid.vline(stroke: stroke))
        let title-grid = grid(columns: additions.len(), align: horizon, inset: inset, ..grid-cells)
        box(clip: true, stroke: stroke, radius: rounded-corners, title-grid)
        h(1fr)
      }

      // tagsをsupplementの位置（number付きのボックス）に表示
      let tags-str = ""
      if tags.len() > 0 {
        tags-str = tags.at(0, default: "")
        for i in range(1, tags.len()) {
          tags-str += ", "  +  tags.at(i)
        }  
      } 
      let tags-box = box(inset: inset)[#tags-str]

      layout(((width: available-width)) => {
        if measure(rendered-tags + tags-box).width < available-width {
          rendered-tags
          tags-box
        } else [
          #tags-str\
          #rendered-tags
        ]
      })
    },
  )

  let board() = {
    let round-corners = (bottom: corner-radius, top-right: corner-radius)
    if round-top-left-body-corner {
      round-corners.top-left = corner-radius
    }
    align(
      left,
      block(
        width: 100%,
        inset: body-inset,
        radius: round-corners,
        stroke: stroke,
        spacing: 0em,
        outset: (y: 0em),
        {
          show: styling.dividers-as({
            v(body-inset - 0.75em)
            line(length: 100% + 2 * body-inset, stroke: stroke)
            v(body-inset - 0.75em)
          })
          body
        },
      ),
    )
  }

  let parts = ()

  let rounded-corners = (bottom: corner-radius)

  // ヘッダー表示条件をsupplementに変更
  if supplement != none {
    parts.push(header())
  }

  if body != [] {
    parts.push(board())
  }

  stack(..parts)
}
