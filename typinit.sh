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

#show: pageSettings.with(title: [], author: "", titleDisplay: true, date: datetime(year: 2025, month: , day: ), id: "")

#tbl("説明", table(
  columns: 3,
  [], [], [],
))
EOF
