//+------------------------------------------------------------------+
//|                                                      mql4zmq.mq4 |
//|                                  Copyright © 2012, Austen Conrad |
//|                                                                  |
//| FOR ZEROMQ USE NOTES PLEASE REFERENCE:                           |
//|                           http://api.zeromq.org/2-1:_start       |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, Austen Conrad"
#property link      "http://www.mql4zmq.org"
#property indicator_chart_window
#property show_inputs

// Include the libzmq.dll abstration wrapper.
#include <mql4zmq.mqh>

//+------------------------------------------------------------------+
//| variable definitions                                             |
//+------------------------------------------------------------------+
int speaker,listener,context;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
bool ProperlyBinded = false;
int init()
  {
//----
   int major[1];int minor[1];int patch[1];
   zmq_version(major,minor,patch);
   Print("Using zeromq version " + major[0] + "." + minor[0] + "." + patch[0]);
   
   Print(ping("Hello World"));
   
   context = zmq_init(1);
   listener = zmq_socket(context, ZMQ_SUB);
  
   // Subscribe to the command channel (i.e. "cmd").  
   // NOTE: to subscribe to multiple channels call zmq_setsockopt multiple times.
   zmq_setsockopt(listener, ZMQ_SUBSCRIBE, "");
 
   if (zmq_bind(listener,"tcp://127.0.0.1:2028") == -1)
   {
      Print("Error binding the listener!");
      return(-1);
   }else{
      Print("Binded listener");
   }
   ProperlyBinded = true;
   
  /*
   if (zmq_connect(client,"tcp://10.18.16.16:5555") == -1)
   {
      Print("Error connecting to the client!");
      return(-1);
   }
  */

   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----

   // Protect against memory leaks on shutdown.
   zmq_close(listener);
   zmq_term(context);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
     if(!ProperlyBinded){
         return(-1);
     }
   
   
////////// We expose both the main ZeroMQ API (http://api.zeromq.org/2-1:_start) and the ZeroMQ helper functions. 
////////// Below is an example of how to receive a message from a source we are subscribed
////////// to using the main API. Then below that is an example of how to do the same thing
////////// using the helpers instead.

////////// Receive subscription data via main API //////////

   Print("try receiving");
   while(true){
      string message2 = s_recv(listener, ZMQ_NOBLOCK);
      if (message2 != "") // Will return NULL if no message was received.
      {
         Print("Received message: " + message2);
      }else{
         Print("zmq_errno()" + zmq_errno());
         break;
      }
   }
   
////////// Publish data via main API //////////
     
//----
   return(0);
  }
//+------------------------------------------------------------------+
