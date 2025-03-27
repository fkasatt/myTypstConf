#import "@local/conf:0.1.0": withid

#let img(cap, src: none, id: "", width: auto, height: 100pt) = [
  #withid(
    cap,
    image(
      if src == none {
        "/figs/" + id
      } else {
        "/figs/" + src
      },
      width: width,
      height: height
    ),
    id: id
  )
]
