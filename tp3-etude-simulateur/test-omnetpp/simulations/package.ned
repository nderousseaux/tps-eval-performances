package test_omnetpp.simulations;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.ethernet.Eth10M;
import inet.node.ethernet.EthernetHost;
import inet.node.ethernet.EthernetHub;
import inet.node.ethernet.EthernetSwitch;

import inet.node.inet.StandardHost;


@license(LGPL);
//
// TODO documentation
//
network Ethernet
{
    @display("bgb=845,533");
    submodules:
        s0: EthernetHost {
            @display("p=356,95");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=124,34");
        }
        s1: EthernetHost {
            @display("p=531,184");
        }
        s2: EthernetHost {
            @display("p=462,323");
        }
        s3: EthernetHost {
            @display("p=241,341");
        }
        s4: EthernetHost {
            @display("p=155,262");
        }
        s5: EthernetHost {
            @display("p=194,128");
        }
        ethernetHub: EthernetHub {
            @display("p=328.644,216.948");
        }
    connections:
        s1.ethg <--> Eth10M <--> ethernetHub.ethg++;
        s0.ethg <--> Eth10M <--> ethernetHub.ethg++;
        s5.ethg <--> Eth10M <--> ethernetHub.ethg++;
        s4.ethg <--> Eth10M <--> ethernetHub.ethg++;
        s3.ethg <--> Eth10M <--> ethernetHub.ethg++;
        s2.ethg <--> Eth10M <--> ethernetHub.ethg++;
}

