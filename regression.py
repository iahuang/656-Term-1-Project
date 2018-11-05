""" Reads a CSV file with the data that should be formatted as such:

mode, n, time

mode :  what operation is it?
n    :  number of items in the map on which the operation is performed
time :  the average time it takes to perform said operation

example: set, 100, 0.05
"""

from scipy.optimize import curve_fit
import numpy as np
import matplotlib.pyplot as plt

i = 0

class Functions:
    @staticmethod
    def constant(x, n):
        return x*0 + n

    @staticmethod
    def linear(x, m, b):
        return m*x + b

    @staticmethod
    def logarithmic(x, a, b):
        return a * np.log(x) + b

def plot_csv(path, function, title, graphstep=100):
    global i
    i+=1
    xdata = []
    ydata = []
    with open(path) as csv:
        for line in csv.read().split("\n"):
            if line == "":
                continue
            n, t = line.split(", ")
            n = int(n)
            t = float(t)
            xdata.append(n)
            ydata.append(t)

    xdata = np.array(xdata)
    ydata = np.array(ydata)

    param, v = curve_fit(function, xdata, ydata)
    plt.subplot(3,2,i)
    plt.tight_layout()
    plt.plot(xdata, ydata)
    lin = np.linspace(min(xdata),max(xdata),graphstep)
    plt.plot(lin, function(lin, *param))
    plt.xscale("log")
    plt.title(title)
    print("RMSE Loss:",np.sqrt(np.mean(np.power(ydata-function(xdata, *param),2))))

plot_csv("data/linearMapGet.csv", Functions.linear, "Linear map GET O(n)")
plot_csv("data/linearMapGet.csv", Functions.linear, "Linear map SET O(n)")
plot_csv("data/binaryMapGet.csv", Functions.logarithmic, "Binary map GET O(logn)")
plot_csv("data/binaryMapSet.csv", Functions.linear, "Binary map SET O(n)")
plot_csv("data/hashMapGet.csv", Functions.constant, "Hash map GET O(C)")
plot_csv("data/hashMapSet.csv", Functions.linear, "Hash map SET O(n)")

# plot_csv("data/binaryMapSet.csv", Functions.logarithmic)

plt.show()