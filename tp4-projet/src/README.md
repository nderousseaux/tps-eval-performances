Lien googledoc : 
https://docs.google.com/document/d/1Du7MwlUpHBuVWhrk_9K3nxMLmrf4ayt54yL357KqD6w/edit#heading=h.pmer9g3joaom

## Tcl 

# q1
Execution :
    $ns src.tcl x y z

# q2
#Execution : 
 $ns src.tcl x y z 

Les fichiers de trace : 
    alltrace.tr : Correspond à la trace complete de la simulation  
    cwnd-*/tr : Conrrespondent aux trace de donnée  

//Je n'ai pas reussi a faire 1 fichier par trace
dans alltrace.tr signification des colonnes : 
Sur une ligne : r 25.1624 1 0 ack 40 ------- 0 1.0 0.0 2417 4835
  • Event ( r = receive, d= drop, + = enqueue, - = dequeue)
  • Timestamp
  • Nodes
  • Packet type
  • Packet size
  • Flags
  • Flow ID
  • Source address
  • Destination address
  • Sequence number
  • Unique ID

Les infos qui nous interessent : Event r Nodes packet size 

# q3
Execution : 
$ns src.tcl x y z taille_file type_de_file 

Les fichiers de trace : 
alltrace.tr : Correspond à la trace complete de la simulation  
cwnd-*/tr : Conrrespondent aux trace de donnée  

type de file pas encore fonctionnel



