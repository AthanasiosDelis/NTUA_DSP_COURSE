#!/usr/bin/env python
from __future__ import division 
import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal
zfile=np.load("/home/thanasis-linux/DSP20_LAB2/step_00.npz")
	


plt.title('acc')

fig, (ax1,ax2) = plt.subplots(nrows=2,ncols=1)
ax1.grid(True)
ax2.grid(True)
#ax3.grid(True)
ax1.set_ylabel("dimension x-accelarometer",rotation=80)
ax2.set_ylabel("dimension x-gyrospope",rotation=80)
#ax3.set_ylabel("$STE-x-accelerometer$",rotation=80)

xacc=np.zeros(len(zfile['acc']))
xgyr=np.zeros(len(zfile['gyr']))
hrm=np.zeros(len(zfile['hrm']))

w=len(zfile['acc'])
for i in range(w):
	xacc[i]=zfile['acc'][i][0]
xgyr=zfile['gyr'][:][0]
print(xacc.shape)

fs = 20
N = 400
h = np.hamming(N)
print(len(xacc),h.shape)
sampsPerSec = fs
SecPerFrame = 20
sampsPerFrame = sampsPerSec * SecPerFrame
nFrames = int(len(xacc) / sampsPerFrame)
print 'samples/second  ==> ', sampsPerSec
print 'samples/[%ds]frame  ==> ' % SecPerFrame, sampsPerFrame
print 'number of frames     ==> ', nFrames
STEs = []                                      # list of short-time energies
for k in range(nFrames):
    startIdx = k * sampsPerFrame
    stopIdx = startIdx + sampsPerFrame
    window = np.zeros(xacc.shape)
    window[startIdx:stopIdx] = h
    STE = sum(np.abs((xacc ** 2)) * (window**2))
    STEs.append(STE)
#print(STEs)

f1,t1,x1s = signal.stft(xacc,fs = 20.0,nperseg=2000,noverlap = 1000)
plt.xlabel('Time (sec)')
plt.ylabel('Frequency(Hz)')
plt.title('STFT of xacc')
ax2=plt.pcolormesh(t1,f1,np.abs(x1s))
x=np.arange(0,len(xacc),600)
ax1.plot(x,xacc)

plt.savefig(zfile.files[0] + "_1_2_.png" , bbox_inches="tight")


