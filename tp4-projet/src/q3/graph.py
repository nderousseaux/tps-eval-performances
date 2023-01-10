from gen_data import *

import math

import json

RESULT_FILE = "debit.csv"

# function to add value labels
def addlabels(x,y):
    for i in range(len(x)):
        plt.text(i,y[i]+1,y[i])

debit =pd.read_csv(RESULT_FILE, header=0, delimiter=";")

for size in debit["size"].unique():
    d_size=debit.query(f"size == {size}")

    types = d_size['type'].unique()
    moyennes = []
    for t in types:
        d_type = d_size.query(f"type == '{t}'")

        # On calcule la moyenne du type tcp
        moy = d_type['nb_octet'].mean()
        moy /= 1000
        moy = round(moy)
        moyennes.append(moy)

    # Create bars
    plt.bar(types, moyennes)

    addlabels(types, moyennes)
    plt.ylabel("Débit moyen (Ko/s)", rotation=90)
    plt.xlabel("Versions de tcp")

    if size == 0:
        fil = "Pas de file d'attente"
    else:
        fil = f"File d'attente de taille {size}"
    plt.title(f"Comparaison des débits en fonction de la version de TCP\n({fil})")
    
    # Show graphic
    # plt.show()
    plt.savefig(f'{size}')
    
    plt.clf()
