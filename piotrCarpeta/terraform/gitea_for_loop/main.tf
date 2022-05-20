terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

provider "docker" {
  alias = "server01" # El alias ("nombre") de target

}

resource "docker_image" "mysql_server01" {
  provider     = docker.server01
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_image" "gitea_server01" { 
  provider     = docker.server01
  name         = "gitea/gitea:latest" 
  keep_locally = true

}

resource "docker_volume" "sql_01_server01" {
  provider = docker.server01
  for_each = var.names_s01
  name= "sql_data_${each.key}"
}

resource "docker_volume" "gitea_01_server01" {
  provider = docker.server01
  for_each = var.names_s01
  name= "gitea_data_${each.key}"
}

resource "docker_network" "gitea_network_server01" {
  provider = docker.server01
  for_each = var.names_s01
  name= "gitea_net_${each.key}"
}

resource "docker_container" "sql_gitea_server01" {
  provider = docker.server01
  image    = docker_image.mysql_server01.name
  for_each = var.names_s01
  name     = "sql_${each.key}"
  hostname = "sql_${each.key}"
  env = [
    "MYSQL_ROOT_PASSWORD=gitea",
    "MYSQL_USER=gitea",
    "MYSQL_PASSWORD=gitea",
    "MYSQL_DATABASE=gitea"
  ]

  networks_advanced {
    name = "gitea_net_${each.key}"
  }


  volumes {
    container_path = "/var/lib/mysql"
    volume_name = "sql_data_${each.key}"
  }
  restart    = "always"

}

resource "docker_container" "gitea_server_s01" {
  provider = docker.server01
  image    = docker_image.gitea_server01.name
  for_each = var.names_s01
  name     = "gitea_${each.key}"

  networks_advanced {
    name = "gitea_net_${each.key}"
  }

  ports {
    internal = 22
    external = 222 + each.value
  }
  ports {
    internal = 3000
    external = 3000 + each.value
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
    volume_name = "gitea_data_${each.key}"
  }

  depends_on = []
  restart    = "always"

}