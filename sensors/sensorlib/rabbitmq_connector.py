import pika
import json
from enum import Enum
from typing import Any, List
from dataclasses import dataclass
from pika.connection import Connection
from pika.channel import Channel
from loguru import logger

class MessageType(Enum):
    TEXT = 1
    JSON = 2

@dataclass
class RMQConfig(object):
    host: str
    port: int
    exchange: str
    topic: str
    queues: List[str]
    messageType: MessageType

class SimpleRMQTopicConnection(object):
    def __init__(self, config: RMQConfig):
        self._connector: Connection = pika.BlockingConnection(
            pika.ConnectionParameters(host = config.host, port = config.port)
        )
        self._channel: Channel = self._connector.channel()
        self._channel.exchange_declare(
            config.exchange, 
            exchange_type = "topic", 
            durable = True
        )
        for q in config.queues:
            self._channel.queue_declare(q, durable = True)
            self._channel.queue_bind(q, config.exchange)
        self._exchange: str = config.exchange
        self._topic: str = config.topic
        self._messageType: MessageType = config.messageType

    def __getJsonString(self, message: Any) -> str:
        return json.dumps(message)

    def send(self, message: Any):
        messStr = ""

        if self._messageType == MessageType.JSON:
            messStr = self.__getJsonString(message)
        elif self._messageType == MessageType.TEXT:
            messStr = str(message)
        try:
            self._channel.basic_publish(
                self._exchange,
                self._topic,
                messStr,
                mandatory = True,
            )
        except pika.exceptions.UnroutableError:
            logger.error("Message was returned")

    def close(self):
        if self._connector is not None:
            self._connector.close()
