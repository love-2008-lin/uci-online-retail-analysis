# 数据来源与复现文件

Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository。原始交易覆盖 2010-12-01 至 2011-12-09。项目从该数据集中选取 `[2011-10-01, 2011-11-01)`，筛选有效交易，整理商品描述并生成市场、日趋势和商品统计。附录中的客户与发票编号为数据集中的记录标识。 [UCI 数据集](https://archive.ics.uci.edu/dataset/352/online%2Bretail) · [DOI](https://doi.org/10.24432/C5BW33) · [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

## 下载与校验

1. 从 UCI 数据集页面下载 ZIP，解压得到 `Online Retail.xlsx`。
2. 将工作簿放在项目中的 `data/raw/Online Retail.xlsx`，保留原文件名和扩展名。
3. 本项目核验使用的工作簿含 541,909 行和 8 个字段，SHA-256 为 `43465a06f2ccf7c8b5bd2892bc7defb52f97487934fe93b16ae4c3936424676d`。

[UCI 下载页面](https://archive.ics.uci.edu/dataset/352/online%2Bretail)

## 本地生成文件

| 文件 | 生成位置 |
| --- | --- |
| `data/processed/data_10month.csv` | [02 交易清洗](notebooks/02_clean_october_transactions.ipynb) 的有效明细 |
| `data/processed/data_10_product.csv` | [06 商品明细与描述处理](notebooks/06_prepare_product_data.ipynb) 的商品交易明细 |
| `data/processed/data_10_product_pending.csv` | 同一 Notebook 06 的待核定商品描述明细 |
| `data/outputs/data10_country.csv` | [04 市场分析](notebooks/04_analyze_markets.ipynb) 的市场汇总，公开版附快照 |
| `data/outputs/October_day_retail.csv` | [每日汇总 SQL](sql/01_daily_and_market_summary.sql) 的结果快照 |

## 原始字段

| 字段 | 用途 |
| --- | --- |
| `InvoiceNo` | 发票编号，C 前缀用于识别取消 |
| `StockCode` | 商品编码，分析使用大小写敏感的精确键 |
| `Description` | 商品描述 |
| `Quantity` | 行项目数量 |
| `InvoiceDate` | 发票日期与时间 |
| `UnitPrice` | 单价，单位 GBP |
| `CustomerID` | 客户编号，缺失时保留可按其他条件判断有效的交易 |
| `Country` | 市场字段 |

[数据质量检查](notebooks/01_data_quality_checks.ipynb)记录了实际窗口的缺失与异常。完整复现顺序见[项目说明](README.md#从原始-excel-复现)。
