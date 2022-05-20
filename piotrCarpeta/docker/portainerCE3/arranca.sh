docker run -d -p 8002:8000 -p 9445:9443 --name portainer3 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data3:/data portainer/portainer-ce:2.11.1
