import os

import pandas as pd
import matplotlib.pyplot as plt

OUTPUT="./result.csv"
NB_REPEAT=1
DATA_FOLDER="./res/"

CMD="docker-compose exec ns sh -c \"cd /code/tp4-projet-ns2/src/q1 && ns src.tcl"

RANGE=6

ecarts=range(0, RANGE)



class data:
    def __init__(self, fichier):
        self.fichier = fichier
        self.get_data()

    def get_data(self):
        self.rtt = int(self.fichier.split("/")[2].split(".")[0])
        self.df = pd.read_csv(self.fichier, delim_whitespace=True, header=None)
        self.df.columns = ["time", "x", "y", "z", "a", "b", "cwnd"]
            
        #On ne garde que la premiere et derniere colone
        self.df = self.df[["time", "cwnd"]]

    def plot(self, ax):
        self.df.plot(kind='line', x='time', y='cwdn', ax=ax, label=self.rtt)


if __name__ == "__main__":


    with open(OUTPUT, "w") as f:
        f.write("time;cwdn;index;grp;file;ecart;rtt\n")
    for i in range(0, NB_REPEAT):
        print(str(i+1) + "/" + str(NB_REPEAT))
        for ecart in ecarts:
            rtts = []
            for i in range(3):
                rtts.append(ecart * i + 1)

            # print(f"{CMD} {' '.join(map(str, rtts))} > /dev/null")

            os.system(f"{CMD} {' '.join(map(str, rtts))} > /dev/null\"")

            #On transpose les fichiers dans result.csv
            for file in os.listdir(DATA_FOLDER):
                da = data(DATA_FOLDER+file)
                da.df['index'] = i
                da.df['grp'] = str(rtts)
                da.df['file'] = file
                da.df['ecart'] = ecart
                if file in ['0.tr', '1.tr']:
                    da.df['rtt'] = rtts[0]
                elif file in ['2.tr', '3.tr']:
                    da.df['rtt'] = rtts[1]
                elif file in ['4.tr', '5.tr']:
                    da.df['rtt'] = rtts[2]

                #On l'ajoute à la fin de result.csv
                da.df.to_csv(OUTPUT, mode='a', index=False, header=False, sep=";")
