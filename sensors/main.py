import sensorlib
import time

def main():
    connector: sensorlib.SimpleRMQTopicConnection = sensorlib.SimpleRMQTopicConnection(sensorlib.RMQConfig(
        "localhost",
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
    time.sleep(60)
    sensor.stop()

if __name__ == "__main__":
    main()
