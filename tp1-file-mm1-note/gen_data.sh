MAIN_FOLDER="./bin"
MAIN="MM1"
OUTPUT="./results/data.csv"

NB_REPEAT=10

#Première série
LAMBDA_MIN=2
LAMBDA_MAX=8
MU_MIN=2
MU_MAX=8
TEMPS=1000000
PAS=2

#Seconde série
LAMBDA=5
MU=6
TEMPS_LIST="1 10 100 1000 10000 100000 1000000 10000000"


echo "index;lambda;mu;time;nb_clients;client_no_wait;nb_moyen_clients;temps_sejour;time_exec" > $OUTPUT

for i in `seq 0 $NB_REPEAT`
do
    #Premières mesures
    for lambda in `seq $LAMBDA_MIN $PAS $LAMBDA_MAX`
    do
        for mu in `seq $MU_MIN $PAS $MU_MAX `
        do
            if [ $lambda -le $mu ]
            then
                exec=$( { time -f "%U" java -cp $MAIN_FOLDER $MAIN $lambda $mu $TEMPS 0; } 2>&1 )
                nb_clients=`echo "$exec" | awk '{print $NF}' | tail -n 7 | head -n 1`
                clients_no_wait=`echo "$exec" | awk '{print $NF}' | tail -n 6 | head -n 1`
                nb_moyen_clients=`echo "$exec" | awk '{print $NF}' | tail -n 3 | head -n 1`
                temps_sejour=`echo "$exec" | awk '{print $NF}' | tail -n 2 | head -n 1`
                time_exec=`echo "$exec" | awk '{print $NF}' | tail -n 1`
                
                echo "$i;$lambda;$mu;$TEMPS;$nb_clients;$clients_no_wait;$nb_moyen_clients;$temps_sejour;$time_exec" >> $OUTPUT
            fi
        done
    done

    #Secondes mesures
    for temps in $TEMPS_LIST
    do
        exec=$( { time -f "%U" java -cp $MAIN_FOLDER $MAIN $LAMBDA $MU $temps 0; } 2>&1 )
        nb_clients=`echo "$exec" | awk '{print $NF}' | tail -n 7 | head -n 1`
        clients_no_wait=`echo "$exec" | awk '{print $NF}' | tail -n 6 | head -n 1`
        nb_moyen_clients=`echo "$exec" | awk '{print $NF}' | tail -n 3 | head -n 1`
        temps_sejour=`echo "$exec" | awk '{print $NF}' | tail -n 2 | head -n 1`
        time_exec=`echo "$exec" | awk '{print $NF}' | tail -n 1`
        

        echo "$i;$LAMBDA;$MU;$temps;$nb_clients;$clients_no_wait;$nb_moyen_clients;$temps_sejour;$time_exec" >> $OUTPUT
    done
done
