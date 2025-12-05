import duckdb
import os
import psutil

def export_table_chunked(conn, table_name, output_dir, chunk_size=20000000):
    """Экспортирует таблицу частями для экономии памяти"""
    
    # Получаем общее количество строк
    total_rows = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
    print(f"Таблица {table_name}: {total_rows:,} строк")
    
    # Экспортируем частями
    for offset in range(0, total_rows, chunk_size):
        output_file = f"{output_dir}/{table_name}_part{offset//chunk_size + 1}.parquet"
        
        print(f"  Экспорт строк {offset:,}-{offset+chunk_size:,} -> {output_file}")
        
        query = f"""
            COPY (
                SELECT * FROM {table_name} 
                --ORDER BY 1 
                LIMIT {chunk_size} OFFSET {offset}
            ) TO '{output_file}' (FORMAT PARQUET)
        """
        
        conn.execute(query)
        
        # Проверяем использование памяти
        memory_usage = psutil.virtual_memory().percent
        print(f"    Использование памяти: {memory_usage}%")

def export_small_tables(conn, output_dir):
    """Экспортирует маленькие таблицы целиком"""
    small_tables = [
        'call_center', 'catalog_page', 'date_dim', 'time_dim', 'reason',
        'ship_mode', 'income_band', 'warehouse', 'promotion', 'web_page',
        'web_site', 'store', 'household_demographics', 'customer_demographics'
    ]
    
    for table in small_tables:
        print(f"Экспорт {table}...")
        conn.execute(f"COPY {table} TO '{output_dir}/{table}.parquet' (FORMAT PARQUET)")

def main():
    conn = duckdb.connect('/mnt/d/lakehouse/tpcds100_benchmark.db')
    
    # Устанавливаем лимит памяти
    conn.execute("PRAGMA memory_limit='6GB'")
    
    output_dir = '/mnt/d/lakehouse/tpcds100'
    os.makedirs(output_dir, exist_ok=True)
    
    # Сначала экспортируем маленькие таблицы
    #export_small_tables(conn, output_dir)
    
    # Затем большие таблицы частями
    large_tables = [
        #'inventory', 'catalog_returns', 'store_returns', 'web_returns', 'item', 'customer_address', 'customer'
        #'catalog_sales',
	'store_sales', 'web_sales'
    ]
    
    for table in large_tables:
        print(f"\nОбработка большой таблицы: {table}")
        export_table_chunked(conn, table, output_dir, chunk_size=20000000)
    
    conn.close()
    print("Экспорт завершен!")

if __name__ == "__main__":
    main()
