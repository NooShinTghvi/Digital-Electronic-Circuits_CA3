* Dynamic
***** Library *****
.prot
.inc '45nm.pm'
.unprot

***** Params *****
.param  +VDD = 1V
+GND = 0V
+Lmin = 45n
+Wp = 2
+Wn = 8

***** Temperature *****
.temp	25

***** Sources *****
*V      N+  N-  Pulse   V1  V2  TD  TR   TF   PW   PER
Vsupply	Vm	0	DC	VDD
VinA    A	0	DC  VDD
VinX    X	0	Pulse  GND  VDD 0  1p 1p 2000p 5000p
VinClk  clk	0	Pulse  GND  VDD 0  1p 1p 5000p 9000p

***** Component *****
X1      clk     Vm      X       W1      inverterDynamic
X2      clk     Vm      W1      W2      inverterDynamic
X3      clk     Vm      W2      A       Y1      andDynamic
X4      clk     Vm      W1      A       Y2      andDynamic

***** NAND
.SUBCKT nandDynamic     clk     VDD     A       B       out
Mp1		out	  	clk   	VDD	    VDD		pmos	l='Lmin'	w='Lmin*Wp'
Mn1	    2	   	B   	GND  	GND     nmos	l='Lmin'	w='Lmin*Wn'
Mn2	    out	   	A   	2  		2     	nmos	l='Lmin'	w='Lmin*Wn'
CL		out		0       5ff
.ENDS nandDynamic

***** INVERTER
.SUBCKT inverterDynamic	clk     VDD     A 		out
Mp1		out	  	clk   	VDD	    VDD		pmos	l='Lmin'	w='Lmin*Wp'
Mn1	    out	   	A   	GND  	GND     nmos	l='Lmin'	w='Lmin*Wn'
CL		out		0       5ff
.ENDS inverterDynamic

***** AND
.SUBCKT andDynamic  clk     VDD     A       B       out
Xnand       clk     VDD     A       B       wire    nandDynamic
Xinverter   clk     VDD     wire    out     inverterDynamic
.ENDS andDynamic

***** Type of Analysis *****
***** Transient analysis:
.tran	0.1ns     200ns   1ns

***** Power :
.meas tran AVGpower avg  Power

***** Propagation Delay :
.MEASURE TRAN tpHL
+ trig V(X) val = 'VDD/2'  rise = 1
+ targ V(Y1) val = 'VDD/2'  fall = 1

.MEASURE TRAN tpLH
+ trig V(X) val = 'VDD/2'  fall = 1
+ targ V(Y1) val = 'VDD/2'  rise = 1

.op
.end
