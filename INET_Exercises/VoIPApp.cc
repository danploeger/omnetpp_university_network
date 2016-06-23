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
    UDPBasicApp::processPacket(pk);
    recordScalar("packet-arrival-time", simTime());
    recordScalar("arriving-packet-number", UDPBasicApp::numReceived);
}

