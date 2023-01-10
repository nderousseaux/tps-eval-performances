#Execution : 
# $ns src.tcl taille_file

#Les fichiers de trace : 
# alltrace.tr : Correspond à la trace complete de la simulation  
# cwnd-*/tr : Conrrespondent aux trace de donnée    

########## Déclarations ##########

#Simulator
set ns [new Simulator]


#One trace file for each senders in an array
for { set i 0 } { $i < 6 } { incr i 1 } {
    set cwndfile($i) [open "res/cwnd-$i.tr" w]
}

set datafile [open "res/alltrace.tr" w] 
$ns namtrace-all $datafile

# set nf [open out.nam w]
# $ns namtrace-all $nf

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

#waiting queu size 
set szf [lindex $argv 0]

if {$szf != 0} {
  $ns queue-limit $nPair $nImpair $szf
  $ns queue-limit $nImpair $nPair $szf
}


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

# On déclare un flux tcp/ftp sur le noeud suivant
proc create_ftp {n0 n1 start stop rtt cwndfile version} {
        global ns
        #Flux tcp tahoe
        set tcp [choix_tcp_ver 0] 
        $tcp set packetSize_ 10000
        $tcp set rtt_ $rtt
        $ns attach-agent $n0 $tcp

        $tcp attach $cwndfile
        $tcp trace cwnd_

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
    puts "Création du flux $i vers $i1"
    set ftp [create_ftp $n($i) $n($i1) 0 20000 1 $cwndfile($i) $i]
    # On affiche le rtt de ftp
    puts "RTT de ftp : [$ftp set rtt_]"
    $ftp set fid_ $i
}
# Pour 1, 3 et 5, on crée les flux inverses
for {set i 1} {$i < 6} {incr i 2} {
    set i1 [expr ($i-1)]
    puts "Création du flux $i vers $i1"
    set ftp [create_ftp $n($i) $n($i1) 0 20000 1 $cwndfile($i) $i] 
    $ftp set fid_ $i
}

########## Événements ##########

$ns at 600 "finish"

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