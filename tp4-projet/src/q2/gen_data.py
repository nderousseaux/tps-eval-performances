import os

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

OUTPUT="./result.csv"
OUTPUT_DEBIT="./debit.csv"
NB_REPEAT=1
DATA_FOLDER="./res/"
DATA_FOLDER_DEBIT="./res/usefull_data/"

CMD="docker-compose exec ns sh -c \"cd /code/tp4-projet-ns2/src/q2 && ns src.tcl"

rtts = [1, 6, 11]
FILE_SIZE = [
    0, 100
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
        f.write("time;cwdn;index;grp;file;rtt;size\n")
    with open(OUTPUT_DEBIT, "w") as f:
        f.write("time;nb_octet;file;size;rtt\n")
    for i in range(0, NB_REPEAT):

        for l in FILE_SIZE:
            print(f"{l}")
            os.system(f"{CMD} {' '.join(map(str, rtts))} {l} > /dev/null\"")
            #On transpose les fichiers dans result.csv
            for file in [f for f in os.listdir(DATA_FOLDER) if f not in ["alltrace.tr", "usefull_data"]]:
                da = data(DATA_FOLDER+file)
                da.df['index'] = i
                da.df['grp'] = str(rtts)
                da.df['file'] = file
                if file in ['cwnd-0.tr', 'cwnd-1.tr']:
                    da.df['rtt'] = rtts[0]
                elif file in ['cwnd-2.tr', 'cwnd-3.tr']:
                    da.df['rtt'] = rtts[1]
                elif file in ['cwnd-4.tr', 'cwnd-5.tr']:
                    da.df['rtt'] = rtts[2]
                da.df['size'] = l

                #On l'ajoute à la fin de result.csv
                da.df.to_csv(OUTPUT, mode='a', index=False, header=False, sep=";")

            os.system(f"sh ./awk_script.sh")

            #On transpose les fichiers dans result.csv
            for file in [f for f in os.listdir(DATA_FOLDER_DEBIT)]:
                print(file)
                da = pd.read_csv(DATA_FOLDER_DEBIT + file, delim_whitespace=True, header=None)
                da.columns = ["time", "nb_octet"]

                #On arrondi tout les nombres à l'entier inférieur
                da['time'] = da['time'].apply(np.floor)

                #On group by
                da = da.groupby(['time']).sum()

                da['file'] = file

                da["size"] = l
                if file in ["data_0.tr", "data_1.tr"]:
                    da['rtt'] = rtts[0]
                elif file in ["data_2.tr", "data_3.tr"]:
                    da['rtt'] = rtts[1]
                elif file in ["data_4.tr", "data_5.tr"]:
                    da['rtt'] = rtts[2]

                da.to_csv(OUTPUT_DEBIT, mode='a', index=True, header=False, sep=";")