from gen_data import *

import json

RESULT_FILE = "result.csv"

data =pd.read_csv(RESULT_FILE, header=0, delimiter=";")

# # Différence de moyenne en fonction de l'écart
# # for ecart in data["ecart"].unique():
# # df_ecart = data.query(f"ecart == {ecart}")
# df_ecart = data.query(f"ecart == 10")

# # #On calcule les moyenne de cwdn pour chaque flux
# for rtt in df_ecart["file"].unique():
#     df_rtt = df_ecart.query(f"file == '{rtt}.tr'")
#     moyenne = df_ecart["cwdn"].mean()
#     print(f"Moyenne de {rtt} : {moyenne}")



# fig, axs = plt.subplots(RANGE)
idx = 0
for grp in data["grp"].unique():


    d_grp=data.query(f"grp == '{grp}'")
    ax=plt.gca()
    for i in d_grp['rtt'].unique():
        d_rtt = d_grp.query(f"rtt == {i}")
        d_rtt = d_rtt.query(f"file == '{d_rtt['file'].unique()[0]}'")
        # print(d_rtt)
        d_rtt.plot(kind='line', x='time', y='cwdn', ax=ax, label=f"{i}ms")
    plt.ylabel("cwnd", rotation=90)
    plt.savefig(f'{"-".join(map(str, json.loads(grp)))}')
    plt.clf()
    idx+=1
