* CMOS
***** Library *****
.prot
.inc '45nm.pm'
.unprot

***** Params *****
.param  +VDD = 1V
+GND = 0V
+Lmin = 45n
+Wp = 2
+Wn = 1

***** Temperature *****
.temp	25

***** Sources *****
*V      N+  N-  Pulse   V1  V2  TD  TR  TF  PW  PER
Vsupply	Vm	0	DC	VDD
VinA    A	0	DC	VDD
VinX    X	0	DC	VDD
*Pulse  GND  VDD 0  1p 1p 2000p 5000p

***** Component *****
X1      Vm      X       W1      inverterCmos
X2      Vm      W1      W2      inverterCmos
X3      Vm      W2      A       Y1      andCmos
X4      Vm      W1      A       Y2      andCmos

***** NAND
.SUBCKT nandCmos        VDD     A       B       out
Mp1		out	  	A   	VDD	    VDD		pmos	l='Lmin'	w='Lmin*Wp'
Mp2     out     B   	VDD     VDD   	pmos	l='Lmin'    w='Lmin*Wp'
Mn1	    2	   	B   	GND  	GND     nmos	l='Lmin'	w='Lmin*Wn'
Mn2	    out	   	A   	2  		2     	nmos	l='Lmin'	w='Lmin*Wn'
.ENDS nandCmos

***** INVERTER
.SUBCKT inverterCmos	VDD     A 		out
Mp1		out	  	A   	VDD	    VDD		pmos	l='Lmin'	w='Lmin*Wp'
Mn1	    out	   	A   	GND  	GND     nmos	l='Lmin'	w='Lmin*Wn'
.ENDS inverterCmos

***** AND
.SUBCKT andCmos    VDD     A       B       out
Xnand      VDD     A       B       wire     nandCmos
Xinverter  VDD     wire    out     inverterCmos
.ENDS andCmos

***** Type of Analysis *****
***** Transient analysis:
.tran	0.1ns     200ns   1ns

***** Power :
.meas tran AVGpower avg  Power

***** Propagation Delay :
.MEASURE TRAN tpHL
+ trig V(A) val = 'VDD/2'  rise = 1
+ targ V(Y2) val = 'VDD/2'  fall = 2

.MEASURE TRAN tpLH
+ trig V(A) val = 'VDD/2'  fall = 1
+ targ V(Y2) val = 'VDD/2'  rise = 1

.op
.end
