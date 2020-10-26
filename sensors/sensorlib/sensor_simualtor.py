from enum import Enum
from typing import Callable, Any, Generator
import threading
from .signal_generator import (
    WaveConfig,
    NoiseConfig,
    BaseGenerator,
    StaticWaveGenerator,
    SineWaveGenerator,
    SquareWaveGenerator,
)

class SignalType(Enum):
    STATICWAVE = 1
    SINEWAVE = 2
    SQUAREWAVE = 3

class Sensor(object):
    def __init__(self, stype: SignalType, cycle: float):
        self._generator: BaseGenerator = None
        self._stype: SignalType = stype
        self._cycle: float = cycle
        self._wave: WaveConfig = None
        self._noise: NoiseConfig = None
        self._thread: threading.Timer = None
        self._callback: Callable[[float], None] = None

    def noise(self, noise: NoiseConfig) -> Any:
        self._noise = noise
        return self

    def wave(self, wave: WaveConfig) -> Any:
        self._wave = wave
        return self

    def callTo(self, f: Callable[[float], None]) -> Any:
        self._callback = f
        return self

    def initialize(self) -> Any:
        if self._wave is None or self._noise is None:
            raise Exception("You should let me know the spec of wave first!")

        if self._stype == SignalType.STATICWAVE:
            self._generator = StaticWaveGenerator().wave(self._wave).noise(self._noise)
        elif self._stype == SignalType.SINEWAVE:
            self._generator = SineWaveGenerator().wave(self._wave).noise(self._noise)
        elif self._stype == SignalType.SQUAREWAVE:
            self._generator = SquareWaveGenerator().wave(self._wave).noise(self._noise)

        if self._generator is None:
            raise Exception(f"Invalid signal type: {self._stype}")
        return self

    def _onSampling(self, persampleInterval: float, cycleGenerator: Generator[float, None, None]) -> None:
        try:
            self._callback(next(cycleGenerator))
        except StopIteration:
            cycleGenerator = self._generator.generate()
            self._callback(next(cycleGenerator))
        except Exception as e:
            raise e
        self._thread = threading.Timer(persampleInterval, self._onSampling, [persampleInterval, cycleGenerator])
        self._thread.start()

    def start(self) -> None:
        points: int = self._wave.points
        persampleInterval: float = self._cycle/points
        cycleGenerator: Generator[float, None, None] = self._generator.generate()
        self._thread = threading.Timer(persampleInterval, self._onSampling, [persampleInterval, cycleGenerator])
        self._thread.start()

    def stop(self) -> None:
        self._thread.cancel()
        self._thread.join()
