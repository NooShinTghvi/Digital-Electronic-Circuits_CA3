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
Vgnd	Vg	0	DC	GND
VinClk  clk	0	Pulse  GND  VDD 0  1p 1p 5000p 9000p
VinA    A	0	Pulse  GND  VDD 0  1p 1p 2200p 5000p
VinX    X	0	DC	GND
*Pulse  GND  VDD 0  1p 1p 2200p 5000p

***** Component *****
X1      clk     Vm      Vg      X       W1      inverterDynamic_U
X2      clk     Vm      Vg      W1      W2      inverterDynamic_D
X3      clk     Vm      Vg      W2      A       Y1      andDynamic
X4      clk     Vm      Vg      W1      A       Y2      andDynamic

***** NAND
.SUBCKT nandDynamic     clk     VDD     GND    A       B       out
Mp1		out	  	clk   	VDD	    VDD		pmos	l='Lmin'	w='Lmin*Wp'
Mn1	    2	   	B   	GND  	GND     nmos	l='Lmin'	w='Lmin*Wn'
Mn2	    out	   	A   	2  		2     	nmos	l='Lmin'	w='Lmin*Wn'
CL		out		0       5ff
.ENDS nandDynamic

***** INVERTER
.SUBCKT inverterDynamic_U	clk     VDD     GND     A 		out
Mp1		out	  	clk   	VDD	    VDD		pmos	l='Lmin'	w='Lmin*Wp'
Mn1	    out	   	A   	GND  	GND     nmos	l='Lmin'	w='Lmin*Wn'
CL		out		0       5ff
.ENDS inverterDynamic_U

.SUBCKT inverterDynamic_D	clk     VDD     GND     A 		out
Mp1		out	  	A   	VDD	    VDD		pmos	l='Lmin'	w='Lmin*Wp'
Mn1	    out	   	clk   	GND  	GND     nmos	l='Lmin'	w='Lmin*Wn'
CL		out		0       5ff
.ENDS inverterDynamic_D
***** AND
.SUBCKT andDynamic  clk     VDD     GND     A       B       out
Xnand       clk     VDD     GND     A       B       wire    nandDynamic
Xinverter   clk     VDD     GND     wire    out     inverterDynamic_D
.ENDS andDynamic

***** Type of Analysis *****
***** Transient analysis:
.tran	0.1ns     200ns   1ns

***** Power :
.meas tran AVGpower avg  Power

***** Propagation Delay :
.MEASURE TRAN tpHL
+ trig V(A) val = 'VDD/2'  rise = 1
+ targ V(Y2) val = 'VDD/2'  fall = 1

.MEASURE TRAN tpLH
+ trig V(A) val = 'VDD/2'  fall = 1
+ targ V(Y2) val = 'VDD/2'  rise = 1

.op
.end
