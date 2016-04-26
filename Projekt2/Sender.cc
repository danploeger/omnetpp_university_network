#include "Sender.h"
#include <stdio.h>
#include <string.h>
#include <omnetpp.h>

class sender : public cSimpleModule{

public:
    cMessage *tictocmsg;
    cMessage *event;
    simtime_t interArrivalTime;
    simtime_t LastSendingTime;

    int count=0;
    int max;

protected: //zwei funktionen:
    //wird einmal aufgerufen
    virtual void initialize();
    //wird jedes mal aufgerufen, wenn eine message ankommt
    //event UND normale message
    virtual void handleMessage(cMessage *msg);



};

Define_Module(sender);

void sender :: initialize(){
    max=1000;
  //ob initiator oder nicht, wird in .ned/file entschieden
    if(strcmp("S",getName())==0){
        simtime_t delay = par("delayTime");
        EV<<"Scheduling first selfMessage at 5s \n";
        event= new cMessage("Initevent");
        //erstes event , sonst passiert nix
        scheduleAt(simTime()+delay,event);

    }
    WATCH(interArrivalTime);


};

void sender :: handleMessage(cMessage *msg){
    if(count < max){
    if(msg==event){

        simtime_t delay=par("delayTime");
        EV<<"Waiting Period is over";
        cMessage *tictocmsg = new cMessage("real message");
        send(tictocmsg,"out");
        scheduleAt(simTime()+delay,event);
        //Atm bei simTime().
        // naechste nachricht kommt bei
        //interArrivalTime = simTime()+delay - LastSendingTime;
        //LastSendingTime = simTime()+delay;



        //hopCountStats.collect(interArrivalTime);
        //hopCountVector.record(interArrivalTime);

        count++;
    }
    }


};
