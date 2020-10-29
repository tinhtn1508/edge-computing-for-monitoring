import sensorlib
import time

def main():
    app = sensorlib.SensorApplication(sensorlib.DEFAULT_SENSOR_CONFIG, './../configs/edge-sensor.yaml')
    app.run()

if __name__ == "__main__":
    main()
