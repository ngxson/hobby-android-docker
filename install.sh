#!/bin/bash

EMULATOR_DEVICE="Samsung Galaxy S10"
PORT="6080"
IMAGE="budtmo/docker-android:emulator_11.0"
SHOULD_RUN="1"

if ! command -v "docker" &> /dev/null; then
  echo
  echo "ERROR: Docker is not installed on your system"
  echo "Please install it using the command below:"
  echo
  echo "curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh"
  echo
  exit 1
fi

KVM_CHECK="$(ls /dev/kvm)"
if [[ -z "$KVM_CHECK" ]]; then
  echo "ERROR: KVM is not supported on your device"
  exit 1
fi

Help()
{
  # Display Help
  echo "Generate docker-compose for running Android inside Docker."
  echo
  echo "Syntax: install.sh [-h|g|l|s] [-p PORT] [-i IMAGE] [-d DEVICE]"
  echo "options:"
  echo "h     Print this Help."
  echo "g     Only generate docker-compose file and exit, do not run."
  echo "l     Print logs then exit."
  echo "s     Stop then exit."
  echo "p     Set port number; default is 6080"
  echo "i     Set the image; default is 'budtmo/docker-android:emulator_11.0'"
  echo "d     Set the device; default is 'Samsung Galaxy S10'"
  echo
}

Logs()
{
  echo "Logs"
  docker compose logs
}

Stop()
{
  echo "Stop"
  docker compose down
}

while getopts ":ghlsp:i:d:" option; do
  case $option in
    h) # display Help
      Help
      exit;;
    l) # view log
      Logs
      exit;;
    s) # stop
      Stop
      exit;;
    g) SHOULD_RUN="0";;
    p) PORT="$OPTARG";;
    i) IMAGE="$OPTARG";;
    d) EMULATOR_DEVICE="$OPTARG";;
    \?) # Invalid option
      echo "Error: Invalid option"
      echo
      echo "Help:"
      Help
      exit;;
  esac
done

cat << EOF > docker-compose.yml
version: "3.8"
services:
  android:
    image: $IMAGE
    privileged: true
    container_name: android
    restart: unless-stopped
    devices:
      - /dev/kvm:/dev/kvm
    volumes:
      - ./data/.android:/root/.android/
      - ./data/android_emulator:/root/android_emulator
    environment:
      - EMULATOR_DEVICE="$EMULATOR_DEVICE"
      - WEB_VNC=true
  https_proxy:
    image: ngxson/https_proxy
    container_name: https_proxy
    environment:
      - TARGET=http://android:6080
    ports:
      - $PORT:443
EOF

echo "IMAGE=$IMAGE"
echo "EMULATOR_DEVICE=$EMULATOR_DEVICE"
echo "PORT=$PORT"
echo "docker-compose.yml file is generated"

if [[ "$SHOULD_RUN" == "0" ]]; then
  exit 0
else
  echo "Running: docker compose up -d"
  docker compose down > /dev/null 2>&1
  docker rm android  > /dev/null 2>&1
  docker compose up -d

  echo "Container is up: https://localhost:$PORT"
  echo "Remember to use HTTPS, not http normal"
fi
