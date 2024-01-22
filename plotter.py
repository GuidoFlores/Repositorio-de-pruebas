import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# class FileReader:
#     def __init__(self):
#         pass

#     #TODO: add headers: list[str], sep: str
#     def load(file: str):
#         data = pd.read_csv(file)
#         return data


data = pd.read_csv('steam.csv', header=None, names=['game', 'price', 'hasDiscount', 'genres'])

print(data)

data.plot()

plt.show()
