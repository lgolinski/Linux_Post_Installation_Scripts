#!/bin/bash

killall conky
sleep 20s && conky -c "/home/lukasz/.conky/lukasz.conkyrc"