//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
//

import ned.DatarateChannel;
import ned.IdealChannel;
import inet.nodes.inet.StandardHost;
import inet.networklayer.autorouting.ipv4.FlatNetworkConfigurator;
//From Hints: Import the package of the UDPBasic App to derive own subclass and model VoIP client
import inet.applications.udpapp.UDPBasicApp;

network Exercise7Current
{
    parameters:
        double ber = default(0); //Bit Error Rate
        int nInternetCloud = default(1); //Server
        int nGateway = default(1);
        int nBackbone = default(5);
        int nAccess = default(5);
        int nEndUser = default(25);
        @display("bgb=300,550");
    types:
        //TODO: Do we need this? Its Ideal connection,so its sufficient to define a connection with 
        // -->channelspec--> without delay or ber so omnet will automatically choose ned.IdealChannel
        //read :omnetppmanual 3.9.1 .
        channel gateway2internetCloud extends DatarateChannel //Ideal Connection, no delay.
        {
            datarate = 1Mbps; 	//TODO: Ideal Connection
            delay = 10ms;		//TODO: Ideal connection via Ideal channel, gives error during simulation.
        }
        channel backbone2gateway extends DatarateChannel
        {
            datarate = 10Mbps; 	
            delay = 10ms;		
        }
        channel access2backbone extends DatarateChannel
        {
            datarate = 2Mbps; 	
            delay = 15ms;		
        }
        channel endUser2access extends DatarateChannel
        {
            datarate = 64kbps; 	
            delay = 40ms;		
        }
    submodules:
        internetCloud[nInternetCloud]: StandardHost {	//TODO StandardHost?
            parameters:
                @display("p=150,50;i=device/pc3");
        }
        gateway[nGateway]: StandardHost {			//TODO
            parameters:
                @display("p=150,150;i=device/pc2");
        }
        backbone[nBackbone]: StandardHost {		//TODO
            parameters:
                @display("p=150,250;i=device/pc2");
        }
        access[nAccess]: StandardHost {			//TODO
            parameters:
                @display("p=150,350;i=device/pc2");
        }
        endUser[nEndUser]: StandardHost {			//TODO
            parameters:
                @display("p=150,450;i=device/pc2");
        }
        configurator: FlatNetworkConfigurator {
            parameters:
                @display("p=56,19");
        }
    connections:
        //TODO: pppg oder ethg??
        for k=0..nInternetCloud-1, for i=0..nGateway-1 {
            internetCloud[k].pppg++ <--> gateway2internetCloud <--> gateway[i].pppg++;
        }
        for k=0..nGateway-1, for i=0..nBackbone-1 {
            gateway[k].pppg++ <--> backbone2gateway <--> backbone[i].pppg++;
        }
        for k=0..nBackbone-1, for i=0..nAccess-1 {
            backbone[k].pppg++ <--> access2backbone <--> access[i].pppg++;
        }
        for k=0..nAccess-1, for i=0..nEndUser-1 {
            access[k].pppg++ <--> endUser2access <--> endUser[i].pppg++;
        }
}
