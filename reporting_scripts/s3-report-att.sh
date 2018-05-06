#!/bin/bash 

# Date:  01/18/2018
# Auth: Roger K. Hill - ATT - rh227x@att.com 
# Desc: s3 instance reporting script simple 

SHORTNAME=$(hostname -s)
FQDN_NAME=$(hostname -f)
COMPANY="AT&T" 
PARAMETERS="$@"
NUMPARAMETERS="$#"
PARONE="$1"		## script mode to run in ('dryrun' or 'all')
PARTWO="$2"		## email dl or address(es) to send report to
COUNTER=0
ME=$(basename $0)
SCRIPT_VER="1.4"
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
  /usr/local/bin/aws sns publish --topic-arn arn:aws:sns:us-east-1:594349222397:s3-report-att-sns --message "$MSG"
}

clear 
logit "--- --- $COMPANY s3 bucket reporting script begin --- ---" 
line 

### main line logic ### 

LIST=$(aws s3api list-buckets --query "Buckets[].Name"|sed 's/]//g'|sed 's/\[//g'|sed 's/"//g'|cut -d, -f1|sed '/^$/d')
NUM_S3_BUCKETS=$(echo $LIST|awk '{print NF}')

logit "" 
logit "Total number of AWS S3 buckets found : $NUM_S3_BUCKETS" 
logit "" 

for MyS3 in $LIST 
do 
  logit "AWS S3 Bucket: $MyS3 has the following details:" 

  S3_SIZE=$(aws s3 ls --summarize --human-readable --recursive s3://$MyS3|grep 'Size:'|awk -F: '{print $2}') 
  logit "  Size Used =$S3_SIZE" 
  S3_CHK_ENCRYTP=$(aws s3api get-bucket-encryption --bucket $MyS3 > /dev/null 2>&1;echo $?)
  if [ "$S3_CHK_ENCRYTP" != "0" ];then 
    logit "  Encryption is NOT enabled" 
  else 
    S3_ENCRY_TYPE=$(aws s3api get-bucket-encryption --bucket qa-cloudtrail-useractivity|grep -A1 -i Encryption|tail -1|cut -d: -f2|sed 's/"//g')
    logit "  Encryption \"$S3_ENCRY_TYPE\" is enabled" 
  fi 

  line 
done 

## logit "Total S3 Storage space usage = $MyS3_TOT" 

line 
logit "--- --- $COMPANY s3 bucket reporting script end --- ---" 

emailLOGfile

exit 0 
