docker run -d -p 8001:8000 -p 9444:9443 --name portainer2 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data2:/data portainer/portainer-ce:2.11.1
