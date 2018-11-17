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
import matplotlib.patches as mpatches

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

    @staticmethod
    def linearithmic(x, a, b, c):
        return a * np.log(x) + b * x + c


def plot_csv(path, function, title, graphstep=100):
    global i
    plt.clf()
    i += 1
    xdata = []
    ydata = []
    with open(path) as csv:
        for line in csv.read().split("\n"):
            if line == "":
                continue
            n, t = line.split(", ")
            n = int(n)
            t = float(t)*1000  # convert to ms
            xdata.append(n)
            ydata.append(t)

    xdata = np.array(xdata)
    ydata = np.array(ydata)

    param, v = curve_fit(function, xdata, ydata)

    plt.plot(xdata, ydata-function(xdata, *param), 'o')
    lin = np.linspace(min(xdata), max(xdata), graphstep)
    plt.plot(lin, lin*0)
    plt.xscale("log")
    plt.title(title+"  (Residuals plot)")
    p1 = mpatches.Patch(color='C0', label='Benchmark data')
    p2 = mpatches.Patch(color='C1', label='Line of best fit')
    plt.legend(handles=[p1, p2])
    plt.xlabel("n: Number of elements in the map being operated on.")
    plt.ylabel("Difference between predicted and actual time (ms)")
    print("RMSE Loss:", np.sqrt(np.mean(np.power(ydata-function(xdata, *param), 2))))
    plt.savefig('ris_sep/graph{}.png'.format(i), bbox_inches='tight')


plt.figure(figsize=(18, 6))
plot_csv("data/linearMapGet.csv", Functions.linear, "Linear map GET O(n)")
plot_csv("data/linearMapAdd.csv", Functions.linear, "Linear map ADD O(n)")
plot_csv("data/linearMapUpdate.csv",
         Functions.linear, "Linear map UPDATE O(n)")
plot_csv("data/binaryMapGet.csv", Functions.logarithmic,
         "Binary map GET O(logn)")
plot_csv("data/binaryMapAdd.csv", Functions.linearithmic,
         "Binary map ADD O(n) [O(n + logn)]")
plot_csv("data/binaryMapUpdate.csv", Functions.logarithmic,
         "Binary map UPDATE O(logn)")
plot_csv("data/hashMapGet.csv", Functions.linear, "Hash map GET O(n)")
plot_csv("data/hashMapAdd.csv", Functions.linear, "Hash map ADD O(n)")
plot_csv("data/hashMapUpdate.csv", Functions.linear, "Hash map UPDATE O(n)")


# plt.show()
