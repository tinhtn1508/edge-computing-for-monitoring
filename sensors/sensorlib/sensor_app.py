from typing import Any
from .signal_generator import (
    WaveConfig,
    NoiseConfig,
)
from .sensor_simualtor import (
    SignalType,
    Sensor,
)
from .rabbitmq_connector import (
    MessageType,
    RMQConfig,
    SimpleRMQTopicConnection,
)
from flask import (
    Flask,
    abort,
)
from flask_script import Manager, Server
from flask_restful import Api, Resource, reqparse, fields, marshal

sensorConfigType = {
    'sensorType': str,
    'cycle': float,
    'noiseMean': float,
    'noiseStd': float,
    'waveMagnitude': float,
    'wavePoint': int
}

sensorConfigFields = {
    'sensorType': fields.String,
    'cycle': fields.Float,
    'noiseMean': fields.Float,
    'noiseStd': fields.Float,
    'waveMagnitude': fields.Float,
    'wavePoint': fields.Integer
}

DEFAULT_SENSOR_CONFIG: sensorConfigType = {
    'sensorType': 'StaticWave',
    'cycle': 10.0,
    'noiseMean': 0.0,
    'noiseStd': 0.3,
    'waveMagnitude': 10.0,
    'wavePoint': 20    
}

sensorConfig: sensorConfigType = DEFAULT_SENSOR_CONFIG

class CustomServer(Server):
    def __call__(self, app, *args, **kwargs):
        sensorApp.startSensor()
        sensorApp.sensorIsStart = True
        return Server.__call__(self, app, *args, **kwargs)

class SensorConfigAPI(Resource):
    def __init__(self):
        self.reqparse = reqparse.RequestParser()
        self.reqparse.add_argument('sensorType', type=str, required=True, location='json')
        self.reqparse.add_argument('cycle', type=float, required=True, location='json')
        self.reqparse.add_argument('noiseMean', type=float, required=True, location='json')
        self.reqparse.add_argument('noiseStd', type=float, required=True, location='json')
        self.reqparse.add_argument('waveMagnitude', type=float, required=True, location='json')
        self.reqparse.add_argument('wavePoint', type=int, required=True, location='json')
        super(SensorConfigAPI, self).__init__()

    def get(self):
        return marshal(sensorApp.sensorConfig, sensorConfigFields)

    def put(self):
        args = self.reqparse.parse_args()
        for key, val in args.items():
            sensorConfig[key] = val

        sensorApp.updateConfigSensor(sensorConfig)

        return marshal(sensorConfig, sensorConfigFields)
            

class SensorApplication:
    def __init__(self, sensorConfig: sensorConfigType):
        self.__connector: SimpleRMQTopicConnection = SimpleRMQTopicConnection(RMQConfig(
            "rabbitmq3",
            5672,
            "measurment",
            "measurement.sensors.sensor1",
            MessageType.JSON,
        )) 

        self.__sensorConfig:  sensorConfigType = sensorConfig
        self.__sensor: Sensor = Sensor(SensorApplication.signalTypeConfig(self.__sensorConfig['sensorType']), self.__sensorConfig['cycle']).\
                                    noise(NoiseConfig(self.__sensorConfig['noiseMean'], self.__sensorConfig['noiseStd'])).\
                                    wave(WaveConfig(self.__sensorConfig['waveMagnitude'], self.__sensorConfig['wavePoint'])).\
                                    callTo(lambda x: print(x)).\
                                    initialize()
        self.__sensorIsStart: bool = False
        self.flaskApp: Flask = Flask(__name__, static_url_path="")
        self.flaskApi: Api = Api(self.flaskApp)
        self.serverManager: Manager = Manager(self.flaskApp)

    def run(self):
        self.flaskApi.add_resource(SensorConfigAPI, '/api/v1/sensorconfig', endpoint='sensorconfig')
        self.serverManager.add_command('runserver', CustomServer())
        self.serverManager.run()

    @property
    def sensor(self) -> Sensor:
        return self.__sensor

    @sensor.setter
    def sensor(self, sensor: Sensor) -> None:
        self.__sensor = sensor

    @property
    def sensorConfig(self) -> sensorConfig:
        return self.__sensorConfig

    @sensorConfig.setter
    def sensorConfig(self, cfg: sensorConfig) -> None:
        self.__sensorConfig = cfg

    @property
    def sensorIsStart(self) -> bool:
        return self.__sensorIsStart

    @sensorIsStart.setter
    def sensorIsStart(self, isStart: bool) -> None:
        self.__sensorIsStart = isStart
    
    def startSensor(self) -> None:
        self.sensor.start()
        self.sensorIsStart = True

    def stopSensor(self) -> None:
        self.sensor.stop()
        self.sensorIsStart = False

    def updateConfigSensor(self, config: sensorConfigType) -> None:
        if self.sensorIsStart:
            self.stopSensor()

        self.sensorConfig = config
        self.sensor = Sensor(SensorApplication.signalTypeConfig(self.__sensorConfig['sensorType']), self.__sensorConfig['cycle']).\
                                    noise(NoiseConfig(self.__sensorConfig['noiseMean'], self.__sensorConfig['noiseStd'])).\
                                    wave(WaveConfig(self.__sensorConfig['waveMagnitude'], self.__sensorConfig['wavePoint'])).\
                                    callTo(lambda x: self.__connector.send(x)).\
                                    initialize()
        self.startSensor()

    @classmethod
    def app(cls) -> Any:
        return cls(DEFAULT_SENSOR_CONFIG)
    
    @staticmethod
    def signalTypeConfig(typeStr: str) -> SignalType:
        if typeStr == 'SineWave':
            return SignalType.SINEWAVE
        elif typeStr == 'StaticWave':
            return SignalType.STATICWAVE
        elif typeStr == 'SquareWave':
            return SignalType.SQUAREWAVE

sensorApp = SensorApplication.app()



        
        




    


    
