#!/bin/bash
 
for attr in 0 1 2 4 5 7 8 9; do
    for fgcolor in 30 31 32 33 34 35 36 37; do
        for bgcolor in 40 41 42 43 44 45 46 47; do
             printf '\e[%s;%s;%sm %1s;%02s;%02s ' $attr $fgcolor $bgcolor $attr $fgcolor $bgcolor
        done
        printf '\e[0;37;40m\n'
    done
    printf '\n'
done
