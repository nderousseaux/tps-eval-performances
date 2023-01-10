from gen_data import *

import math

import json

RESULT_FILE = "debit.csv"

# function to add value labels
def addlabels(x,y):
    for i in range(len(x)):
        plt.text(i,y[i]+1,y[i])

perte = debit =pd.read_csv(RESULT_FILE, header=0, delimiter=";")
ax=plt.gca()
for version in perte["version"].unique():
    d_version=perte.query(f"version == '{version}'")

    p_l = []
    debit = []
    for pertes in d_version["pertes"].unique():
        d_pertes=d_version.query(f"pertes == {pertes}")
        
        #On fait la moyenne du débit pour d_perttes
        moy = d_pertes['debit'].mean()
        print(f"perte {pertes}, version {version}, debit {moy}")
    #     p_l.append(pertes)
    #     debit.append(moy)

    # # On crée le graphe
    # plt.plot(p_l, debit, label=version)
    
# plt.show()

    
    # # Show graphic
    # # plt.show()
    # plt.savefig(f'{size}')
    
    # plt.clf()
