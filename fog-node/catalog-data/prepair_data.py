import csv
import psycopg2
import yaml
from loguru import logger as log
from typing import (
    Dict,
    Any,
)

configFile = "./config.yaml"

def getConfig(path: str) -> Dict[str, Any]:
    log.info(f"loading config file from {path}")
    config: Dict[str, Any] = dict()
    with open(path) as fd:
        config = yaml.load(fd, Loader = yaml.FullLoader)
    return config

def initPsql(psqlConfig: Dict[str, Any]) -> Any:
    connection = psycopg2.connect (
        host = psqlConfig["host"],
        port = str(psqlConfig["port"]),
        user = psqlConfig["username"],
        password = psqlConfig["password"],
        database = psqlConfig["dbname"],
    )

    with open(psqlConfig["init_schema"]) as fd:
        schema: str = fd.read()
        log.info(f"apply schema: {schema}")
        connection.cursor().execute(schema)
    connection.commit()
    return connection

def buildTable(path: str, table: str, connection: Any) -> None:
    with open(path) as fd:
        records: Any = csv.reader(fd)
        next(records)
        for row in records:
            cols: int = len(row)
            placeholders: str = ",".join(["%s"] * cols)
            query: str = f"insert into {table} values ({placeholders});"
            cursor: Any = connection.cursor()
            cursor.execute(query, row)
        connection.commit()

def main() -> None:
    config: Dict[str, Any] = getConfig(configFile)
    log.info(f"config: {config}")
    tables: Dict[str, str] = config["tables"]
    psql: Dict[str, Any] = config["psql"]
    connection = initPsql(psql)
    for table, path in tables.items():
        buildTable(path, table, connection)
    connection.close()

if __name__ == "__main__":
    main()
