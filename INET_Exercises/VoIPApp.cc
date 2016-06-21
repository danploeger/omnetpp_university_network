/*
 * VoIPApp.cc
 *
 *  Created on: 19.06.2016
 *      Author: Daniel
 */

#include <VoIPApp.h>

VoIPApp::VoIPApp() {
    selfMsg = NULL;
}

VoIPApp::~VoIPApp() {
    cancelAndDelete(selfMsg);
}

Define_Module(VoIPApp);

//simsignal_t VoIPApp::sentPkSignal = registerSignal("sentPk");
//simsignal_t VoIPApp::rcvdPkSignal = registerSignal("rcvdPk");

void VoIPApp::sendPacket()
{
    UDPBasicApp::sendPacket();
    recordScalar("packet-departure-time", simTime());
}

void VoIPApp::processPacket(cPacket *pk)
{
<<<<<<< HEAD
    UDPBasicApp::processPacket(pk);
=======
    UDPBasicApp::processPacket(cPacket *pk);
>>>>>>> branch 'master' of C:/Users/Daniel/Dropbox/OMNeT_Git
    recordScalar("packet-arrival-time", simTime());
    recordScalar("arriving-packet-number", UDPBasicApp::numReceived);
}

