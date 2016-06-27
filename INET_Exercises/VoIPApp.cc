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

//void VoIPApp::handleMessageWhenUp(cMessage *msg)
//{
//    UDPBasicApp::handleMessageWhenUp(msg);
//    if (msg->isSelfMessage())
//    {
//        recordScalar("packet-selfmessage-time", simTime());
//    } else {
//        char message[80];
//
//        sprintf(message, "packet-%d-time", (int)selfMsg->getKind());
////        strcpy(message, "packet-");
////        strcat(message, "%d", (int)selfMsg->getKind());
////        strcat(message, "-time");
//        recordScalar(message, simTime());
//    }
//}
