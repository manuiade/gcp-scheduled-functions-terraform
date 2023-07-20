#!/bin/bash


x=2
y=$1

while [[ $x -le $y ]]
do
    let LIMIT=$x-1
    for ((a=2; a <= LIMIT ; a++))
        do
            let check=$x%$a
            if [[ $check -eq 0 ]]
            then
                    #echo "$x is not prime"
                    break
            fi
        done
    if [[ $a -gt $LIMIT ]]
    then
        echo "$x is a prime number"
    fi
    let x=$x+1
done