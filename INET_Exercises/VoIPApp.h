/*
 * VoIPApp.h
 *
 *  Created on: 19.06.2016
 *      Author: Daniel Plöger
 */

#ifndef VOIPAPP_H_
#define VOIPAPP_H_

#include <UDPBasicApp.h>

class VoIPApp : public UDPBasicApp
{
<<<<<<< HEAD
protected:
    virtual void sendPacket();
    virtual void processPacket(cPacket *msg);
=======
>>>>>>> branch 'master' of C:/Users/Daniel/Dropbox/OMNeT_Git
public:
    VoIPApp();
    ~VoIPApp();
};

#endif /* VOIPAPP_H_ */
