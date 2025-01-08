#let withid(cap, content, id: none) = [
  #set text(font: "UDEV Gothic 35NF", size: 0.9em)

  #align(center)[#figure(caption: cap, content)#label(
    if id == none {
      cap
    } else {
      id
    }
  )]
]

#let img(cap, type: "png", id: none, src: none, width: auto, height: 100pt) = [
  #withid(
    if id == none or src == none {
      cap.slice(3)
    } else {
      cap
    },
    image(
      if src == none {
        "/figs/" + if id == none { cap } else { id } + "." + type
      } else {
        src
      },
      width: width,
      height: height
    ),
    id: id
  )
]
