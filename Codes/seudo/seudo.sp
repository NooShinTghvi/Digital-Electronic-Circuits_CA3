* seudo
***** Library *****
.prot
.inc '45nm.pm'
.unprot

***** Params *****
.param  +VDD = 1V
+GND = 0V
+Lmin = 45n
+Wp = 1
+Wn = 2

***** Temperature *****
.temp	25

***** Sources *****
*V      N+  N-  Pulse   V1  V2  TD  TR  TF  PW  PER
Vsupply	Vm	0	DC	VDD
Vgnd	Vg	0	DC	GND
VinA    A	0	Pulse  GND  VDD 0  1p 1p 2000p 5000p
VinX    X	0	DC	GND

***** Component *****
X1      Vm      Vg      X       W1      inverterSeudo
X2      Vm      Vg      W1      W2      inverterSeudo
X3      Vm      Vg      W2      A       Y1      andSeudo
X4      Vm      Vg      W1      A       Y2      andSeudo

***** NAND
.SUBCKT nandSeudo       VDD     GND     A       B       out
Mp1		out	  	GND   	VDD	    VDD		pmos	l='Lmin'	w='Lmin*Wp'
Mn1	    2	   	B   	GND  	GND     nmos	l='Lmin'	w='Lmin*Wn'
Mn2	    out	   	A   	2  		2     	nmos	l='Lmin'	w='Lmin*Wn'
.ENDS nandSeudo

***** INVERTER
.SUBCKT inverterSeudo	VDD     GND     A 		out
Mp1		out	  	GND   	VDD	    VDD		pmos	l='Lmin'	w='Lmin*Wp'
Mn1	    out	   	A   	GND  	GND     nmos	l='Lmin'	w='Lmin*Wn'
.ENDS inverterSeudo

***** AND
.SUBCKT andSeudo    VDD     GND     A       B       out
Xnand      VDD      GND     A       B       wire     nandSeudo
Xinverter  VDD      GND     wire    out     inverterSeudo
.ENDS andSeudo

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
