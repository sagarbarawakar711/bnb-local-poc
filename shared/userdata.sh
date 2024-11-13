exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -euxo pipefail

echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1m >> /etc/ecs/ecs.config
echo ECS_IMAGE_CLEANUP_INTERVAL=10m >> /etc/ecs/ecs.config
echo ECS_IMAGE_MINIMUM_CLEANUP_AGE=1m >> /etc/ecs/ecs.config
echo ECS_CONTAINER_STOP_TIMEOUT=5s >> /etc/ecs/ecs.config
echo ECS_IMAGE_PULL_BEHAVIOR=once >> /etc/ecs/ecs.config

export DOCKER_CONTENT_TRUST=0 


AZ=$(wget http://169.254.169.254/latest/meta-data/placement/availability-zone -qO -)
Instance=$(wget http://169.254.169.254/latest/meta-data/local-ipv4 -qO - | awk -F . '{ print $3"-"$4}')
Instanceip=$(wget http://169.254.169.254/latest/meta-data/local-ipv4 -qO -)
instance_id=$(wget http://169.254.169.254/latest/meta-data/instance-id -qO -)
USER_DATA=$(wget http://169.254.169.254/latest/user-data -qO -)
REGION=$(wget http://169.254.169.254/latest/meta-data/placement/region -qO -)

Environment="${Environment}"
Application="${Application}"
Account="${Account}"


#construct Hostname
Hostname=$Account-$Application-$Environment-$Instance
echo "$Hostname" > /etc/hostname
hostname "$Hostname"
echo HOSTNAME="$Hostname"/ >> /etc/sysconfig/network
sed -i "s/HOSTNAME=.*$/HOSTNAME=$Hostname/" /etc/sysconfig/network
echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
echo "$Instanceip  $Hostname" >> /etc/hosts

#Instance Tagging
aws ec2 create-tags --resources "$instance_id" --tags \
Key=Name,Value="$AZ"-"$Application"-"$Environment"-"$Instance" --region "$REGION"

################################
###### Artifactory v7  #########
################################
echo "0xDockerReadOnly" | docker login -u "svc_docker_read_only" --password-stdin repo.mhe.io

echo "Userdata Completed Successfully"