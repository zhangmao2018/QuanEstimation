# -*- coding: utf-8 -*-

import numpy as np
from scipy.sparse import csc_matrix
from sympy import Matrix, GramSchmidt
        
def mat_vec_convert(A):
    if A.shape[1] == 1:
        dim = int(np.sqrt(len(A)))
        return A.reshape([dim, dim])
    else:
        return A.reshape([len(A)**2,1])
    
def suN(n):
    U, V, W = [], [], []
    for i in range(n-1):
        for j in range(i+1, n):
            U_tp = csc_matrix(([1.,1.], ([i,j],[j,i])), shape=(n, n)).toarray()
            V_tp = csc_matrix(([-1.j,1.j], ([i,j],[j,i])), shape=(n, n)).toarray()
            U.append(U_tp)
            V.append(V_tp)

    diag = []
    for i in range(n-1):
        mat_tp = csc_matrix(([1,-1], ([i,i+1],[i,i+1])), shape=(n, n)).toarray()
        diag_tp = np.diagonal(mat_tp)
        diag.append(Matrix(diag_tp)) 
    W_gs = GramSchmidt(diag,True)
    for k in range(len(W_gs)):
        W_tp = np.fromiter(W_gs[k], dtype=complex)
        W.append(np.sqrt(2)*np.diag(W_tp))

    return U, V, W

def suN_generator(n):
    symm, anti_symm, diag = suN(n)
    Lambda = [0. for i in range(len(symm+anti_symm+diag))]
    Lambda[0], Lambda[1], Lambda[2] = symm[0], anti_symm[0], diag[0]
    
    repeat_times = 2
    m1, n1, k1 = 0, 3, 1
    while True:
        m1 += n1
        j,l = 0,0
        for i in range(repeat_times):
            Lambda[m1+j] = symm[k1]
            Lambda[m1+j+1] = anti_symm[k1]
            j += 2
            k1 += 1

        repeat_times += 1
        n1 = n1 + 2
        if k1 == len(symm):
            break
    
    m2, n2, k2 = 2, 5, 1
    while True:
        m2 += n2
        Lambda[m2] = diag[k2]
        n2 = n2 + 2
        k2 = k2 + 1
        if k2 == len(diag):
            break
    return Lambda

def gramschmidt(A):
    dim = len(A)
    n = len(A[0])
    Q = [np.zeros(n, dtype=np.complex128) for i in range(dim)]
    for j in range(0, dim):
        q = A[j]
        for i in range(0, j):
            rij = np.vdot(Q[i], q)
            q = q - rij*Q[i]
        rjj = np.linalg.norm(q, ord=2)
        Q[j] = q/rjj
    return Q
    