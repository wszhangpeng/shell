#!/bin/bash
x2=81
#A=()
################################################
now_i=0
x=0
y=0
sum_lei=0
sum_dianji=0
################################################

print_lei()  {
clear
for((i=0;i<x2;i++))
do
        if [ $((i%9)) -eq 0 ] && [ $i -ne 0 ];then
                echo
        fi
        if [ ${A[$i]} -ge 10 ];then
                echo -n "# "
        else
                echo -n "${A[$i]} "
        fi
done
echo
}
for((i=0;i<x2;i++))
do
        A[$i]=$(($RANDOM%10))
done

for((i=0;i<x2;i++))
do
        if [ ${A[$i]} -eq 9 ];then
                continue
        fi
        lei_num=0
        for var in -10 -9 -8 -1 1 8 9 10
        do
                if [ $((i+var)) -lt 0 ] || [ $((i+var)) -gt 80 ];then
                        continue
                fi
                if [ $((i%9)) -eq 0 ];then
                        case $var in
                                -10|-1|8)
                                        continue;;
                        esac
                fi
                if [ $((i%9)) -eq 8 ];then
                        case $var in
                                -8|1|10)
                                        continue;;
                        esac
                fi
                if [ ${A[$((i+var))]} -eq 9 ];then
                        ((lei_num++))
                fi
        done
        A[$i]=$lei_num
done

for((i=0;i<x2;i++))
do
        if [ ${A[$i]} -eq 9 ];then
                ((sum_lei++))
        fi
        ((A[$i]+=10))
done

print_lei

###########################################

tput cup $x $y
stop_out() {
        if [ $x -eq -1 ];then
                x=8
                ((now_i+=81))
        elif [ $x -eq 9 ];then
                x=0
                ((now_i-=81))
        elif [ $y -eq -2 ];then
                y=16
                ((now_i+=9))
        elif [ $y -eq 18 ];then
                y=0
                ((now_i-=9))
        fi
}
leftmove() {
        ((y-=2))
        ((now_i--))
        stop_out
        print_lei
        tput cup $x $y
}
rightmove() {
        ((y+=2))
        ((now_i++))
        stop_out
        print_lei
        tput cup $x $y
}
upmove() {
        ((x--))
        ((now_i-=9))
        stop_out
        print_lei
        tput cup $x $y
}
downmove() {
        ((x++))
        ((now_i+=9))
        stop_out
        print_lei
        tput cup $x $y
}
dianji() {
        if [ ${A[$now_i]} -eq 19 ];then
                print_lei
                echo "You failure"
                exit 0
        elif [ ${A[$now_i]} -ge 10 ];then
                ((A[$now_i]-=10))
                ((sum_dianji++))
        fi
}
success() {
        ((sum=sum_lei+sum_dianji))
        if [ $sum -eq 81 ];then
                print_lei
                echo "You win!"
                exit 0
        fi
}
while [ 0 ]
do
        read -s -n1 fx
        case $fx in
        h)
        leftmove;;
        k)
        rightmove;;
        j)
        downmove;;
        u)
        upmove;;
        a)
        dianji;;
        esac
success
done