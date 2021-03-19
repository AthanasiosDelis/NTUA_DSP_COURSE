#!/usr/bin/env python
from __future__ import division 
import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal
import pywt
import statistics
zfile=np.load("/home/thanasis-linux/DSP20_LAB2/step_00.npz")

def mean(sig):
	l=statistics.mean(sig)
	return l
def std(sig):
	l=np.std(sig)
	return l


xacc=np.zeros(len(zfile['acc']))

w=len(zfile['acc'])
for i in range(w):
	xacc[i]=zfile['acc'][i][0]
type(xacc)
array14=np.array([mean(xacc),min(xacc),max(xacc),std(xacc)])
print("Mean Min Max Standar deviation: \n" , array14)
signal=xacc
sp2.specgram(signal)
sp2.set_title('Spectogram')
sp2.set_xlabel('TIME\n(b)')
nSecs = len(signal) / fs
ticksPerSec = 3
nTicks = nSecs * ticksPerSec + 1                # add 1 to include time=0
xTickMax = sp2.get_xticks()[-1]
sp2.set_xticks(linspace(0, xTickMax, nTicks))
sp2.set_xticklabels([round(x, 2) for x in linspace(0, nSecs, nTicks)])
sp2.set_ylabel('FREQ')
maxFreq = fs / 2
nTicks = maxFreq / 1000 + 1                     # add 1 to include freq=0
sp2.set_yticks(linspace(0, 1, nTicks))
sp2.set_yticklabels(linspace(0, maxFreq, nTicks));
sp2.autoscale(tight='both')


plt.savefig(zfile.files[0] +"test14"+ ".png" , bbox_inches="tight")
