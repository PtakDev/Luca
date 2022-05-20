docker run -d -p 8003:8000 -p 9446:9443 --name portainer4 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data4:/data portainer/portainer-ce:2.11.0
