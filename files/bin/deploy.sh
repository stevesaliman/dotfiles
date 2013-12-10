#!/bin/bash
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Darren Davis - 2011/10/19 
#
#   Deploy new war file:
#       (1) Verify the new war file
#       (2) Remove the old war file
#       (3) Stop tomcat service
#       (4) Copy over war file + change permission
#       (5) Start up tomcat service
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
shopt -s nocasematch
supported_envs="local dev qa stage stage1 stage2 prod prod1 prod2"

# Little helper function to see if a list contains a word
contains() {
	for word in $1; do
		[[ $word = $2 ]] && return 1
	done
	return 0
}

# use first param as an environment variable
if [ -z "$DEPLOY_ENVIRONMENT" ]; then
	  env_name=$1
fi

# Set the tomcat home
if [ -z "$TOMCAT_HOME" ]; then
	tomcat_home=/opt/tomcat
else
	tomcat_home=$TOMCAT_HOME
fi

# Set the tomcat user.
if [ -z "$TOMCAT_USER" ]; then
	# If we're deploying locally, default the tomcat user to the current user,
	# otherwise use 'tomcat'
	if [[ $env_name == local ]]; then
		if [ -z "$USER" ]; then
			"I can't figure out who you are! Please set USER"
			exit 1;
		fi
	    tomcat_user=$USER
	else
		tomcat_user=tomcat
	fi
else
	tomcat_user=$TOMCAT_USER
fi

# Set the deployment dir and make sure it exists
if [ -z "${DEPLOY_DIR}" ]; then
	deploy_dir=/data/Deploy
else
	deploy_dir=$DEPLOY_DIR
fi
if [ ! -d "$deploy_dir/bin" ]; then
	echo -e "Deploy directory $deploy_dir/bin does not exist!"
	echo -e "Have you prepared any projects?"
	exit 1
fi

# Set the data dir and make sure it exists.
if [ -z "${DATA_DIR}" ]; then
	data_dir=/data
else
	data_dir=$DATA_DIR
fi
if [ ! -d "$data_dir" ]; then
	echo -e "Data directory $data_dir does not exist!"
	exit 1
fi

max_dir=tracommax
tl_dir=tracomlearning
ssn_dir=tracomservices
deploy_dir_max=/data/Deploy/max
deploy_dir_tl=/data/Deploy/tl
deploy_dir_ssn=/data/Deploy/ssn
deploy_war_name=ROOT.war
version_name=war_version.txt

if [ -z "$env_name" ]; then
  echo -e "Unable to determine deployment environment"
  echo -e "Make sure the environment variable DEPLOY_ENVIRONMENT is set"
  echo -e "Supported options are: LOCAL, DEV, QA, STAGE or PROD"
  exit 1
fi

if contains "$supported_envs" $env_name; then
    echo -e "$env_name is not a supported environment!"
    echo -e "Supported environments are:"
	echo -e "$supported_envs"
    exit 1
fi

# Show the scripts that need to be run.
scripts=$(ls ${deploy_dir}/bin)
echo -e "About to execute the following from $deploy_dir/bin:"
for filename in $scripts; do
	echo -e "  $filename"
done;
echo -e "Tomcat runs in $tomcat_home as $tomcat_user"

echo -n "Is this correct (y or n)? "
read continue
if [[ $continue != "y" ]]; then
	echo "Aborting"
	exit 1
fi


XXX
# --- (1) Get the names of ear/war files ---
#
for filename in `ls ${deploy_dir_max} | grep war`; do
  SRC_MAX_FILE=$filename
done
if [ -z "${SRC_MAX_FILE}" ]; then
  echo -e "Unable to find Max War file in Deploy directory.  Did you run prepare from data system? "
  exit 1
fi

for filename in `ls ${deploy_dir_tl} | grep war`; do
  SRC_TL_FILE=$filename
