# Add VirtualGL and TurboVNC
cd ~
sudo apt-get install -y virtualgl
wget https://gigenet.dl.sourceforge.net/project/turbovnc/2.2.6/turbovnc_2.2.6_amd64.deb
sudo apt-get install -y `pwd`/turbovnc_2.2.6_amd64.deb
sudo apt-get install -y novnc websockify python-numpy

# Boot commands (to work with ssh -L 6908:localhost:6908 -i key -l LOGIN and then http://localhost:6908 )
# note - password here is required but not for security, security is through using ssh tunnel and limiting
# port access.
mkdir /home/$USER/.vnc
echo password | /opt/TurboVNC/bin/vncpasswd -f > /home/$USER/.vnc/passwd
chown -R $USER:$USER /home/$USER/.vnc
chmod 0600 /home/$USER/.vnc/passwd
/opt/TurboVNC/bin/vncserver
websockify -D --web=/usr/share/novnc 6908 localhost:5901
