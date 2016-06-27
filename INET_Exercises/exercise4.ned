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
//import inet.util.NetAnimTrace;
import inet.nodes.inet.StandardHost;
import inet.networklayer.autorouting.ipv4.FlatNetworkConfigurator;

network Exercise4
{
    parameters:
        double ber = default(0);
        @display("bgb=232,193");
        double datarateParam @unit(bps) = default(0bps); // bits per second; 0=infinite
    types:
        channel C extends DatarateChannel
        {
            datarate = datarateParam;
            delay = 200ms;
            ber = pow(10, -7);
        }
    submodules:
        client: StandardHost {
            parameters:
                @display("p=53,67;i=device/pc3");
        }
        server: StandardHost {
            parameters:
                @display("p=181,67;i=device/pc2");
        }
        configurator: FlatNetworkConfigurator {
            parameters:
                @display("p=53,134");
        }
//        netAnimTrace: NetAnimTrace {
//            @display("p=184,142");
//        }
    connections:
        client.pppg++ <--> C <--> server.pppg++;
}
