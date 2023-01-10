#Execution : 
# $ns src.tcl version_tcp taux_pertes
# 0 = /TCP/tahoe 
# 1 = /TCP/Newreno
# 2 = /TCP/Linux
# 3 = /TCP/Vegas
# 4 = /TCP/Sack1
# 5 = /TCP/Fack

########## Déclarations ##########

#Simulator
set ns [new Simulator]

# set qlost [open "res/queuelost.tr" w]


#Finish
proc finish {} {
        global ns nf
        $ns flush-trace

        # Close all trace files
        foreach channel [file channels "file*"] {
          close $channel
        }
        
        # close $nf
        # exec nam out.nam &

        exit 0
}

set datafile [open "res/trace.tr" w] 
$ns namtrace-all $datafile

#On définit le taux de pertes
set loss [lindex $argv 1]
$ns loss-rate $loss

# # The following procedure records queue size, bandwidth and loss rate
# proc record {} {
#   global ns qfile qlost
#   set time 0.05
#   set now [$ns now]

#   # print in the file $qsize the current queue size
#   # print in the file $qbw the current used bandwidth
#   # print in the file $qlost the loss rate

#   $qfile instvar parrivals_ pdepartures_ bdrops_ bdepartures_ pdrops_ 

#   if {$parrivals_ != 0} {  
#     puts $qlost "$now [format %.8f [expr ($pdrops_*100)/$parrivals_]]"
#   }

#   $ns at [expr $now+$time] "record"
# }

########## Topologie ##########

# On définit chaque noeud
for {set i 0} {$i < 6} {incr i} {
  set n($i) [$ns node]
}
set nPair [$ns node]
set nImpair [$ns node]

# On définit les liens

for {set i 0} {$i < 6} {incr i} {
  if {$i % 2 == 0} {
    $ns duplex-link $n($i) $nPair 100Mb 1ms DropTail
  } else {
    $ns duplex-link $n($i) $nImpair 100Mb 1ms DropTail
  }
}
$ns duplex-link $nPair $nImpair 10Mb 1ms DropTail

########## Applications ##########

proc choix_tcp_ver {version}  {
#New Reno, Cubic, Vegas, Sack, Delayed Ack,

  if {$version == 0} {
    return [new Agent/TCP] 
  }
  if {$version == 1} {
    return [new Agent/TCP/Newreno]
  }        
  if {$version == 2} {
    return [new Agent/TCP/Linux]
  }
  if {$version == 3} {
    return [new Agent/TCP/Vegas]
  }
  if {$version == 4} {
    return [new Agent/TCP/Sack1]
  }
  if {$version == 5} {
    return [new Agent/TCP/Fack]
  }
}

# proc change_mss {tcp incr max temps} {

#   global ns mssf
#   set nb_tour [expr $max/$incr]
#   set unit [expr ($temps)/$nb_tour]
#   puts "nb_tour $nb_tour, temps: $temps"

#   #On change le mss de la connection tcp par pas de 1, au court du temps
#   for {set i 0} {$i < $nb_tour} {incr i 1} {
#     set mss [expr $i * $incr]
#     set temps [expr $i * $unit]
#     $ns at $temps "$tcp set packetSize_ $mss"
#   }
# }

# On déclare un flux tcp/ftp sur le noeud suivant
proc create_ftp {n0 n1 start stop version pertes} {
        global ns
        #Flux tcp tahoe
        set tcp [choix_tcp_ver $version] 
        
  

        $ns attach-agent $n0 $tcp
        set sink [new Agent/TCPSink]
        $ns attach-agent $n1 $sink
        $ns connect $tcp $sink
    

        #Flux ftp
        set ftp [new Application/FTP]
        $ftp attach-agent $tcp
        $ftp set type_ FTP

        
        $ns at $start "$ftp start"
        $ns at $stop "$ftp stop"

        return $tcp
}

#Pour 0, 2 et 4, on crée les flux

for {set i 0} {$i < 6} {incr i 2} {
    set i1 [expr ($i+1)]
    set ftp [create_ftp $n($i) $n($i1) 0 20000 [lindex $argv 0] [lindex $argv 1]]
    # On affiche le rtt de ftp
    $ftp set fid_ $i
}
# Pour 1, 3 et 5, on crée les flux inverses
for {set i 1} {$i < 6} {incr i 2} {
    set i1 [expr ($i-1)]
    set ftp [create_ftp $n($i) $n($i1) 0 20000 [lindex $argv 0] [lindex $argv 1]]
    $ftp set fid_ $i
}

# set qfile [$ns monitor-queue $nPair $nImpair [open queue.tr w] 0.05]
# [$ns link $nPair $nImpair] queue-sample-timeout;
########## Événements ##########

# $ns at 0.0 "record"
$ns at 20 "finish"

########## Nam config ##########

$ns color 0 black
$ns color 1 red
$ns color 2 blue
$ns color 3 green
$ns color 4 yellow
$ns color 5 orange

for {set i 0} {$i < 6} {incr i} {
  $n($i) label $i
}
$nPair label "Pair"
$nImpair label "Impair"

########## RUN ##########
$ns run