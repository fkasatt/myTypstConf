#import "@local/conf:0.1.0": withid

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
