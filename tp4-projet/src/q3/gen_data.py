import os

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

OUTPUT="./debit.csv"
NB_REPEAT=1
DATA_FOLDER="./res/usefull_data/"

CMD="docker-compose exec ns sh -c \"cd /code/tp4-projet-ns2/src/q3 && ns src.tcl"

FILE_SIZE = [
    0, 4
]


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


    with open(OUTPUT, "w") as f:
        f.write("time;nb_octet;index;file;type;size\n")
    for i in range(0, NB_REPEAT):

        for l in FILE_SIZE:
            os.system(f"{CMD} {l} > /dev/null\"")
            os.system(f"sh ./awk_script.sh")

            #On transpose les fichiers dans result.csv
            for file in [f for f in os.listdir(DATA_FOLDER)]:
                print(f"l: {l} taille: {file}")
                da = pd.read_csv(DATA_FOLDER + file, delim_whitespace=True, header=None)
                da.columns = ["time", "nb_octet"]

                #On arrondi tout les nombres à l'entier inférieur
                da['time'] = da['time'].apply(np.floor)

                #On group by
                da = da.groupby(['time']).sum()

                da["index"] = i

                da['file'] = file


                if file in ["data_0.tr"]:
                    da['type'] = "Tahoe"
                if file in ["data_1.tr"]:
                    da['type'] = "NewReno"
                if file in ["data_2.tr"]:
                    da['type'] = "Cubic"
                if file in ["data_3.tr"]:
                    da['type'] = "Vegas"
                if file in ["data_4.tr"]:
                    da['type'] = "Sack"
                if file in ["data_5.tr"]:
                    da['type'] = "Fack"

                da["size"] = l


                da.to_csv(OUTPUT, mode='a', index=True, header=False, sep=";")