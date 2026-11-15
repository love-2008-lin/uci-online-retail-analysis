use data_10month;
-- 得到每日正向商品金额和订单数
# 创建日期表
WITH RECURSIVE date_series AS(
	SELECT DATE('2011-10-01') AS sale_day
	UNION ALL
	SELECT DATE_ADD(sale_day,INTERVAL 1 DAY)
	FROM date_series 
	WHERE sale_day < DATE('2011-10-31')
)

# 查询每日正向商品金额
SELECT 
	dt.sale_day ,
	IFNULL(d.gross_amount_gbp,0) AS gross_amount_gbp ,
	IFNULL(d.invoice_count,0) AS invoice_count
FROM date_series dt
LEFT JOIN (
	SELECT 
		DATE(invoicedate) AS sale_day ,
		SUM(lineamount) AS gross_amount_gbp ,
		COUNT(DISTINCT(invoiceno)) AS invoice_count
	FROM lavel2
	GROUP BY DATE(invoicedate)
) AS d
ON dt.sale_day = d.sale_day
ORDER BY dt.sale_day ASC;

-- 得到市场每日正向商品金额和订单数
SELECT * FROM lavel2_country_copy;