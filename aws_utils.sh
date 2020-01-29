function get_ip_address {
        #echo $1
        #aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" --query 'Reservations[].Instances[].PublicIpAddress'
        IPADDRESSES=`aws ec2 describe-instances --region $2 --filters "Name=tag:Name,Values=$1" --query 'Reservations[].Instances[].PublicIpAddress'| grep -o '".*"'`

        #echo $IPADDRESSES
        IPSCOUNT=`echo "$IPADDRESSES" | wc -l`
        #echo "IPS Count is " $IPSCOUNT
        if [ $IPSCOUNT -ne 1 ]; then
                #echo "Multiple or no ip found"
                return 2
        fi

        IPWITHOUTQUOTE=`echo $IPADDRESSES | tr -d '"'`
        #echo "IP is " $IPWITHOUTQUOTE

        echo $IPWITHOUTQUOTE
        return 0
}

function get_instance_id {
        #echo $1
        #aws ec2 describe-instances --region $2 --filters "Name=tag:Name,Values=$1" --query 'Reservations[].Instances[].InstanceId'
        ID=`aws ec2 describe-instances --region $2 --filters "Name=tag:Name,Values=$1" --query 'Reservations[].Instances[].InstanceId'| grep -o '".*"'`

        #echo $IPADDRESSES
        IDSCOUNT=`echo "$ID" | wc -l`
        #echo "IPS Count is " $IPSCOUNT
        if [ $IDSCOUNT -ne 1 ]; then
                #echo "Multiple or no instances found"
                return 2
        fi

        IDWITHOUTQUOTE=`echo $ID | tr -d '"'`
        #echo "IP is " $IPWITHOUTQUOTE

        echo $IDWITHOUTQUOTE
        return 0
}

function start_stop_instance {
COMMAND=$1
NAME=$2
REGION=$3
ID=$(get_instance_id $NAME $REGION)

if [ "$ID" != "" ]; then
        echo "Instance id is " $ID
        if [ "$COMMAND" == "start" ];then
                echo "starting instances"
                aws ec2 start-instances --region $REGION --instance-ids $ID
        elif [ "$COMMAND" == "stop" ];then
                echo "stopping instances"
                aws ec2 stop-instances --region $REGION --instance-ids $ID
        fi
fi
}


