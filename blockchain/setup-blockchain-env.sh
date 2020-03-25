##Install Go
sudo apt-get update
sudo apt install golang-go
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
go version

##Install Java 11 for Tessera
sudo apt install openjdk-11-jre-headless

## Install git
sudo apt-get install git

## Install make
sudo apt install make

## Download quorum
git clone https://github.com/jpmorganchase/quorum.git
cd quorum
git checkout v2.5.0
make all
sudo cp -rf build/bin/*  /usr/local/bin
cd ..
rm -rf quorum

geth version


#Fetch and install Tessera
wget https://oss.sonatype.org/service/local/repositories/releases/content/com/jpmorgan/quorum/tessera-app/0.10.4/tessera-app-0.10.4-app.jar 
sudo mv tessera-app-0.10.4-app.jar /usr/local/bin/tessera-app-0.10.4-app.jar

