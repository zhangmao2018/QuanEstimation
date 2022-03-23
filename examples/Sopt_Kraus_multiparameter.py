import numpy as np
from quanestimation import *
from qutip import *

# Kraus operators for the generalized qubit amplitude damping
n, p = 0.1, 0.1
psi0 = np.array([[1],[0]])
psi1 = np.array([[0],[1]])
K0 = np.sqrt(1-n)*(psi0@psi0.T+np.sqrt(1-p)*psi1@psi1.T)
K1 = np.sqrt(p-p*n)*psi0@psi1.T
K2 = np.sqrt(n)*(np.sqrt(1-p)*psi0@psi0.T+psi1@psi1.T)
K3 = np.sqrt(p*n)*psi1@psi0.T
K = [K0, K1, K2, K3]

dK0_n = -0.5*(psi0@psi0.T+np.sqrt(1-p)*psi1@psi1.T)/np.sqrt(1-n)
dK1_n = -0.5*p*psi0@psi1.T/np.sqrt(p-p*n)
dK2_n = 0.5*(np.sqrt(1-p)*psi0@psi0.T+psi1@psi1.T)/np.sqrt(n)
dK3_n = 0.5*p*psi1@psi0.T/np.sqrt(p*n)
dK0_p = -0.5*np.sqrt(1-n)*psi1@psi1.T/np.sqrt(1-p)
dK1_p = 0.5*(1-n)*psi0@psi1.T/np.sqrt(p-p*n)
dK2_p = -0.5*np.sqrt(n)*psi0@psi0.T/np.sqrt(1-p)
dK3_p = -0.5*np.sqrt(n)*psi0@psi0.T/np.sqrt(1-p)
dK3_p = 0.5*n*psi1@psi0.T/np.sqrt(p*n)
dK = [[dK0_n, dK0_p], [dK1_n, dK1_p], [dK2_n, dK2_p], [dK3_n, dK3_p]]

# State optimization algorithm: AD
AD_paras = {
    "Adam": False,
    "psi0": [],
    "max_episode": 30,
    "epsilon": 0.01,
    "beta1": 0.90,
    "beta2": 0.99,
}
state = StateOpt(savefile=False, method="AD", **AD_paras)
state.kraus(K, dK)
state.QFIM()
state.CFIM()
state.HCRB()

# State optimization algorithm: PSO
PSO_paras = {
    "particle_num": 10,
    "psi0": [],
    "max_episode": [100, 10],
    "c0": 1.0,
    "c1": 2.0,
    "c2": 2.0,
    "seed": 1234,
}
state = StateOpt(savefile=False, method="PSO", **PSO_paras)
state.kraus(K, dK)
state.QFIM()
state.CFIM()
state.HCRB()

# State optimization algorithm: DE
DE_paras = {
    "popsize": 10,
    "psi0": [],
    "max_episode": 100,
    "c": 1.0,
    "cr": 0.5,
    "seed": 1234,
}
state = StateOpt(savefile=False, method="DE", **DE_paras)
state.kraus(K, dK)
state.QFIM()
state.CFIM()
state.HCRB()

# State optimization algorithm: DDPG
DDPG_paras = {"layer_num": 4, "layer_dim": 250, "max_episode": 50, "seed": 1234}
state = StateOpt(savefile=False, method="DDPG", **DDPG_paras)
state.kraus(K, dK)
state.QFIM()
state.CFIM()
state.HCRB()

# State optimization algorithm: NM
NM_paras = {
    "state_num": 20,
    "psi0": [],
    "max_episode": 100,
    "ar": 1.0,
    "ae": 2.0,
    "ac": 0.5,
    "as0": 0.5,
    "seed": 1234,
}
state = StateOpt(savefile=False, method="NM", **NM_paras)
state.kraus(K, dK)
state.QFIM()
state.CFIM()
state.HCRB()
