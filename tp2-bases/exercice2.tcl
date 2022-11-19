########## Déclarations ##########

#Simulator
set ns [new Simulator]

#Trace file for all senders
for { set i 0 } { $i < 6 } { incr i 2 } {
    set tracefile($i) [open "tracefile-$i.tr" w]
}

set tf [open out.tr w]
$ns trace-all $tf

#Nam file
set nf [open out.nam w]
$ns namtrace-all $nf

#Finish
proc finish {} {
        global ns nf tf
        $ns flush-trace
        close $nf
        close $tf
        exec nam out.nam -j 0.1 -r 0.0001 &
        exit 0
}

########## Topologie ##########
for {set i 0} {$i < 6} {incr i} {
  set n($i) [$ns node]
}
set nPair [$ns node]
set nImpair [$ns node]

for {set i 0} {$i < 6} {incr i} {
  if {$i % 2 == 0} {
    $ns duplex-link $n($i) $nPair 10Mb 1ms DropTail
  } else {
    $ns duplex-link $n($i) $nImpair 10Mb 2ms DropTail
  }
}
$ns duplex-link $nPair $nImpair 10Mb 1ms DropTail 

########## Applications ##########

# On déclare un flux tcp/ftp sur le noeud suivant
proc create_ftp {n0 n1 start stop rtt tracefile} {
        global ns j
        #Flux tcp
        set tcp [new Agent/TCP]
        $tcp set rtt_ $rtt
        $tcp set window_ 100 
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
    set ftp [create_ftp $n($i) $n($i1) 0.1 4.5 0.$i $tracefile($i)]
    $ftp set fid_ $i
}

########## Événements ##########

$ns at 5.0 "finish"

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

$ns duplex-link-op $nPair $nImpair queuePos 0.5

########## RUN ##########
$ns run