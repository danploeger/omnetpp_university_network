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

import inet.nodes.ethernet.EtherSwitch;
//import inet.nodes.ethernet.EtherLink;
import inet.nodes.inet.StandardHost;
import inet.nodes.inet.WirelessHost;
import inet.nodes.wireless.AccessPoint;
import inet.nodes.ethernet.Eth1G;
import inet.networklayer.autorouting.ipv4.FlatNetworkConfigurator;

//
// TODO auto-generated type
//



network Exercise8
{
   

    submodules:
        accessPoint: AccessPoint {
            @display("p=54,87");
        }
        StationA: WirelessHost {
            @display("p=135,26");
        }
        SwitchRouter: EtherSwitch {
            @display("p=224,83");
        }
        StationB: StandardHost {
            @display("p=392,83");
        }
        configurator: FlatNetworkConfigurator {
          
        }

    connections:
        
        StationB.ethg++<--> Eth1G <--> SwitchRouter.ethg++;
        SwitchRouter.ethg++ <--> Eth1G <--> accessPoint.ethg++;
       
}
