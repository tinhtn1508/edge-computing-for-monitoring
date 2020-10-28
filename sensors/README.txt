# Sensor services

## Api

### Get current sensor config

```
curl --location --request GET 'http://127.0.0.1:5000/api/v1/sensorconfig' --data-raw ''
```

### Change sensor config 

```
curl --location --request PUT 'http://127.0.0.1:5000/api/v1/sensorconfig' \
--header 'Content-Type: application/json' \
--data-raw '{
    "sensorType": "SquareWave",
    "cycle": 10.0
    "noiseMean": 0.0,
    "noiseStd": 0.3,
    "waveMagnitude": 5.0,
    "wavePoint": 20.0
}'
```

