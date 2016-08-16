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

network University
{
    parameters:
        int numHTTPHosts = default(0);
        @display("bgl=2;bgb=940,606");
    submodules:
        remoteR: Router {
            @display("p=428,316");
            @networkNode;
        }
        mainR: Router {
            @display("p=593,157");
            @networkNode;
        }

        ccTVMonitoringHost: StandardHost {
            parameters:
                @display("i=device/pc2;p=790,231");
                @networkNode;
        }
        profLaptop: StandardHost {
            parameters:
                @display("i=device/pc2;p=467,57");
                @networkNode;
        }

        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=878,43");
        }

        channelControl: ChannelControl {
            @display("p=880,121");
            @networkNode;
        }


        Server: StandardHost {
            @display("p=687,57");
            @networkNode;
        }
        CCTV: StandardHost {
            @display("p=688,424");
        }
        whttpStudents[numHTTPHosts]: WirelessHost {
            @display("p=102,531");
            @networkNode;
        }

        whostVideoConf: WirelessHost {
            @display("p=176,323");
            @networkNode;
        }
        whostFTP: WirelessHost {
            @display("p=374,534");
            @networkNode;
        }
        accessPoint: AccessPoint {
            @display("p=272,452");
            @networkNode;
        }
    connections:
        //AP und rR sind über FastEthernet verbunden. 
        accessPoint.ethg++ <--> Eth100M <--> remoteR.ethg++;
        //remoteRouter und der Main Router sind via PPP verbunden
        remoteR.pppg++ <--> radioLink: DatarateChannel {  delay = 10ms; datarate = 12Mbps; } <--> mainR.pppg++;
        profLaptop.pppg++ <--> DatarateChannel {  delay = 5ms; } <--> mainR.pppg++;
        mainR.pppg++ <--> DatarateChannel {  delay = exponential(30ms); datarate = 100Mbps; } <--> Server.pppg++;
        mainR.pppg++ <--> DatarateChannel <--> ccTVMonitoringHost.pppg++;
        CCTV.ethg++ <--> Eth100G <--> remoteR.ethg++;
}
