import numpy as np
from quanestimation import *

#initial state
rho0 = 0.5*np.array([[1.,1.],[1.,1.]])
#free Hamiltonian
omega0 = 1.0
sz = np.array([[1.+0.j, 0.+0.j],[0.+0.j, -1.+0.j]])
H0 = 0.5*omega0*sz
dH0 = [0.5*sz]
#measurement
M1 = 0.5*np.array([[1.,1.],[1.,1.]])
M2 = 0.5*np.array([[1.,-1.],[-1.,1.]])
M  = [M1, M2]
#dissipation
sp = np.array([[0., 1.],[0., 0.]])  
sm= np.array([[0., 0.],[1., 0.]]) 
decay = [[sp, 0.0], [sm, 0.1]]
#dynamics
tspan = np.linspace(0., 50.0, 2000)
dynamics = Lindblad(tspan, rho0, H0, dH0, decay)
rho, drho = dynamics.expm()
C = [[1.0]]

QFI, CFI = [], []
value = []
for rho_i, drho_i in zip(rho, drho):
    # Cramer-Rao
    QFI_tp = QFIM(rho_i, drho_i)
    CFI_tp = CFIM(rho_i, drho_i, M)
    QFI.append(QFI_tp)
    CFI.append(CFI_tp)
    # Holevo
    f, X = Holevo_bound(rho_i, [drho_i], C)
    value.append(f)

