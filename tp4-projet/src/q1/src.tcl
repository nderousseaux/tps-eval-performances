#Execution :
# $ns src.tcl x y z

########## Déclarations ##########
#Simulator
set ns [new Simulator]


#Stockage d'arguments
set j 0 
for {set ipair 0} {$ipair < 6} {incr ipair 2} {
  set iimpair [expr $ipair + 1]
  set tab($ipair) [lindex $argv $j]
  set tab($iimpair) [lindex $argv $j]
  incr j
}

#One trace file for each senders in an array
for { set i 0 } { $i < 6 } { incr i 1 } {
    set tracefile($i) [open "res/$i.tr" w]
}

#Finish 
proc finish {} {
        global ns tfs
        $ns flush-trace

        # Close all trace files
        foreach channel [file channels "file*"] {
          close $channel
        }

        #global ns nf
        #$ns flush-trace
        #close $nf
        # exec nam out.nam &

        # exec python3 res.py
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
    puts $tab($i)
    $ns duplex-link $n($i) $nPair 100Mb $tab($i)ms DropTail
  } else {
    puts $tab($i)
    $ns duplex-link $n($i) $nImpair 100Mb $tab($i)ms DropTail
  }
}

$ns duplex-link $nPair $nImpair 10Mb 1ms DropTail

########## Applications ##########

# On déclare un flux tcp/ftp sur le noeud suivant
proc create_ftp {n0 n1 start stop rtt tracefile} {
        global ns
        #Flux tcp tahoe
        set tcp [new Agent/TCP]
        $tcp set rtt_ $rtt 
        $tcp set packetSize_ 10000
        $ns attach-agent $n0 $tcp
        $tcp attach $tracefile
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
    set rtt $tab($i)

    puts "Création du flux $i vers $i1"
    set ftp [create_ftp $n($i) $n($i1) 0 20000 1 $tracefile($i)]

    # On affiche le rtt de ftp
    puts "RTT de ftp $i: [$ftp set rtt_]"
    $ftp set fid_ $i
}
# Pour 1, 3 et 5, on crée les flux inverses
for {set i 1} {$i < 6} {incr i 2} {
  
    set i1 [expr ($i-1)]
    set rtt $tab($i)

    puts "Création du flux $i vers $i1"
    set ftp [create_ftp $n($i) $n($i1) 0 20000 1 $tracefile($i)]
    puts "RTT de ftp $i: [$ftp set rtt_]"

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