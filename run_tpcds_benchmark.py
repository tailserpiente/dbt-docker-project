import duckdb, time, datetime

DB_PATH = "/mnt/d/lakehouse/tpcds100_benchmark.db"   # путь к тому же файлу, что использует контейнер
RUN_ID = 1

con = duckdb.connect(DB_PATH)

con.execute("""
CREATE TABLE IF NOT EXISTS tpcds_benchmark_results (
    run_id        INTEGER,
    query_nr      INTEGER,
    started_at    TIMESTAMPTZ,
    finished_at   TIMESTAMPTZ,
    elapsed_ms    DOUBLE,
    row_count     BIGINT
)
""")

rows = con.execute("""
    SELECT query_nr, query
    FROM tpcds_queries()
    ORDER BY query_nr
""").fetchall()

for query_nr, sql in rows:
    started_at = datetime.datetime.now(datetime.timezone.utc)
    t0 = time.perf_counter()
    res = con.execute(sql).fetchall()
    dt_ms = (time.perf_counter() - t0) * 1000.0
    finished_at = datetime.datetime.now(datetime.timezone.utc)
    row_count = len(res)

    con.execute("""
        INSERT INTO tpcds_benchmark_results
        (run_id, query_nr, started_at, finished_at, elapsed_ms, row_count)
        VALUES (?, ?, ?, ?, ?, ?)
    """, [RUN_ID, query_nr, started_at, finished_at, dt_ms, row_count])

RUN_ID=2

for query_nr, sql in rows:
    started_at = datetime.datetime.now(datetime.timezone.utc)
    t0 = time.perf_counter()
    res = con.execute(sql).fetchall()
    dt_ms = (time.perf_counter() - t0) * 1000.0
    finished_at = datetime.datetime.now(datetime.timezone.utc)
    row_count = len(res)

    con.execute("""
        INSERT INTO tpcds_benchmark_results
        (run_id, query_nr, started_at, finished_at, elapsed_ms, row_count)
        VALUES (?, ?, ?, ?, ?, ?)
    """, [RUN_ID, query_nr, started_at, finished_at, dt_ms, row_count])

con.close()
