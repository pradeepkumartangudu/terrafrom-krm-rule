#!/bin/bash 

# Date:  01/17/2018
# Auth: Roger K. Hill - ATT - rh227x@att.com 
# Desc: ec2 instance reporting script simple 

SHORTNAME=$(hostname -s)
FQDN_NAME=$(hostname -f)
COMPANY="AT&T" 
PARAMETERS="$@"
NUMPARAMETERS="$#"
PARONE="$1"		## script mode to run in ('dryrun' or 'all')
PARTWO="$2"		## email dl or address(es) to send report to
COUNTER=0
ME=$(basename $0)
SCRIPT_VER="1.3"
LOGFILE=$SHORTNAME.$ME.$(date "+%m-%d-%Y-%H%M".log)
EBS_TOT=0 

### AWS Env config requirements ### 
export AWS_ACCESS_KEY_ID=AKIAIC4EGTXCU6Q3DEQA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-east-1

logit () {
  DATEFMT=$(date "+%m-%d-%Y %H:%M:%S")
  echo "$DATEFMT: $1" | tee -a $LOGFILE 
}

line () { 
  logit "-----------------------------------------------------" 
} 

emailLOGfile() {
  ### cat $LOGFILE | mail -s "Node :$FQDN_NAME : Yum Update Report"  
  MSG=$(cat $LOGFILE)  
  /usr/local/bin/aws sns publish --topic-arn arn:aws:sns:us-east-1:594349222397:ec2-report-att-sns --message "$MSG" 
}

clear 
logit "--- --- $COMPANY ec2 instance reporting script begin --- ---" 
line 

### main line logic ### 
LIST=$(aws ec2 describe-instances | grep "InstanceId" | awk '{print $2}' | awk -F, '{print $1}'|sed s/\"//g)
NUM_EC2_TOT=$(echo $LIST | awk '{print NF}')

logit "" 
logit "Total number of EC2 instances found : $NUM_EC2_TOT" 
logit "" 

for ec2 in $LIST 
do 
  logit "AWS EC2 Instance: $ec2 has the following details:" 

  NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values="$ec2""|grep -B1 Name|head -1|awk '{print $2}'|sed 's/\"//g'|cut -d, -f1) 
  logit "  EC2 Name=$NAME" 

  CLUSTER_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values="$ec2""|grep -B1 Cluster|head -1|awk '{print $2}'|sed 's/\"//g'|cut -d, -f1) 
  logit "  Cluster Name=$CLUSTER_NAME" 

  EC2_STATE=$(aws ec2 describe-instance-status --instance-id "$ec2"|grep -A2 "InstanceState"|tail -1|awk '{print $2}'|sed 's/\"//g')
  if [ "$EC2_STATE" == "" ];then 
    EC2_STATE="stopped" 
  fi 
  logit "  Current State=$EC2_STATE" 

  EC2_TYPE=$(aws ec2 describe-instances --instance-id "$ec2"|grep "InstanceType"|awk '{print $2}'|sed 's/\"//g'|cut -d, -f1)
  logit "  EC2 Type=$EC2_TYPE"

  EC2_EBS_VOLS=$(aws ec2 describe-instances --instance-id "$ec2"|grep VolumeId|awk '{print $2}'|cut -d, -f1|sed 's/\"//g')

  EBS_CTR=1
  EC2_EBS_TOT=0
  for ebs in $EC2_EBS_VOLS
  do 
    EBS_SIZE=$(aws ec2 describe-volumes --region us-east-1 --filters Name=attachment.instance-id,Values=$ec2 --volume-ids $ebs|grep Size|awk '{print $2}') 
    logit "  Volume No. $EBS_CTR = $ebs"
    logit "  Volume Size = $EBS_SIZE GB" 
    EBS_CTR=$(expr $EBS_CTR + 1)
    EC2_EBS_TOT=$(expr $EBS_SIZE + $EC2_EBS_TOT)   
  done 
  
  logit "  Total EBS Volumes space for $NAME EC2 instance = $EC2_EBS_TOT" 
  EBS_TOT=$(expr $EC2_EBS_TOT + $EBS_TOT)

  line 
done 

logit "Total EBS Volumes space usage = $EBS_TOT" 

line 
logit "--- --- $COMPANY ec2 instance reporting script end --- ---" 

sleep 1 

emailLOGfile 

exit 0 