import yaml
import os
from envyaml import EnvYAML
from dataclasses import dataclass
from typing import Any, List

from .rabbitmq_connector import (
    MessageType,
    RMQConfig,
)

@dataclass
class APIServerConfig(object):
    host: str
    port: int


@dataclass
class AppConfig(object):
    rabbitMQConfig: RMQConfig
    apiServerConfig: APIServerConfig


class GetAppConfig(object):
    def __init__(self):
        self.__config_path = os.getenv("EDGE_CONF_FILE")
        if self.__config_path is None:
            raise Exception("The config path is not correct")
        self.__config: EnvYAML = EnvYAML(self.__config_path)
        self.__rabbitMQConfig: RMQConfig = None
        self.__severConfig: APIServerConfig = None

    def _getConfigRabbitMq(self) -> RMQConfig:
        host: str = self.__config["rabbitMQ"]["host"]
        port: int = self.__config["rabbitMQ"]["port"]
        exchange: str = self.__config["rabbitMQ"]["exchange"]
        topic: str = self.__config["rabbitMQ"]["topic"]
        queues: List[str] = self.__config["rabbitMQ"]["queues"]
        messageType: str = self.__config["rabbitMQ"]["messageType"]

        if messageType == 'json':
            messageType = MessageType.JSON
        elif messageType == 'text':
            messageType = MessageType.TEXT

        return RMQConfig(host, port, exchange, topic, queues, messageType)

    def _getSeverConfig(self) -> APIServerConfig:
        host: str = self.__config["serverAPI"]["host"]
        port: int = self.__config["serverAPI"]["port"]

        return APIServerConfig(host, port)

    def getSensorConfig(self) -> AppConfig:
        self.__rabbitMQConfig = self._getConfigRabbitMq()
        self.__severConfig = self._getSeverConfig()

        return AppConfig(self.__rabbitMQConfig, self.__severConfig)
