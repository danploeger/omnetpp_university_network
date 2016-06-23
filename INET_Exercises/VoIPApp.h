/*
 * VoIPApp.h
 *
 *  Created on: 19.06.2016
 *      Author: Daniel Pl�ger
 */

#ifndef VOIPAPP_H_
#define VOIPAPP_H_

#include <UDPBasicApp.h>

class VoIPApp : public UDPBasicApp
{
protected:
    virtual void sendPacket();
    virtual void processPacket(cPacket *msg);
public:
    VoIPApp();
    ~VoIPApp();
};

#endif /* VOIPAPP_H_ */
