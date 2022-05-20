terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  alias = "server01"
  # host = "ssh://10.250.12.1:22"
}

//VOLUMENES

resource "docker_volume" "gitea_datav" {
  provider = docker.server01
  name = "gitea_datad"
}

resource "docker_volume" "mysql_datav" {
  provider = docker.server01
  name = "mysql_datad"
}

//RED

resource "docker_network" "gitea_network" {
  provider = docker.server01
  name = "gitea_net"
}

//IMAGENES

resource "docker_image" "gitea_s01" { //resource "<TERRAFORM_OBJECTO>" "<NOMBRE_QUE_NOS_PONEMOS>"
  provider     = docker.server01
  name         = "gitea/gitea:latest" // imagen de dockerhub
  keep_locally = true

}

resource "docker_image" "mysql_s01" {
  provider     = docker.server01
  name         = "mysql:8"
  keep_locally = true
}

//CONTENEDORES

resource "docker_container" "sql_gitea_s01" {
  provider = docker.server01
  image    = docker_image.mysql_s01.name
  name     = "sql_gitea_s01"
  hostname = "sql_gitea_s01"
  env = [
    "MYSQL_ROOT_PASSWORD=gitea",
    "MYSQL_USER=gitea",
    "MYSQL_PASSWORD=gitea",
    "MYSQL_DATABASE=gitea"
  ]

  networks_advanced {
    name = docker_network.gitea_network.name
  }

  # ports {
  #   internal = 3306
  #   external = 3306
  # }

  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.mysql_datav.name
  }

}

resource "docker_container" "gitea_server_s01" {
  provider = docker.server01
  image    = docker_image.gitea_s01.name
  name     = "gitea_server_s01"

  networks_advanced {
    name = docker_network.gitea_network.name
  }

  ports {
    internal = 22
    external = 222+1
  }
  ports {
    internal = 3000
    external = 3000+1
  }
  env = [
    "USER_UID=1000",
    "USER_GID=1000",
    "GITEA__database__DB_TYPE=mysql",
    "GITEA__database__HOST=sql_gitea_s01:3306",
    "GITEA__database__NAME=gitea",
    "GITEA__database__USER=gitea",
    "GITEA__database__PASSWD=gitea"
  ]

  volumes {
    container_path = "/etc/timezone"
    host_path      = "/etc/timezone"
    read_only      = true
  }

  volumes {
    container_path = "/etc/localtime"
    host_path      = "/etc/localtime"
    read_only      = true
  }

  volumes {
    container_path = "/data"
    volume_name = docker_volume.gitea_datav.name
  }

  depends_on = [docker_container.sql_gitea_s01]
  restart    = "always"

}

