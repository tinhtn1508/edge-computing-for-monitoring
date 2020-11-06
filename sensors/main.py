import sensorlib
import time

def main() -> None:
    appConfig: AppConfig = sensorlib.GetAppConfig().getSensorConfig()
    app = sensorlib.SensorApplication(appConfig)
    app.run()

if __name__ == "__main__":
    main()
