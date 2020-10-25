from influxdb import InfluxDBClient
from loguru import logger

class InfluxDBHelper:
    __instance = None

    @staticmethod
    def instance():
        if InfluxDBHelper.__instance is None:
            InfluxDBHelper()
        return InfluxDBHelper.__instance

    def __init__(self, host = "localhost", port = 8086, dbname = "test", user = "root", password = "root"):
        if InfluxDBHelper.__instance is not None:
            raise Exception("This class is singleton")
        else:
            self.__client = InfluxDBClient(host, port, user, password, dbname)
            logger.info("Creating database: " + dbname)
            self.__client.create_database(dbname)
            self.__client.switch_database(dbname)
            InfluxDBHelper.__instance = self

    def write(self, json_body):
        self.__client.write_points(json_body)
