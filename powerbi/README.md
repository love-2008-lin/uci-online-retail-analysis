# Power BI Desktop 使用说明

打开 [October_2011_Visual.pbip](October_2011_Visual.pbip)。可先在 [经营复盘](../reports/2011年10月经营复盘.md) 中查看分析结果。 [市场页截图](../reports/figures/October_2011_Visual_01.png) · [商品页截图](../reports/figures/October_2011_Visual_02.png)

## 项目配套文件

项目入口和 [Report](October_2011_Visual.Report/) 与 [SemanticModel](October_2011_Visual.SemanticModel/) 保持同层。入口指向 Report，[报表定义](October_2011_Visual.Report/definition.pbir) 通过相对路径引用语义模型。 [商品模型表定义](October_2011_Visual.SemanticModel/definition/tables/10月产品交易细节.tmdl)

报表含「10月市场经营复盘」「10月产品交易分析」及隐藏的「产品编码详情」Tooltip 页面。商品金额图和发票覆盖表分别按 SQL 名次 1–10 筛选。

## 刷新与核验

1. 在目标机器确认 Power BI Desktop 的具体版本支持 PBIP，并安装 Oracle MySQL Connector/NET。本机检测到 Connector/NET 26.10.0，目标机器所用版本及兼容性需确认。 [Microsoft MySQL 连接器说明](https://learn.microsoft.com/en-us/power-query/connectors/mysql-database)
2. 按 [README 的复现步骤](../README.md#从原始-excel-复现) 准备 MySQL 中的 `lavel2`、`lavel2_country` 和 `product`。没有本地数据缓存时，首次打开 PBIP 只加载定义。
3. 在 Desktop 的数据源设置中为 `localhost:3306` 的 `data_10month` 提供具有查询权限的本机凭据，再刷新。连接使用的是 Power BI 保存的本地凭据设置。
4. 对照 [每日汇总](../data/outputs/October_day_retail.csv)、[市场汇总](../data/outputs/data10_country.csv)、[金额 Top 10](../reports/商品排名与对账/普通商品_金额Top10.csv) 和 [发票覆盖 Top 10](../reports/商品排名与对账/普通商品_发票覆盖Top10.csv)，并检查产品详情 Tooltip 的显示。

已用现版截图核对两张页面的展示，并从项目文件核对配套路径、连接来源和商品排名筛选。Desktop 重新连接后的数据刷新与悬浮显示待核验。
