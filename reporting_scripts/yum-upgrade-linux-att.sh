#!/bin/bash 

# Date:  01/15/2018
# Auth: Roger K. Hill - ATT - rh227x@att.com 
# Desc: automate yum upgrade to system, run manually or in cronbtab  , tested on rhel7 

SHORTNAME=$(hostname -s)
FQDN_NAME=$(hostname -f)
COMPANY="AT&T" 
PARAMETERS="$@"
NUMPARAMETERS="$#"
PARONE="$1"		## script mode to run in ('dryrun' or 'all')
PARTWO="$2"		## email dl or address(es) to send report to
COUNTER=0
ME=$(basename $0)
SCRIPT_VER="1.1"
#LOGFILE="$HOME/$ME.$DDMMYY.log"
LOGFILE=$SHORTNAME.$ME.$(date "+%m-%d-%Y-%H%M".log)

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
  /usr/local/bin/aws sns publish --topic-arn arn:aws:sns:us-east-1:594349222397:yum-upgrade-linux-att-sns --message "$MSG" 
}

clear 
logit "--- --- $COMPANY linux yum upgrade script : begin --- ---" 
line 

### main line logic ### 
if [ "$PARONE" == "--dryrun" -o "$PARONE" == "--DRYRUN" ];then 
	logit "Yum update \"dryrun\" mode only, displaying packages that needed to be updated:" 
	/bin/yum check-update | tee -a $LOGFILE 
	if [ "$?" != "0" ];then 
 	  logit "Error or problem with \"yum check-update\" command [ ERROR ]" 
 	else 
 	  logit "Command \"yum check-update\" completed successfully [ OK ]" 
  	fi 

elif [ "$PARONE" == "--all" -o "$PARONE" == "--ALL" ];then 	
	logit "Yum update all, updating all available packages:" 
	#/bin/yum update -y | tee -a $LOGFILE	## too long sometimes for aws sns to process 
	/bin/yum update -y 
        if [ "$?" != "0" ];then
          logit "Error or problem with \"yum update -y\" command [ ERROR ]"
        else
          logit "Command \"yum update -y\" completed successfully [ OK ]"
        fi

else 
    	logit "Please pass in 2 parameters;	 parameter 1 = \"--dryrun\" or \"--all\" " 
  	logit "					 parameter 2 = \"--emailaddr=<rh227x@att.cpom>" 
fi 

line 
logit "--- --- $COMPANY linux yum upgrade script : end --- ---" 

sleep 1 

if [ "$PARTWO" == "--noemail" ];then 
  echo "No log will be sent to the SNS topic \"arn:aws:sns:us-east-1:594349222397:yum-upgrade-linux-att-sns\" " 
else 
  emailLOGfile
fi 

exit 0 
