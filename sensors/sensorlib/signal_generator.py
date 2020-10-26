from dataclasses import dataclass
from typing import Generator, List, Any
import numpy as np

@dataclass
class WaveConfig(object):
    magnitude: float
    points: int

@dataclass
class NoiseConfig(object):
    mean: float
    std: float

class BaseGenerator(object):
    def __init__(self) -> None:
        self._wave: WaveConfig = WaveConfig(1, 60)
        self._noise: NoiseConfig = NoiseConfig(0, 1)

    def noise(self, noise: NoiseConfig) -> Any:
        self._noise = noise
        return self

    def wave(self, wave: WaveConfig) -> Any:
        self._wave = wave
        return self

    def getCycle(self) -> List[float]:
        raise NotImplementedError

    def generate(self) -> Generator[float, None, None]:
        for sample in self.getCycle():
            yield sample

class StaticWaveGenerator(BaseGenerator):
    def getCycle(self) -> List[float]:
        points: int = self._wave.points
        samples: np.array = np.zeros(points) + self._wave.magnitude
        return list(samples + np.random.normal(self._noise.mean, self._noise.std, size = points))

class SineWaveGenerator(BaseGenerator):
    def getCycle(self) -> List[float]:
        points: int = self._wave.points
        x: np.array = np.linspace(-np.pi, np.pi, points)
        samples: np.array = np.sin(x) * self._wave.magnitude
        return list(samples + np.random.normal(self._noise.mean, self._noise.std, size = points))

class SquareWaveGenerator(BaseGenerator):
    def getCycle(self) -> List[float]:
        points: int = self._wave.points
        halfpoints: int = points // 2
        zerosSamples: np.array = np.zeros(halfpoints)
        onesSamples: np.array = np.ones(points - halfpoints) * self._wave.magnitude
        samples: np.array = np.hstack((zerosSamples, onesSamples))
        return list(samples + np.random.normal(self._noise.mean, self._noise.std, size = points))
