#import "@preview/rubber-article:0.5.0": *
#import "@preview/zh-kit:0.1.0": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/wrap-it:0.1.1": *
#import "@preview/cetz:0.4.2"

#show <small-code>: set text(size: 0.75em)
#show <small-code>: set par(first-line-indent: 0em, justify: false)

#show: article.with(
  page-paper: "a4",
  //heading-numbering: none,
)
#set page(margin: 2cm)

#show: article => setup-base-fonts(
  article,
  //   first-line-indent: 0em,
  cjk-serif-family: ("SongTi SC", "SimSun"),
  cjk-sans-family: ("Heiti SC", "SimHei"),
  latin-serif-family: ("Times New Roman",),
  latin-sans-family: ("Arial",),
)

#set heading(numbering: numbly(
  "{1: 一}、",
  "{2: 1}.",
  "{3: a}.",
  "{4:i}.",
))

#set math.equation(numbering: "(1)")

#let three-line-table(it) = {
  if it.children.any(c => c.func() == table.hline) {
    return it
  }

  let meta = it.fields()
  meta.stroke = none
  meta.remove("children")

  let header = it.children.find(c => c.func() == table.header)
  let cells = it.children.filter(c => c.func() == table.cell)

  if header == none {
    let columns = meta.columns.len()
    header = table.header(..cells.slice(0, columns))
    cells = cells.slice(columns)
  }

  return table(
    ..meta,
    table.hline(stroke: 1pt),
    header,
    table.hline(stroke: 0.5pt),
    ..cells,
    table.hline(stroke: 1pt),
  )
}

#maketitle(
  authors: ("11324116 李柃锋",),
  title: "数据结构与算法 第一次作业",
  date: datetime.today().display("[year] 年 [month] 月 [day] 日"),
  spacing: (above: 0pt, below: 0pt),
)

#columns(2)[
  = 问题描述

  给定一个长度为 $n$ 的数组和一个整数 $r$，要求随机选取 $r$ 个元素并返回。

  = 基于随机索引的实现
  == 算法步骤
  + 创建一个空的结果数组 `pickedNumbers`。
  + 重复 $r$ 次：
    - 从原数组中随机选取一个元素，加入 `pickedNumbers`。
    - 从原数组中删除该元素，以避免重复选取。
  + 返回 `pickedNumbers`。

  == 复杂度分析

  - *时间复杂度*：每次选取一个元素需要 $O(1)$ 的时间，但删除元素需要 $O(n)$ 的时间，因此总的时间复杂度为 $O(r times n)$。
  - *空间复杂度*：需要一个额外的数组来存储选取的元素，空间复杂度为 $O(r)$。

  = 改进方案：Fisher-Yates 洗牌算法

  为了提高效率，可以使用 Fisher-Yates 洗牌算法来随机打乱原数组，然后直接取前 $r$ 个元素作为结果。

  == 算法步骤
  + 从后向前遍历数组`numbers`，对于每个元素`numbers[i]`：
    - 生成一个随机索引 $j$，范围在 $[0, i]$。
    - 交换当前元素与索引 $j$ 处的元素。
  + 返回打乱后的数组的前 $r$ 个元素。

  == 复杂度分析
  - *时间复杂度*：每个元素被访问一次，时间复杂度为 $O(n)$。
  - *空间复杂度*：只需要常数级别的额外空间，空间复杂度为 $O(1)$。

  = 代码实现
  #raw(read("solution.cpp"), lang: "cpp") <small-code>

  = 运行结果
  ```sh
  Parameters: totalNumbers = 10000, pickCount = 5000
  --- Benchmark Results (1000 iterations) ---
  pickRandom: 1322577667ns
  pickRandomFisherYates: 185215917ns
  Speedup: 7.14073x
  ```
]
