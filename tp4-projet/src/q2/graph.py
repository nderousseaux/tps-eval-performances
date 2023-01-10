from gen_data import *

import math

import json

RESULT_FILE = "result.csv"
RESULT_DEBIT_FILE = "debit.csv"

data =pd.read_csv(RESULT_FILE, header=0, delimiter=";")

for size in data["size"].unique():
    d_size=data.query(f"size == {size}")
    ax=plt.gca()
    for i in d_size['rtt'].unique(): 
        d_rtt = d_size.query(f"rtt == {i}")
        d_rtt = d_rtt.query(f"file == '{d_rtt['file'].unique()[0]}'")
        d_rtt.plot(kind='line', x='time', y='cwdn', ax=ax, label=f"{i}ms")
    plt.ylabel("cwnd", rotation=90)
    plt.savefig(f'{"-".join(map(str, rtts))}-{size}-cwnd')
    plt.clf()


debit =pd.read_csv(RESULT_DEBIT_FILE, header=0, delimiter=";")

for size in debit["size"].unique():
    d_size=debit.query(f"size == {size}")
    ax=plt.gca()
    for i in d_size['rtt'].unique():
        d_rtt = d_size.query(f"rtt == {i}")
        me = d_rtt['nb_octet'].mean()
        # print(f"Moyenne de {i}ms (avec de file {size}): {me}")
        me /= 1000
        me = round(me)
        d_rtt.plot(kind='line', x='time', y='nb_octet', ax=ax, label=f"{i}ms {me}Ko/s")
    plt.ylabel("Nombre d'octet/s", rotation=90)
    plt.savefig(f'{"-".join(map(str, rtts))}-{size}-debit')
    plt.clf()