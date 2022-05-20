terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  alias = "s12001"
  host = "ssh://curso@10.250.0.121:22"
}


//VOLUMENES
#s12001_01
resource "docker_volume" "gitea_datav_s12001" {
  provider = docker.s12001
  name = "gitea_datad_s12001"
}

resource "docker_volume" "musql_datav_s12001" {
  provider = docker.s12001
  name = "mysql_datad_s12001"
}

//RED
#s12001_01
resource "docker_network" "gitea_network_s12001" {
  provider = docker.s12001
  name = "gitea_net_s12001"
}

//IMAGENES

resource "docker_image" "gitea_s12001" { //resource "<TERRAFORM_OBJECTO>" "<NOMBRE_QUE_NOS_PONEMOS>"
  provider     = docker.s12001
  name         = "gitea/gitea:latest" // imagen de dockerhub
  keep_locally = true

}

resource "docker_image" "mysql_s12001" {
  provider     = docker.s12001
  name         = "mysql:8"
  keep_locally = true
}

//CONTENEDORES

resource "docker_container" "con_sql_gitea_s12001" {
  provider = docker.s12001
  image    = docker_image.mysql_s12001.name
  name     = "con_sql_gitea_s12001"
  hostname = "con_sql_gitea_s12001"
  env = [
    "MYSQL_ROOT_PASSWORD=gitea",
    "MYSQL_USER=gitea",
    "MYSQL_PASSWORD=gitea",
    "MYSQL_DATABASE=gitea"
  ]

  networks_advanced {
    name = docker_network.gitea_network_s12001.name
  }

  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.musql_datav_s12001.name
  }

}

resource "docker_container" "gitea_s120_s12001" {
  provider = docker.s12001
  image    = docker_image.gitea_s12001.name
  name     = "gitea_s120_s12001"

  networks_advanced {
    name = docker_network.gitea_network_s12001.name
  }

  ports {
    internal = 22
    external = 2121
  }
  ports {
    internal = 3000
    external = 3101
  }
  env = [
    "USER_UID=1000",
    "USER_GID=1000",
    "GITEA__database__DB_TYPE=mysql",
    "GITEA__database__HOST=con_sql_gitea_s12001:3306",
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
    volume_name = docker_volume.gitea_datav_s12001.name
  }

  depends_on = [docker_container.con_sql_gitea_s12001]
  restart    = "always"

}


