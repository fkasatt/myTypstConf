#let arab2rom(charNum: 0, charKind: true) = {
  let num
  let romNum
  let arabNum = (50, 40, 10, 9, 5, 4, 1)
  if charKind {
    romNum = ("L", "XL", "X", "IX", "V", "IV", "I")
  } else {
    romNum = ("l", "xl", "x", "ix", "v", "iv", "i")
  }

  for i in range(0, 7) {
    while charNum >= arabNum.at(i) {
      num = num + romNum.at(i)
      charNum = charNum - arabNum.at(i)
    }
  }

  return num
}

#let convertNum(charNum: 0, charKind: "EN") = {
  if charKind == "EN" {
    return str.from-unicode(64 + charNum)
  } else if charKind == "en" {
    return str.from-unicode(96 + charNum)
  } else if charKind == "RM" {
    return arab2rom(charNum: charNum)
  } else if charKind == "rm" {
    return arab2rom(charNum: charNum, charKind: false)
  } else {
    return charNum
  }
}
