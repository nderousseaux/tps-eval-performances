import os

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

OUTPUT="./debit.csv"
NB_REPEAT=1
DATA_FOLDER="./res/"

CMD="docker-compose exec ns sh -c \"cd /code/tp4-projet-ns2/src/q4 && ns src.tcl"

PERTES = [10**(-10), 10**(-9), 10**(-8), 10**(-7), 10**(-6),10**(-5), 10**(-4), 10**(-3), 10**(-2)]
TCP = range(6)


class data:
    def __init__(self, fichier):
        self.fichier = fichier
        self.get_data()

    def get_data(self):
        # self.rtt = int(self.fichier.split("/")[2].split(".")[0])
        self.df = pd.read_csv(self.fichier, delim_whitespace=True, header=None)
        self.df.columns = ["time", "x", "y", "z", "a", "b", "cwnd"]
            
        #On ne garde que la premiere et derniere colone
        self.df = self.df[["time", "cwnd"]]

    def plot(self, ax):
        self.df.plot(kind='line', x='time', y='cwdn', ax=ax)


if __name__ == "__main__":
    idx=0
    with open(OUTPUT, "w") as f:
        f.write("debit;pertes;version\n")
    for i in range(0, NB_REPEAT):
        for l in PERTES:
            for t in TCP:
                print(f"{idx}/{NB_REPEAT * len(PERTES) * len(TCP)}")
                idx+=1
                # print(f"{CMD} {l} {t} > /dev/null\"")
                os.system(f"{CMD} {t} {l} \"")
                # On récupère le débit de la commande
                commande = "awk '{if ($9 == \"tcp\" && $5 == 6 && $7 == 7 && $1 == "+")  print $11*8/1024}' res/trace.tr | awk '{sum+=$1} END {print sum/NR}'"
                debit = os.popen(commande).read()
                # os.system("awk '{if ($9 == \"tcp\") print $11*8/1024}' res/trace.tr | awk '{sum+=$1} END {print sum/NR}'")

                # da = pd.read_csv("res/debit.tr", delim_whitespace=True, header=None)
                # columns = ["time", "debit"]
                da = pd.DataFrame([[float(debit), l]], columns=["debit", "pertes"])

                # #On arrondi tout les nombres à l'entier inférieur
                # da['time'] = da['time'].apply(np.floor)

                # #On group by
                # da = da.groupby(['time']).sum()

                # da["pertes"] = l

                if t == 0:
                    da['version'] = "Tahoe"
                if t == 1:
                    da['version'] = "NewReno"
                if t == 2:
                    da['version'] = "Cubic"
                if t == 3:
                    da['version'] = "Vegas"
                if t == 4:
                    da['version'] = "Sack"
                if t == 5:
                    da['version'] = "Fack"


                da.to_csv(OUTPUT, mode='a', index=True, header=False, sep=";")