/*
 * VoIPApp.h
 *
 *  Created on: 19.06.2016
 *      Author: Daniel Plöger
 */

#ifndef VOIPAPP_H_
#define VOIPAPP_H_

#include <UDPBasicApp.h>
#include <string>

class VoIPApp : public UDPBasicApp
{
protected:
    virtual void sendPacket();
    virtual void processPacket(cPacket *msg);
//    virtual void handleMessageWhenUp(cMessage *msg);
public:
    VoIPApp();
    ~VoIPApp();
};

#endif /* VOIPAPP_H_ */
