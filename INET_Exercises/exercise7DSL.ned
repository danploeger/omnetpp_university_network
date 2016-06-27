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
import inet.nodes.inet.Router;
import inet.networklayer.autorouting.ipv4.FlatNetworkConfigurator;
//From Hints: Import the package of the UDPBasic App to derive own subclass and model VoIP client
import inet.applications.udpapp.UDPBasicApp;

//1 Server, 1 Gateway, 5 Backbone Router , 25 Access router, 5*25 user=125 user
//Network describing the Current Network as given in the task Description
//The below code defines a network type named Exercise7Current

   //Define own channel types for the different connections
  //dialup via ISDN ,40ms propagation delay,64kbps


//----Define Smaller network components as module types that will be connected via routers to bigger network.--
//Connection via ppp
module accessNetworkDSL
{
    //A module type subnet has parameters for its submodules.
    parameters:
        int nEndUser = default(25);//number of end users connected to the AccessRouter
       
    gates:
        //Gate to connect module to other routers.Therefore ppp    
        inout pppg;
 
        
    submodules:
        accessRouter: Router {
            @display("i=abstract/router");
        }
        client[nEndUser]: StandardHost {
            @display("is=s;p=100,36");
        }

    //There are connections between the nodes
    connections:
        //Router is connected to each host via ethernet
        for i=0..nEndUser-1 {
            accessRouter.pppg++ <--> dialupDSL <--> client[i].pppg++;
        }
      

        accessRouter.pppg++ <--> pppg;//Access Router has a port(ppp) to outside world / its the gate which connects the module to other modules
}






















//Backbone network consists of a backbone router who connects to a number (nAccessNet) of access networks.

module backboneNetworkDSL
{
    parameters:
        int nAccessNet = default(5);//Number of Access Networks connected to the BackboneRouter
    gates:
        //Gate to connect    
        inout pppg;
    submodules:
        backboneRouter: Router {
            @display("i=abstract/router;p=207,75");
        }
        accessNet[nAccessNet]: accessNetworkDSL {
            @display("p=70,75");
        }
    connections:
        //Backbone Router is connected to a number of AccessrouterNetworks via their respective routers.
        //Therefore ppp
        for i=0..nAccessNet-1 {
            backboneRouter.pppg++ <--> access2backbone <--> accessNet[i].pppg;
        }
        backboneRouter.pppg++ <--> pppg;//Connection to the outside world. With this we connect to other modules
}
//
//










////
//////Module 
//////Network that gets it all together
network exercise7DSL
{
    parameters:

        //int nAccessNets = default(2);//Number of Acces Nets
        int nBackboneNet = default(5); //Number of Backbone networks connected to gateway
        int nGateway = default(1);

    submodules:
        //Modules of type AccessNetwork
        //accessNet[nAccessNets]: accessNetwork;
        backboneNet[nBackboneNet]: backboneNetwork {
            @display("p=261,73");
        }
        //One gateway
        gateway: Router {
            @display("i=abstract/router;p=188,154");
        }
//        client: StandardHost {
//            @display("is=s;p=482,135");
//        }
        server: StandardHost {

            @display("p=576,220;i=device/server_l");
        }
//
//        backboneRouter: Router {
//            @display("i=abstract/router;p=96,73");
//        }
        configurator: FlatNetworkConfigurator{
            parameters:
                @display("p=53,134");
        }
    connections:

        //Connect BackboneNetworks to Gatewayrouter
        for i=0..nBackboneNet-1 {
            gateway.pppg++ <--> backbone2gateway <--> backboneNet[i].pppg;
        }
             gateway.pppg++ <--> gateway2server <--> server.pppg++;



}
    
   