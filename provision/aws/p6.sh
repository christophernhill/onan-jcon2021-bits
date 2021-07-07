# Add VirtualGL and TurboVNC
sudo apt-get install virtualgl
wget https://gigenet.dl.sourceforge.net/project/turbovnc/2.2.6/turbovnc_2.2.6_amd64.deb
sudo apt-get install `pwd`/turbovnc_2.2.6_amd64.deb
sudo apt-get install -y novnc websockify python-numpy

# Boot commands (to work with ssh -L 6908:localhost:6908 -i key -l LOGIN and then http://localhost:6908 )
/opt/TurboVNC/bin/vncserver
websockify -D --web=/usr/share/novnc 6908 localhost:5901
