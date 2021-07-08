# Add VirtualGL and TurboVNC
sudo apt-get install -y virtualgl
wget https://gigenet.dl.sourceforge.net/project/turbovnc/2.2.6/turbovnc_2.2.6_amd64.deb
sudo apt-get install -y `pwd`/turbovnc_2.2.6_amd64.deb
sudo apt-get install -y novnc websockify python-numpy

# Boot commands (to work with ssh -L 6908:localhost:6908 -i key -l LOGIN and then http://localhost:6908 )
mkdir /home/$myuser/.vnc
echo password | vncpasswd -f > /home/$myuser/.vnc/passwd
chown -R $myuser:$myuser /home/$myuser/.vnc
chmod 0600 /home/$myuser/.vnc/passwd
/opt/TurboVNC/bin/vncserver
websockify -D --web=/usr/share/novnc 6908 localhost:5901
