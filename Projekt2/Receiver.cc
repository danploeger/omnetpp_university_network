
#include "Receiver.h"
#include <stdio.h>
#include <string.h>
#include <omnetpp.h>

class receiver: public cSimpleModule {

public:
    cMessage *tictocmsg;
    cMessage *event;
    simtime_t receivedTimeRecord;
    simtime_t interArrivalTime;
    cLongHistogram hopCountStats;
    cOutVector hopCountVector;

protected:
    //zwei funktionen:
    //wird einmal aufgerufen
    virtual void initialize();
    //wird jedes mal aufgerufen, wenn eine message ankommt
    //event UND normale message
    virtual void handleMessage(cMessage *msg);
};

Define_Module(receiver);

void receiver::initialize() {
    interArrivalTime = 0;
    //ob initiator oder nicht, wird in .ned/file entschieden
    if (strcmp("S", getName()) == 0) {

        EV << "Scheduling first selfMessage at 5s \n";
        cMessage *msg = new cMessage("tictocMsg");
        send(msg, "out");
    }
}
;

void receiver::handleMessage(cMessage *msg) {
    interArrivalTime = simTime() - receivedTimeRecord;
    receivedTimeRecord = simTime();

    hopCountStats.collect(interArrivalTime);
    hopCountVector.record(interArrivalTime);

    EV << interArrivalTime;
}

