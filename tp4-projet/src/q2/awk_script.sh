#!/bin/bash

# awk '{if($1 == "+") print $3 " " $11}' res/alltrace.tr > res/usefull_data/data_0.tr
awk '{if($1 == "+" && $5 == 0 && $7 == 6) print $3 " " $11}' res/alltrace.tr > res/usefull_data/data_0.tr
awk '{if($1 == "+" && $5 == 2 && $7 == 6) print $3 " " $11}' res/alltrace.tr > res/usefull_data/data_2.tr
awk '{if($1 == "+" && $5 == 4 && $7 == 6) print $3 " " $11}' res/alltrace.tr > res/usefull_data/data_4.tr
