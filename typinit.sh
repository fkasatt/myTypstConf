#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <dir name>"
  exit 1
fi

path="$1"
mkdir -p "$path"
cd "$path"
mkdir -p "figs/"
mkdir -p "src/"
cp $HOME/typst/miniConf.typ src/

cat > main.typ << EOF
#import "@local/conf:0.1.0": *
#import "src/miniConf.typ": *

#show: pageSettings.with(title: [], author: "", titleDisplay: true, date: datetime(year: 2025, month: , day: ), id: "")


EOF

cat > src/template.typ << EOF
#import "@local/conf:0.1.0": *
#import "src/miniConf.typ": *
#import "@local/frame-it:1.1.1": *

/*
  title: [], author: "", id: "", date: datetime.today(), titleDisplay: false, textFonts: mincho, fontSize: 9pt, colnum: 2, pageMargin: auto,
*/

#show: pageSettings.with(title: [], author: "", titleDisplay: true, date: datetime(year: 2025, month: , day: ), id: "")

#let (def, theorem, exam, exq, ques, summary) = frames(
  def: ("定義"),
  theorem: ("定理"),
  exam: ("例"),
  exq: ("例題", gray),
  ques: ("問"),
  summary: ("まとめ")
)
#show: frame-style(styles.boxy)

#tbl([説明], table(
  columns: 3,
  [], [], [],
), type: 3)

#img([01_これは画像です], id: "hoge")

#def[title][tag1][tag2][
  文章1
  #divide()
  文章2
] <正常性の定義>

スゴイ論文[@bib1]や もっとスゴイ論文[@bib2]によると、

#bxbib[
  #bib-item(<bib1>)[某有名教授. スゴイ論文, 2024]
  #bib-item(<bib2>)[某有名教授. もっとスゴイ論文, 2024]
]
EOF
