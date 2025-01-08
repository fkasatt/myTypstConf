#let roremu(words, offset: 0, custom-text: none) = {
  let text = if custom-text == none { read("黒死館.txt") } else { custom-text }
  let length = text.clusters().len()
  let times = calc.div-euclid(offset + words, length) + 1
  (text * times).clusters().slice(offset, offset + words).join("")
}
