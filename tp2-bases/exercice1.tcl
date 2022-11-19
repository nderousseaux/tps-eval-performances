########## Déclarations ##########

#Simulator
set ns [new Simulator]

#Trace file
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
set nCentral [$ns node]


for {set i 0} {$i < 6} {incr i} {
  $ns duplex-link $n($i) $nCentral 1Mb 1ms DropTail
}
########## Applications ##########

# On déclare un flux udp/cbr sur le noeud suivant
proc create_bcr {n0 n1 start stop} {
        global ns j
        #Flux udp
        set udp [new Agent/UDP]
        $ns attach-agent $n0 $udp
        set null [new Agent/Null]
        $ns attach-agent $n1 $null
        $ns connect $udp $null
        #Flux cbr
        set cbr [new Application/Traffic/CBR]
        $cbr set packetSize_ 20
        $cbr set interval_ 0.0001
        $cbr attach-agent $udp
        
        $ns at $start "$cbr start"
        $ns at $stop "$cbr stop"

        return $udp
}

#Pour chaque noeud
for {set i 0} {$i < 6} {incr i} {
        set i1 [expr ($i+1)%6]
        set udp [create_bcr $n($i) $n($i1) 0.1 4.5]
        $udp set fid_ $i
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

$ns duplex-link-op $n(2) $nCentral queuePos 0.5

########## RUN ##########
$ns run