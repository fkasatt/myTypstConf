#import "@preview/numbly:0.1.0": numbly
#import "@local/SugarSyntax:0.1.0": *
#import "@local/bxbib:0.2.2": *

#let mincho = ("Times New Roman", "Zen Old Mincho", "Noto Serif CJK JP")
#let gothic = ("IBM Plex Sans", "LINE Seed JP_TTF", "Noto Sans CJK JP")
#let titleFonts = ("Times New Roman", "LINE Seed JP_TTF")
#let rawCode = "PlemolJP Console NF"

#let pageSettings(
  title: [],
  author: "",
  id: "",
  date: datetime.today(),
  titleDisplay: false,
  textFonts: mincho,
  fontSize: 9pt,
  colnum: 2,
  pageMargin: auto,
  body
) = {
  // ページ設定
  set page(paper: "a4", margin: pageMargin, numbering: "- 1/1 -")
  set par(first-line-indent: (amount: 1em, all: true), justify: true, leading: 0.65em, spacing: 0.65em)
  set document(title: title, author: author, date: date)

  // 他テキスト関連
  show "、": "，"
  show "。": "．"
  set text(costs: (hyphenation: 100%, runt: 100%, widow: 0%, orphan: 0%))

  // フォント設定
  set text(size: fontSize, lang: "ja", font: textFonts)
  show emph: set text(font: ("Times New Roman", "PlemolJP Console NF"))
  show strong: set text(font: gothic, size: 0.95em)
  set strong(delta: 200)
  show raw: set text(font: rawCode, weight: "medium")

  // 数式ブロックの設定
  set math.equation(numbering: "(1)", number-align: bottom, supplement: [式])

  // リスト構文の調整
  set enum(numbering: "(1a)", body-indent: 0.33em, indent: 0.5em)
  set list(body-indent: 0.35em, indent: 1.3em)

  // 図表キャプション
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: set text(size: 0.9em, font: "UDEV Gothic 35HSJPDOC", weight: "semibold")
  show figure.where(kind: table): set figure(supplement: [表#h(-0.1em)])
  show figure.where(kind: image): set figure(supplement: [図#h(-0.1em)])

  // 章タイトル
  set heading(numbering: numbly(
    "{1} ",
    "{2}.",
    "{3})"
  ))

  show heading: it => {
    set text(font: titleFonts)
    let levels = counter(heading).get()
    if it.level == 1 {
      text(size: 0.95em)[#it]
    }
    else if it.level == 2 {
      v(-0.35em)
      text(size: 0.95em)[#it]
    }
    else {
      v(-0.35em)
      it
    }
  }

  // 番号カウント

  show ref: it => {
    let eq = math.equation
    let el = it.element

    if el != none and el.func() == heading {   // 章番号
      let sec-cnt = counter(heading).at(el.location())
      if el.depth == 1 {
        link(el.location(), [#sec-cnt.at(0)章#h(-0.24em)])
      } else if el.depth == 2{
        link(el.location(), [#sec-cnt.at(0).#sec-cnt.at(1)節#h(-0.24em)])
      } else if el.depth == 3{
        link(el.location(), [#sec-cnt.at(0).#sec-cnt.at(1).#sec-cnt.at(2)項#h(-0.24em)])
      }
    } else {
      it
    }
  }

  // タイトル
  if titleDisplay {
    show: columns.with(1)
    set text(size: 1.8em, font: titleFonts, weight: 600)
    set align(center)
    title
    set text(size: 0.5em, weight: 500)
    set align(right)
    id
    author
    h(1em)
    date.display("[year]年[month]月[day]日作成")
    v(1.5em)
  }

  show: columns.with(colnum)
  body
}


// 図表共通
#let withid(cap, content, id: none) = [
  #set text(font: "UDEV Gothic 35HSJPDOC", size: 0.9em)

  #align(center)[#figure(caption: cap, content)#label(
    if id == none {
      cap
    } else {
      id
    }
  )]
]

// テーブルブロック
#let tbl(cap, content, id: none, typeB: false) = [
  #show strong: set text(font: "UDEV Gothic 35HSJPDOC", size: 0.9em, weight: "bold")

  #set table(
    stroke: 1pt,
    inset: 0.5em,
    fill: (x, y) =>
      if y == 0 or (x == 0 and not typeB) {
        gray.lighten(50%)
      }
  )

  #show table.cell: it => {
    if it.y == 0 or (it.x == 0 and typeB) {
      align(center)[*#it*]
    } else {
      it
    }
  }

  #withid(cap, content, id: id)
]

#show: use-bib-item-ref.with(numbering: "[1]")