done
if [ -z "${SRC_TL_FILE}" ]; then
  echo -e "Unable to find tracom learning war file in Deploy directory.  Did you run prepare from data system? "
  exit 1
fi

# This will find a zip or a tar...
for filename in `ls ${deploy_dir_max} | grep jasper`; do
  SRC_JASPER_FILE=$filename
done
if [ -z "${SRC_JASPER_FILE}" ]; then
  echo -e "Unable to find Jasper zip file in Deploy directory.  Did you run prepare from data system? "
  exit 1
fi

echo -e "Do you want to deploy ssn as well? (Y/N)"
read SSN_COMMAND
SSN_COMMAND="`echo $SSN_COMMAND|tr [a-z] [A-Z]`"
if [ "$SSN_COMMAND" == "Y" ]; then
  for filename in `ls ${deploy_dir_ssn} | grep war` ; do
   SRC_SSN_FILE=$filename
  done
  if [ -z "${SRC_SSN_FILE}" ]; then
    echo -e "Unable to find SSN War file in Deploy directory.  Did you run prepare from data system? "
    exit 1
  fi
  
  # This will find a zip or a tar...
  for filename in `ls ${deploy_dir_ssn} | grep advice` ; do
   SRC_SSN_ADVICE_FILE=$filename
  done
  if [ -z "${SRC_SSN_ADVICE_FILE}" ]; then
    echo -e "Unable to find SSN Advice zip file in Deploy directory.  Did you run prepare from data system? "
    exit 1
  fi
fi

# - Verify -
echo
echo -e "The Max file will be deployed --- ${SRC_MAX_FILE}"
echo -e "The Tracom Learning file will be deployed --- ${SRC_TL_FILE}"
echo -e "The Jasper zip file will be deployed --- ${SRC_JASPER_FILE}"
if [ "$SSN_COMMAND" == "Y" ]; then
  echo -e "The SSN war file will be deployed --- ${SRC_SSN_FILE}"
  echo -e "The SSN Advice zip file will be deployed --- ${SRC_SSN_ADVICE_FILE}"
fi
echo -e "\nAre they correct? Hit <Enter> to continue, Or <Ctr-C> to break\n"
read  COMMAND

# --- (2) Stop Tomcat service ---
echo -e "\n--- (2) Stop tomcat service -------------------------------- \n"
/sbin/service tomcat stop
sleep 2        # Making sure Tomcat totally stopped

