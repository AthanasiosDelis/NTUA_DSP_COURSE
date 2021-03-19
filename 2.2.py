from __future__ import division
import sys
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal
import pywt
import librosa

N = 16282
n = np.arange(101)
zeros = np.zeros(8141)

x = 10*np.cos(0.24*np.pi*n + 0.2*np.pi) + 12*np.sin(0.26*np.pi*n-0.8*np.pi)

x2 = np.concatenate((zeros,x))
x2 = np.concatenate((x,zeros))

dft = np.fft.fft(x2)
dftt=np.fft.fft(x)
plt.subplot(111)
plt.plot(np.abs(dft))
plt.show()
plt.subplot(111)
plt.plot(np.abs(dftt))
plt.show()
db=20*np.log(np.abs(dft))
plt.subplot(111)
plt.plot(np.abs(db))
plt.show()


xc=np.cov(dft,dft)
print(xc)
p=librosa.core.lpc(x,3)
print(p)

x[-4]=0
x[-3]=0
x[-2]=0
x[-1]=0
sumi=0
for j in range(101):
    for i in range(4):
        sumi+=p*x[j]
    print(x[j]-sumi)

np.random.seed(1)
N = 10
b1 = np.random.rand(N)
b2 = np.random.rand(N)
X = np.column_stack([x, x])
X -= X.mean(axis=0)
fact = N - 1
by_hand = np.dot(X.T, X.conj()) / fact
print(by_hand)

import seaborn
import scipy
import pysptk

from pysptk.synthesis import AllPoleDF

lpc = pysptk.lpc(x, 4)
print(lpc)
