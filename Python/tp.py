#exec(open('hopfield_imgrecon.py').read())

###
# Script para la realización del TP1 de la materia Procesamiento de Habla

import matplotlib.pyplot as plt
import numpy as np
from scipy import signal
from scipy import io
import scipy.io.wavfile as wav
from scipy.linalg import toeplitz
from math import *

#plt.rcParams['figure.figsize']=(6,4)


# LINEAR PREDICTIVE CODING
## Primera parte
 
# Carga de los valores numéricos de la señal
(Fs, fantasia) = wav.read('fantasia.wav')
fantasia = fantasia.astype(float)/32767
 
W = round(0.025*Fs)
D = round(0.010*Fs)
 
class LPC:
    def __init__(self, amount_coefs):
        self.a = [] 
        self.r = [] 
        self.G = 1
        self.amt_coefs = amount_coefs
        self.R = [] 

    def calc_lpc(self, signal)
        ## Calculate the coeficients of a for given signal
        M = self.amt_coefs  # Rename for easier coding
 
# def funcionlpc (senial_w, cant_coefs=20)
#     # senial_w es la Ventana de señal
#     # cant_coefs es la Cantidad de coeficientes
# 
# 
# 
# M = 20
# 
# # Calcular la cantidad de pasos a realizar:
# # Lpasos = 
# 
# # Inicializar ai
# ai = #
# 
# # For para almacenar los coeficientes ai en una matriz
# for n in range(Lpasos):
#     #ai[n] = funcionlpc(...
# 
# 
# # Calcular el espectro de la envolvente a partir de los coeficientes ai de cada frame
# # Graficar espectro envolvente
# # Graficar espectograma
# # Graficar espectros superpuesto de las 4 vocales en la señal (un frame por vocal)
# # Identificar los picos, y realizar comentarios sobre la posición relacionado a la práctica de fonética.
# 
