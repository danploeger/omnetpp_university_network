#include "Sender.h"
#include <stdio.h>
#include <string.h>
#include <omnetpp.h>

class sender: public cSimpleModule {

public:
    cMessage *tictocmsg;
    cMessage *event;
    simtime_t interArrivalTime;
    simtime_t LastSendingTime;

    int count = 0;
    int max;

protected:
    //zwei funktionen:
    //wird einmal aufgerufen
    virtual void initialize();
    //wird jedes mal aufgerufen, wenn eine message ankommt
    //event UND normale message
    virtual void handleMessage(cMessage *msg);
};

Define_Module(sender);

long long getLcgRandomNumber() {
    static long long s_delayTime = 1;
    long long temporalDelayTime = (16807 * s_delayTime)
            % ((long long) pow(2, 31) - 1);
    s_delayTime = temporalDelayTime;
    return temporalDelayTime;
}

/**
 * Returns a uniform distribution within the range "from", "to" seconds ("from" < "to")
 */
simtime_t uniformDist(double from, double to) {
    double uniform = (double) ((to - from) * getLcgRandomNumber()
            / (pow(2, 31) - 1));
    return SimTime(from + uniform);
}

/**
 * Returns a negative exponential distribution with the rate parameter "rate"
 */
simtime_t exponentialDist(double rate) {
    double exponentialDist = log(1 - uniformDist(0, 1).dbl()) / (-rate);
    return SimTime(exponentialDist);
}

void sender::initialize() {
    max = 1000;
    //ob initiator oder nicht, wird in .ned/file entschieden
    if (strcmp("S", getName()) == 0) {
        EV << "Scheduling first selfMessage at 5s \n";
        event = new cMessage("Sender event");
        //erstes event , sonst passiert nix
        simtime_t delay = uniformDist(0, 1);
        scheduleAt(simTime() + delay, event);
    }
    WATCH(interArrivalTime);
}
;

void sender::handleMessage(cMessage *msg) {
    if (count < max) {
        if (msg == event) {
            EV << "Waiting Period is over";
            cMessage *tictocmsg = new cMessage("real message");
            send(tictocmsg, "out");
            simtime_t delay = exponentialDist(1);
            scheduleAt(simTime() + delay, event);
            //Atm bei simTime().
            // naechste nachricht kommt bei
            //interArrivalTime = simTime()+delay - LastSendingTime;
            //LastSendingTime = simTime()+delay;
            //hopCountStats.collect(interArrivalTime);
            //hopCountVector.record(interArrivalTime);

            count++;
        }
    }
}
;
