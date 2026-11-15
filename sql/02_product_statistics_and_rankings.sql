-- A01 商品统计。连接 data_10month 后执行；Power BI 使用同一只读查询。
WITH detail AS (
    SELECT
        HEX(CAST(stockcode AS BINARY)) AS stockcode_key,
        invoiceno,
        CAST(description AS BINARY) AS description_bytes,
        lineamount,
        quantity
    FROM product
),
product_totals AS (
    SELECT
        stockcode_key,
        COUNT(*) AS detail_row_count,
        ROUND(SUM(lineamount), 2) AS gross_amount_gbp,
        COUNT(DISTINCT invoiceno) AS invoice_coverage,
        SUM(quantity) AS units
    FROM detail
    GROUP BY stockcode_key
),
description_counts AS (
    SELECT stockcode_key, description_bytes, COUNT(*) AS occurrences
    FROM detail
    WHERE description_bytes IS NOT NULL
      AND TRIM(CONVERT(description_bytes USING utf8mb4)) <> ''
    GROUP BY stockcode_key, description_bytes
),
description_choices AS (
    SELECT
        stockcode_key,
        description_bytes,
        COUNT(*) OVER (PARTITION BY stockcode_key) AS description_variants,
        ROW_NUMBER() OVER (
            PARTITION BY stockcode_key
            ORDER BY occurrences DESC, description_bytes
        ) AS choice_order
    FROM description_counts
),
-- product 已包含描述检查时采用的 44 个暂定主描述。
-- 对仍有多种描述的编码，只给出待复核标签。
display_mapping AS (
    SELECT
        p.stockcode_key,
        CONVERT(UNHEX(p.stockcode_key) USING utf8mb4) AS stockcode,
        CASE WHEN c.description_variants = 1
             THEN CONVERT(c.description_bytes USING utf8mb4)
             ELSE CONCAT('待复核 · ', CONVERT(UNHEX(p.stockcode_key) USING utf8mb4))
        END AS display_name,
        CASE WHEN c.description_variants = 1 THEN 0 ELSE 1 END AS needs_review
    FROM product_totals AS p
    LEFT JOIN description_choices AS c
        ON p.stockcode_key = c.stockcode_key AND c.choice_order = 1
),
non_retail_codes AS (
    SELECT 'M' AS stockcode, '手工项（未标明商品）' AS reason
    UNION ALL SELECT 'DOT', '邮费'
    UNION ALL SELECT 'POST', '邮费'
    UNION ALL SELECT 'C2', '运费'
    UNION ALL SELECT 'BANK CHARGES', '银行费用'
    UNION ALL SELECT 'S', '样品'
    UNION ALL SELECT 'gift_0001_20', '礼品券'
),
product_base AS (
    SELECT
        p.*,
        m.stockcode,
        m.display_name,
        m.needs_review,
        e.reason AS exclusion_reason,
        CASE WHEN COUNT(*) OVER (
            PARTITION BY m.stockcode COLLATE utf8mb4_0900_ai_ci
        ) > 1 THEN CONCAT(m.stockcode, ' [', p.stockcode_key, ']')
        ELSE m.stockcode END AS product_label
    FROM product_totals AS p
    INNER JOIN display_mapping AS m ON p.stockcode_key = m.stockcode_key
    LEFT JOIN non_retail_codes AS e
        ON p.stockcode_key = HEX(CAST(e.stockcode AS BINARY))
),
regular_ranks AS (
    SELECT
        stockcode_key,
        ROW_NUMBER() OVER (ORDER BY gross_amount_gbp DESC, stockcode_key) AS amount_rank,
        ROW_NUMBER() OVER (ORDER BY invoice_coverage DESC, stockcode_key) AS coverage_rank
    FROM product_base
    WHERE exclusion_reason IS NULL
)
SELECT
    p.stockcode_key,
    p.stockcode,
    p.product_label,
    p.display_name,
    p.needs_review,
    p.detail_row_count,
    p.gross_amount_gbp,
    p.invoice_coverage,
    p.units,
    p.exclusion_reason,
    r.amount_rank,
    r.coverage_rank
FROM product_base AS p
LEFT JOIN regular_ranks AS r ON p.stockcode_key = r.stockcode_key;