# --- (3) Remove old files and directories ---
echo -e "\n--- (3) Remove old files and directories ----------------- \n"
/bin/rm -rf ${TOMCAT_HOME}/temp/*
/bin/rm -rf ${TOMCAT_HOME}/work/*
/bin/rm -rf /data/Jasper
/bin/rm -rf ${TOMCAT_HOME}/${max_dir}/*
/bin/rm -rf ${TOMCAT_HOME}/${tl_dir}/*
now=`date +%Y_%m_%d_%H%M` 
/bin/mv ${TOMCAT_HOME}/logs/catalina.out ${TOMCAT_HOME}/logs/catalina_restart_${now}.out
/bin/mv ${TOMCAT_HOME}/logs/max.log ${TOMCAT_HOME}/logs/max_log_restart_${now}.out
/bin/mv ${TOMCAT_HOME}/logs/learning.log ${TOMCAT_HOME}/logs/learning_log_restart_${now}.out
/bin/mv ${TOMCAT_HOME}/logs/ssn.log ${TOMCAT_HOME}/logs/ssn_log_restart_${now}.out

# --- (4) Copy the files ---
echo -e "\n--- (4) Copy the files ----------------------------------- \n"
JASPER_FILE=${deploy_dir_max}/${SRC_JASPER_FILE}
NEW_MAX_FILE=${deploy_dir_max}/${SRC_MAX_FILE}
NEW_TL_FILE=${deploy_dir_tl}/${SRC_TL_FILE}
DEPLOY_MAX_FILE=${TOMCAT_HOME}/${max_dir}/${deploy_war_name}
MAX_VERSION_FILE=${TOMCAT_HOME}/${max_dir}/${version_name}
DEPLOY_TL_FILE=${TOMCAT_HOME}/${tl_dir}/${deploy_war_name}
TL_VERSION_FILE=${TOMCAT_HOME}/${tl_dir}/${version_name}
echo -e "\n will copy max file ${NEW_MAX_FILE} to ${DEPLOY_MAX_FILE}"
echo -e "\n will copy tl file ${NEW_TL_FILE} to ${DEPLOY_TL_FILE}"
echo -e "\n will store version info for max at ${MAX_VERSION_FILE}"
echo -e "\n will store version info for tl at ${TL_VERSION_FILE}"
#
/bin/cp ${NEW_MAX_FILE} ${DEPLOY_MAX_FILE}
/bin/cp ${NEW_TL_FILE} ${DEPLOY_TL_FILE}
/bin/echo "maxfile: ${SRC_MAX_FILE}" >> ${MAX_VERSION_FILE}
/bin/echo "tracomlearningfile: ${SRC_TL_FILE}" >> ${TL_VERSION_FILE}
mkdir /data/Jasper
/usr/bin/unzip -d /data/Jasper ${JASPER_FILE}

/bin/echo "deploy environment: $DEPLOY_ENVIRONMENT"
if [ "$DEPLOY_ENVIRONMENT" != "LOCAL" ]; then
  /bin/echo "updating Tomcat permissions"
  chown ${TOMCAT_USER}:${TOMCAT_USER} ${DEPLOY_MAX_FILE}
  chown ${TOMCAT_USER}:${TOMCAT_USER} ${DEPLOY_TL_FILE}
  chown ${TOMCAT_USER}:${TOMCAT_USER} ${MAX_VERSION_FILE}
  chown ${TOMCAT_USER}:${TOMCAT_USER} ${TL_VERSION_FILE}
  chown -R ${TOMCAT_USER}:${TOMCAT_USER} /data/Jasper
fi
if [ "$SSN_COMMAND" == "Y" ]; then
  ADVICE_FILE=${deploy_dir_ssn}/${SRC_SSN_ADVICE_FILE}
  /bin/rm -rf /data/Advice
  mkdir /data/Advice
  /bin/rm -rf ${TOMCAT_HOME}/${ssn_dir}/*
  /usr/bin/unzip -d /data/Advice ${ADVICE_FILE}
  NEW_SSN_FILE=${deploy_dir_ssn}/${SRC_SSN_FILE}
  DEPLOY_SSN_FILE=${TOMCAT_HOME}/${ssn_dir}/${deploy_war_name}
  SSN_VERSION_FILE=${TOMCAT_HOME}/${ssn_dir}/${version_name}
  echo -e "\n will copy ssn file ${NEW_SSN_FILE} to ${DEPLOY_SSN_FILE}"
  echo -e "\n will store version info for ssn at ${SSN_VERSION_FILE}"
  /bin/cp ${NEW_SSN_FILE} ${DEPLOY_SSN_FILE}
  /bin/echo "ssnfile: ${SRC_SSN_FILE}" >> ${SSN_VERSION_FILE}
  if [ $DEPLOY_ENVIRONMENT != "LOCAL" ]; then
    chown ${TOMCAT_USER}:${TOMCAT_USER} ${DEPLOY_SSN_FILE}
    chown ${TOMCAT_USER}:${TOMCAT_USER} ${SSN_VERSION_FILE}
    chown -R ${TOMCAT_USER}:${TOMCAT_USER} /data/Advice
	fi
fi

# --- (5) Start up tomcat service ---
echo -e "\n--- (5) Start up tomcat service ---------------------------- \n"
/sbin/service tomcat start

# 
ps -ef | grep tomcat
echo -e "\nDONE.\n"

