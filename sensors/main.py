import os
import sensorlib
import time

def main():
    hostName: str = os.environ.get('HOSTNAME')
    port: int = int(os.environ.get('PORT'))
    topic: str = os.environ.get('TOPIC')
    connector: sensorlib.SimpleRMQTopicConnection = sensorlib.SimpleRMQTopicConnection(sensorlib.RMQConfig(
        "rabbitmq3",
        5672,
        "measurment",
        "measurement.sensors.sensor1",
        sensorlib.MessageType.TEXT,
    ))
    sensor: sensorlib.Sensor = sensorlib.Sensor(sensorlib.SignalType.SINEWAVE, 10).\
        noise(sensorlib.NoiseConfig(0, 0.3)).\
        wave(sensorlib.WaveConfig(10, 30)).\
        callTo(lambda x: connector.send(x)).\
        initialize()
    sensor.start()
    while True:
        time.sleep(60)
    sensor.stop()

if __name__ == "__main__":
    main()
