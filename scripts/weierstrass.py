import numpy as np

M = 590

def weierstrass(x, N):
	y = np.zeros((1,M))
	for n in range(1,N):
		y = y + np.cos(3**n*np.pi*x)/2**n
	return y

x = np.linspace(-1/3,1/3,M)
y = np.reshape(weierstrass(x,500),(M,))
y_norm = (y-np.min(y))/(np.max(y) - np.min(y))
y_norm *= 200
print(list(y_norm))