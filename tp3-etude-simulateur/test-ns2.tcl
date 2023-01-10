########## Déclarations ##########

#Simulator
set ns [new Simulator]

#Nam file
# set nf [open out.nam w]
# $ns namtrace-all $nf

#Finish
proc finish {} {
        global ns nf
        $ns flush-trace
        # close $nf
        # exec nam out.nam -j 0.1 -r 0.0001 &
        exit 0
}

########## Topologie ##########
for {set i 0} {$i < 6} {incr i} {
  set n($i) [$ns node]
}
set nCentral [$ns node]


for {set i 0} {$i < 6} {incr i} {
  $ns duplex-link $n($i) $nCentral 100Mb 1ms DropTail
}
########## Applications ##########

# On déclare un flux tcp sur le noeud suivant
proc create_tcp {n0 n1 start stop} {
        global ns j
        #Flux tcp
        set tcp [new Agent/TCP]
        $tcp set rtt_ 0.1
        $tcp set window_ 100
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

#Pour chaque noeud
for {set i 0} {$i < 6} {incr i} {
        set i1 [expr ($i+1)%6]
        set udp [create_tcp $n($i) $n($i1) 0 1000]
        $udp set fid_ $i
}

########## Événements ##########

$ns at 1000.0 "finish"

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