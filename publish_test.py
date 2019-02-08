#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 zenbook <zenbook@zenbook-XPS>
#
# Distributed under terms of the MIT license.

"""

"""
import time
import zmq


def producer():
    context = zmq.Context()
    zmq_socket = context.socket(zmq.PUB)
    zmq_socket.bind("tcp://*:2028")
    # Start your result manager and workers before you start your producers
    while True:
        print('send message')
        zmq_socket.send(b'sending change message')
        time.sleep(1)


producer()
