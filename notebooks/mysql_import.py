"""三份 MySQL 导入 Notebook 共用的写入操作。"""

from pandas import DataFrame


def write_dataframe_to_mysql(dataframe: DataFrame, table_name: str, engine) -> int | None:
    """将 dataframe 写入 engine 对应数据库的 table_name，返回写入行数或 None。"""
    return dataframe.to_sql(
        name=table_name,
        con=engine,
        if_exists="fail",
        index=False,
        chunksize=1000,
        method="multi",
    )
