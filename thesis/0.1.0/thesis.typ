#let pageSettings(doc, title, author) = {
  set document(author: author, title: title)
  set page("a4")
  set par(justify: true)

  show par: set block(spacing: 0.65em) // 段落ごとの間隔
  show list: set block(spacing: 0.65em)

  show emph: set text(font: ("Nimbus Roman", "Noto Sans CJK JP"))
  show strong: set text(font: ("Nimbus Roman", "Noto Sans CJK JP"), weight: 200)
  show raw: set text(font: "PlemolJP Console NF")

  show "、": "，"
  show "。": "．"
  show "": h(1em)
  doc
}


#let setupFrontPage(
    title: none, enTitle: none,
    id: "", author: "", supervisor: "",
    abst: none,
    sdgs: "", date: ""
  ) = {
  set page("a4")
  set text(font: ("Nimbus Roman", "IPAmjMincho"), lang: "ja")

  align(center)[ ,
    #set text(size: 18pt)
    #v(4em)

    令和5年度 \
    ██高等専門学校#h(0.25em)情報工学科 \
    卒業研究論文
    #v(2em)

    *#title* \
    *#enTitle*
    #v(1em)

    #set text(size: 15pt)
    #text(weight: "semibold")[Abstract]
    #v(-0.5em)
    #block(
      width: 80%,
      align(left)[#text(size: 10pt)[#abst]]
    )
    #v(1em)

    SDGs目標番号#sdgs
    #v(1em)
    研究者#author (学生番号 #id) \
    指導教官#supervisor
    #v(2em)

    #date
  ]
}


#let to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
" "
  }
}

#let toc() = {
  set page(
    footer: [#align(center)[#counter(page).display("i")]]
  )
  counter(page).update(1)

  set text(font: ("Nimbus Roman", "Noto Sans CJK JP"), lang: "ja")
  set text(size: 15pt)
  set par(leading: 1.25em)

  v(20pt)
  align(left)[#text(size: 18pt, weight: "semibold")[目次]]
  v(20pt)


  locate(loc => {
    let elements = query(heading.where(outlined: true), loc)
    for el in elements {
      let before_toc = query(heading.where(outlined: true).before(loc), loc).find((one) => {one.body == el.body}) != none
      let page_num = if before_toc {
      	numbering("i", counter(page).at(el.location()).first())
      } else {
      	counter(page).at(el.location()).first()
      }

      link(el.location())[#{
        let chapt_num = if el.numbering != none {
          numbering(el.numbering, ..counter(heading).at(el.location()))
        } else {none}
        
        if el.level == 1 {
          set text(weight: "medium")
          if chapt_num == none {} else {
            chapt_num
            "  "
          }
          let rebody = to-string(el.body)
          rebody
        } else if el.level == 2 {
          set text(size: 13pt)
          h(2em)
          chapt_num
          " "
          let rebody = to-string(el.body)
          rebody
        } else {
          h(5em)
          chapt_num
          " "
          let rebody = to-string(el.body)
          rebody
        }
      }]
      box(width: 1fr, h(0.5em) + box(width: 1fr, repeat[.]) + h(0.5em))
      [#page_num]
      linebreak()
    }
  })
}


#let mainText(
  title: none, enTitle: none,
  authors: (), date: "", 
  abst: none,
  doc
) = {
  set text(size: 10pt, lang: "ja", font: ("Nimbus Roman", "IPAmjMincho"))

  set enum(numbering: "(1a)", body-indent: 0.3em)
  set list(body-indent: 0.3em)
  
  set par(first-line-indent: 1em)
  show heading: it => {
    it
    par(text(size: 0pt, ""))
    v(-0.35em)
  }
  show figure: it => {
    it
    par(text(size: 0pt, ""))
    v(-0.65em)
  }
  show enum: it => {
    it
    par(text(size: 0pt, ""))
    v(-0.65em)
  }
  show list: it => {
    it
    par(text(size: 0pt, ""))
    v(-0.65em)
  }
  
  set heading(numbering: "1.")
  show heading: set text(font: ("Nimbus Roman", "Noto Sans CJK JP"))
  show heading.where(level: 1): set text(size: 12pt)
  show heading.where(level: 2): set text(size: 10pt)

  show figure.where(  // 表のキャプションの位置
    kind: table
  ): set figure.caption(position: top)

  set page(
    footer: [
      #align(center)[#counter(page).display("1")]
    ]
  )
  counter(page).update(1)

  set text(size: 10pt)
  align(center)[
    #v(1em)
    #text(size: 15.5pt)[*#title*]
    #v(0.5em)
    #text(size: 16pt)[*#enTitle*]
    #v(2em)
    #text(size: 12pt)[#grid(
      columns: (1fr,) * 2,
      row-gutter: 24pt,
      ..authors.map(author => author.name),
    )]
    #v(0.35em)
    #date
    #v(1em)
    *要旨*
    #block(
      width: 80%,
      align(left)[#abst]
    )
  ]
  v(1em)

  align(left)[#columns(2, doc)]
}


#let bib(title: "参考文献", body) = {
  set heading(numbering: none)
  align(center)[= #title]
  pad(top: -10pt, bottom: -5pt, line(length: 100%, stroke: 0.5pt))
  set enum(numbering: "1)")
  text(size: 7pt)[#body]
}


#let code(body) = {
  set raw(tab-size: 2)
  show raw.where(block: true): block.with(
    fill: rgb("f6f8fa"), inset: 8pt, radius: 5pt, width: 100%,
  )
  body
}


#let tbl(body, title: none) = {
  set text(size: 0.9em)
  figure(
    caption: title,
    body
  )
  par(text(size: 0pt, ""))
}


#let img(path, cap: "", width: 100%) = {
  set text(size: 0.9em)
  figure(
    image(path, width: width),
    caption: [#cap],
    kind: "image",
    supplement: [図]
  )
}
