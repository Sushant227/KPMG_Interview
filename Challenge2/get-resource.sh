#!/bin/bash
helpFunction()
{
   echo ""
   echo -e "Invalid option has been passed to the shell script"
   echo -e "\t-p: profile Ex: dev" 
   echo -e "\t-r: region"
   echo -e "\t-i: instanceid"
   exit 1 # Exit script after printing help
}
while getopts ":p:n:r:i:o:" opt
do
   case "$opt" in
      p ) profile="$OPTARG" ;;
      r ) region="$OPTARG" ;;
      i ) instanceid="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done
if [ -n "$profile" ]
then
   export AWS_PROFILE="$profile"
   echo "AWS_PROFILE has been set to $AWS_PROFILE"
   echo ""
else
   echo ""
   echo "No profile has been set exit from shell"
   echo ""
   exit 1
fi
if [ -n "$region" ]
then
   ##provide instance id and the below command gets the jsoned formated instance metadata 
	aws ec2 describe-instances --instance-id $instanceid #--filters "Name=instance-type,Values=t2.micro" # --query "Reservations[*].Instances[*].InstanceId" #.BlockDeviceMappings[*].Ebs"
else
   echo ""
   echo "provide wrong deatils"
   echo ""
   exit 1
fi