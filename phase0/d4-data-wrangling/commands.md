date,amount,currency
2026-11-01,12.50,SGD
2026-11-02,8.00,USD
2026-11-03,100.00,SGD
2026-11-04,2.50,CNY
2026-11-05,8.00,USD
2026-11-06,20.00,SGD
# D4：Vim 与数据整理

## 1. Vim 生存操作

- `i`：进入 Insert 模式，开始输入。
- `Esc`：返回 Normal 模式。
- `:wq`：保存并退出。
- `:q!`：放弃修改并退出。

验收结果：

- `vim-practice.txt` 已保存 Normal、Insert、Command 三行内容。
- 后来添加的 `DELETE ME` 已通过 `:q!` 放弃，没有写入文件。

## 2. 统计每种币种的交易笔数

```bash
cut -d',' -f3 transactions.csv | tail -n +2 | sort | uniq -c
```

真实输出：

```text
      1 CNY
      3 SGD
      2 USD
```

管道含义：取币种列 → 去掉表头 → 排序 → 统计相邻重复行。

## 3. 统计币种数量

```bash
cut -d',' -f3 transactions.csv | tail -n +2 | sort -u | wc -l
```

真实输出：

```text
3
```

`sort -u` 会去重，因此 `wc -l` 统计的是三种币种，不是六笔交易。

## 4. 找出金额最高的三笔交易

```bash
cut -d',' -f2 transactions.csv | tail -n +2 | sort -nr | head -3
```

真实输出：

```text
100.00
20.00
12.50
```

`-n` 表示数值排序，`-r` 表示降序，`head -3` 只保留前三行。

## 5. 筛选 USD 交易并取金额

```bash
grep 'USD' transactions.csv | cut -d',' -f2
```

真实输出：

```text
8.00
8.00
```

先用 `grep` 筛出完整记录，再用 `cut` 取金额列。

## 6. 两条排雷说明

1. `uniq` 只处理相邻的重复行，所以统计重复项之前通常要先 `sort`。
2. `sort` 默认使用字典序；金额等数值排序要使用 `sort -n`，否则 Top 3 可能错误。

## 7. 本次报错定位

- `No such file or directory`：当时位于仓库根目录，而 CSV 在 D4 子目录中；进入正确目录后解决，文件并未丢失。
- `tail: unexpected argument '-d'`：命令被重复粘贴，导致 `tail` 收到多余参数；清理后重新输入即可。
