#!/bin/bash
helpFunction()
{
   echo ""
   echo -e "Invalid option has been passed to the shell script"
   echo -e "\t-p: profile Ex: dev"
   echo -e "\t-n: name of the resource" 
   echo -e "\t-r: region"
   echo -e "\t-i: instanceid"
   echo -e "\t-o: output type"
   exit 1 # Exit script after printing help
}
while getopts ":p:n:r:i:o:" opt
do
   case "$opt" in
      p ) profile="$OPTARG" ;;
      n ) resourcetype="$OPTARG" ;;
      r ) region="$OPTARG" ;;
      i ) instanceid="$OPTARG" ;;
      o ) output="$OPTARG" ;;
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
if [-n "$resourcetype"] && [ -n "$region" ]
then
    ## below command get the jsoned output for given resource type ex: cloudformation, ec2. s3 etc
	#aws resourcegroupstaggingapi get-resources --region $region --resource-type-filters $resourcetype --output $output > get-resource.json
	
    ##same as above but jq command is used to filter json output
    aws resourcegroupstaggingapi get-resources --region $region --resource-type-filters $resourcetype --output $output | jq '.ResourceTagMappingList[].Tags[] | select(.Key=="Name") | .Value' 
else
   echo ""
   echo "provide wrong deatils"
   echo ""
   exit 1
fi