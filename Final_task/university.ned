package final_task;

import inet.applications.udpapp.UDPVideoStreamCli;
import inet.applications.udpapp.UDPVideoStreamSvr;
import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
import inet.nodes.ethernet.Eth100G;
//import inet.networklayer.autorouting.ipv4.FlatNetworkConfigurator;
import inet.nodes.ethernet.Eth100M;
import inet.nodes.ethernet.EtherLink;
import inet.nodes.inet.Router;
import inet.nodes.inet.StandardHost;
import inet.nodes.inet.WirelessHost;
import inet.nodes.wireless.AccessPoint;
import ned.DatarateChannel;
import ned.DelayChannel;
import ned.IdealChannel;
import inet.world.radio.ChannelControl;


//Wireless Network with HTTPStudents, FTPStudent and Video Conference Laptop
module Wireless
{
    parameters:
        int numHTTPHosts;
    gates:
        //Gate to connect module to remoteRouter (remoteR). Ethernet (Eth100M)   
        inout ethg;
    submodules:
       //Wireless Network

        whttpStudents[numHTTPHosts]: WirelessHost {
            @display("p=93,39");
            @networkNode;
        }

        whostVideoConf: WirelessHost {
            @display("p=141,219");
            @networkNode;
        }
        whostFTP: WirelessHost {
            @display("p=46,175");
            @networkNode;
        }
        accessPoint: AccessPoint {
            @display("p=127,128");
            @networkNode;
        }

    //There are connections between the nodes
    connections:
        //Access Router has a ethgInterface to outside world 
        // its the gate which connects the module to other modules
        accessPoint.ethg++ <--> ethg;

}




network University
{
    parameters:
        int numHTTPstudents = default(5);
        @display("bgl=2");
    submodules:
        wirelessNet: Wireless {
            @display("p=34,144");
            @networkNode;
        }

        remoteR: Router {
            @display("p=223,148");
            @networkNode;
        }
        mainR: Router {
            @display("p=429,146");
            @networkNode;
        }

        ccTVMonitoringHost: StandardHost {
            parameters:
                @display("i=device/pc2;p=556,276");
                @networkNode;
        }
        profLaptop: StandardHost {
            parameters:
                @display("i=device/pc2;p=285,27");
                @networkNode;
        }

        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=585,107");
        }

        channelControl: ChannelControl {
            @display("p=585,41");
            @networkNode;
        }


        Server: StandardHost {
            @display("p=525,31");
            @networkNode;
        }
        CCTV: StandardHost {
            @display("p=264,253");
        }
    connections:
        //AP und rR sind über FastEthernet verbunden. 
        // accessPoint.ethg++ <--> Eth100M <--> remoteR.ethg++;
        remoteR.ethg++ <--> Eth100M { @display("t=Eth100M"); } <--> wirelessNet.ethg;
        //remoteRouter und der Main Router sind via PPP verbunden
        remoteR.pppg++ <--> DatarateChannel {  delay = 10ms; datarate = 12Mbps; } <--> mainR.pppg++;
        profLaptop.pppg++ <--> DatarateChannel {  delay = 5ms; } <--> mainR.pppg++;
        mainR.pppg++ <--> DatarateChannel {  delay = exponential(30s); datarate = 100Mbps; } <--> Server.pppg++;
        mainR.pppg++ <--> DatarateChannel <--> ccTVMonitoringHost.pppg++;
        CCTV.ethg++ <--> Eth100G <--> remoteR.ethg++;
}
