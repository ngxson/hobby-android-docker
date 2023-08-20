# Android inside Docker (easy version)

How to use:

Make sure you have docker installed on your system.

```bash
wget https://github.com/ngxson/hobby-android-docker/raw/main/install.sh
chmod +x ./install.sh
./install.sh
```

For help:

```
$ ./install.sh -h
Generate docker-compose for running Android inside Docker.

Syntax: install.sh [-h|g|l|s] [-p PORT] [-i IMAGE] [-d DEVICE]
options:
h     Print this Help.
g     Only generate docker-compose file and exit, do not run.
l     Print logs then exit.
s     Stop then exit.
p     Set port number; default is 6080
i     Set the image; default is 'budtmo/docker-android:emulator_11.0'
d     Set the device; default is 'Samsung Galaxy S10'
```
