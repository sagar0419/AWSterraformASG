#!/usr/bin/env bash
# Default bootstrap script
set -e -x

IPV4=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
INSTANCE_ID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`

#setting the instance id in cloudwatch config

sudo sed -i "s/INSTANCE_ID/${INSTANCE_ID}/" /opt/aws/amazon-cloudwatch-agent/bin/config.json

ZONE=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
REGION="`echo \"${ZONE}\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
HOST_PART="cloud2-test"
DOMAIN="test-private-texe.com"
DNS_NAME="fs-6bef5ba3.efs.eu-west-1.amazonaws.com"

LAST=`echo ${IPV4} |cut --delimiter=. --fields=4`
LAST2=`echo ${IPV4} |cut --delimiter=. --fields=3`

HEX=`printf '%x%x\n' ${LAST} ${LAST2}`

# Set the host name
HOST_NAME=${HOST_PART}-${ZONE}-${HEX}

aws ec2 create-tags --resources ${INSTANCE_ID} --tags 'Key=Name, Value='${HOST_NAME}'' --region=${REGION}

sudo hostnamectl set-hostname ${HOST_NAME}.${DOMAIN}

# will need to restart rsyslog so that correct name is in the messages log etc.
sudo service rsyslog restart

sudo sed -i "s/^Hostname=.*/Hostname=${HOST_NAME}-${DOMAIN}/" /etc/zabbix/zabbix_agentd.conf

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${DNS_NAME}:/ /efs