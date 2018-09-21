#/bin/bash

echo > succeeded.list
echo > failed.list
cat domain.list |while read line
do
    _nc=`nc -zv -w 5 $line 80 2>&1`
    ret=`echo $_nc | grep "succeeded"`
    if [ ! -z "$ret"  ];then
        echo "succeeded : $_nc"
        echo $line >> succeeded.list
    else
        echo "failed : $_nc"
        echo $line >> failed.list
    fi
done



或者
#/bin/bash
cat domain1.list |while read line
  do
 nc -zv -w 5 $line 80
  done
