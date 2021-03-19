#!/usr/bin/env python3
from __future__ import division 
import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal
#import pywt
zfile=np.load(r"C:\Users\Admin\Documents\DSD\SP20_LAB\step_00.npz")

xacc=np.zeros(len(zfile['acc']))
hrm=np.zeros(len(zfile['hrm']))

"""
w=len(zfile['acc'])
for i in range(w):
	xacc[i]=zfile['acc'][i][0]
"""
s=len(zfile['hrm'])
for i in range(s):
	hrm[i]=zfile['hrm'][i]
"""

f1,t1,x1s = signal.stft(xacc,fs = 20.0,nperseg=2000,noverlap = 1000)
plt.pcolormesh(t1,f1,np.abs(x1s))
plt.xlabel('Time (sec)')
plt.ylabel('Frequency(Hz)')
plt.title('STFT of xacc')

plt.savefig(zfile.files[0] + "_1_3_.png" , bbox_inches="tight")

plt.clf()
"""
f2,t2,x2s = signal.stft(hrm,fs = 5.0,nperseg=2000,noverlap = 1000)
print("fs:", f2 , "t2: ", t2, x2s.shape)
f=f2*1000
plt.pcolormesh(t2,f2,np.abs(x2s))
plt.xlabel('Time (sec)')
plt.ylabel('Frequency(Hz)')
plt.title('STFT of hrm')
plt.savefig(zfile.files[2] + "_1_3.png" , bbox_inches="tight")
"""
plt.clf()
fs=5
maxt=s/fs #minutes
t = np.linspace(0,maxt,s)
sc = np.power(2,np.linspace(1,6,100))
coefs,freqs = pywt.cwt(hrm,sc,'cmor3.0-1.0')
f = freqs*500
print ("freqs: ", max(freqs))
plt.contour(t,f,np.abs(coefs),15)
plt.xlabel('Time (sec)')
plt.ylabel('Frequency(Hz)')
plt.title('CWT of the signal segment')
plt.savefig(zfile.files[2] + "_1_3_.png" , bbox_inches="tight")
"""