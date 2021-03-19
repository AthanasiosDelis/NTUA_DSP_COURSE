#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

zfile=np.load("/home/thanasis-linux/DSP20_LAB2/step_00.npz")
	


plt.title('acc')

fig, (ax1,ax2,ax3) = plt.subplots(nrows=3,ncols=1)
ax1.grid(True)
ax2.grid(True)
ax3.grid(True)
ax1.set_ylabel("dimension x-accelarometer",rotation=80)
ax2.set_ylabel("dimension y-accelarometer",rotation=80)
ax3.set_ylabel("dimension z-accelarometer",rotation=80)



xacc=np.zeros(len(zfile['acc']))
yacc=np.zeros(len(zfile['acc']))
zacc=np.zeros(len(zfile['acc']))

w=len(zfile['acc'])
for i in range(w):
	xacc[i]=zfile['acc'][i][0]
	yacc[i]=zfile['acc'][i][1]
	zacc[i]=zfile['acc'][i][2]


ax1.set_title("Accelarometer Data")
ax1.plot(xacc,label='xacc',color='green')
ax2.plot(yacc,label='yacc',color='blue')
ax3.plot(zacc,label='zacc',color='red')
plt.tight_layout()
plt.savefig(zfile.files[0] + ".png" , bbox_inches="tight")


plt.title("Accelarometer Data")
plt.ylabel("dimension x-accelarometer",rotation=90)
plt.plot(xacc,label='xacc',color='green')
plt.savefig(zfile.files[0]+ "dimension x-accelarometer" + ".png" , bbox_inches="tight")

plt.clf()
plt.title("Accelarometer Data")
plt.ylabel("dimension y-accelarometer",rotation=90)
plt.plot(yacc,label='yacc',color='blue')
plt.savefig(zfile.files[0]+"dimension y-accelarometer" + ".png" , bbox_inches="tight")

plt.clf()
plt.title("Accelarometer Data")
plt.ylabel("dimension z-accelarometer",rotation=90)
plt.plot(zacc,label='zacc',color='red')

plt.savefig(zfile.files[0] +"dimension z-accelarometer"+ ".png" , bbox_inches="tight")

fig1, (ax4,ax5,ax6) = plt.subplots(nrows=3,ncols=1)
ax4.grid(True)
ax5.grid(True)
ax6.grid(True)
ax4.set_ylabel("dimension x-gyroscope",rotation=80)
ax5.set_ylabel("dimension y-gyroscope",rotation=80)
ax6.set_ylabel("dimension z-gyroscope",rotation=80)
xgyr=np.zeros(len(zfile['gyr']))
ygyr=np.zeros(len(zfile['gyr']))
zgyr=np.zeros(len(zfile['gyr']))
hrm=np.zeros(len(zfile['hrm']))

e=len(zfile['gyr'])
for i in range(e):
	xgyr[i]=zfile['gyr'][i][0]
	ygyr[i]=zfile['gyr'][i][1]
	zgyr[i]=zfile['gyr'][i][2]
s=len(zfile['hrm'])
for i in range(s):
	hrm[i]=zfile['hrm'][i]


ax4.set_title("Gyroscope Data")
ax4.plot(xgyr,label='xgyr',color='green')
ax5.plot(ygyr,label='ygyr',color='blue')
ax6.plot(zgyr,label='zgyr',color='red')
plt.tight_layout()
plt.savefig(zfile.files[1] + ".png" , bbox_inches="tight")

plt.clf()
plt.title("Gyroscope  Data")
plt.ylabel("dimension x-gyroscope",rotation=90)
plt.plot(xgyr,label='xgyr',color='green')
plt.savefig(zfile.files[1]+"dimension x-gyroscope" + ".png" , bbox_inches="tight")

plt.clf()
plt.title("Gyroscope Data")
plt.ylabel("dimension y-gyroscope",rotation=90)
plt.plot(ygyr,label='ygyr',color='blue')
plt.savefig(zfile.files[1]+"dimension y-gyroscope" + ".png" , bbox_inches="tight")

plt.clf()
plt.title("Gyroscope Data")
plt.ylabel("dimension z-gyroscope",rotation=90)
plt.plot(zgyr,label='zgyr',color='red')

plt.savefig(zfile.files[1] +"dimension z-gyroscope"+ ".png" , bbox_inches="tight")

plt.clf()
plt.title("Heartbeat Data")
plt.ylabel("hrm",rotation=90)
plt.plot(hrm,label='hrm',color='red')

plt.savefig(zfile.files[2] + ".png" , bbox_inches="tight")
