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
int init()
  {
//----
   int major[1];int minor[1];int patch[1];
   zmq_version(major,minor,patch);
   Print("Using zeromq version " + major[0] + "." + minor[0] + "." + patch[0]);
   
   Print(ping("Hello World"));
   
   context = zmq_init(1);
   listener = zmq_socket(context, ZMQ_PULL);
  
   if (zmq_connect(listener,"tcp://127.0.0.1:2028") == -1)
   {
      Print("Error binding the listener!");
      return(-1);
   }
   
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
   
   // Initialize message.
   int request[1];
   zmq_msg_init(request);
   
   while(true){
      string message2 = s_recv(listener, ZMQ_NOBLOCK);
      if (message2 != "") // Will return NULL if no message was received.
      {
         Print("Received message: " + message2);
      }else{
         break;
      }
   }
   
   return(0);
  }
//+------------------------------------------------------------------+
