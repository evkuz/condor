#!/bin/bash

condor_status -startd \
-cons ' State =="Claimed" && Activity!=" Idle"' \
-af name | wc -l

condor_status -startd \
-cons ' State =="Unclaimed" && Activity!=" Idle"' \
-af name | wc -l

condor_status -startd \
-cons ' State =="Claimed" && Activity!=" Idle"' \
-af Cpus | st
