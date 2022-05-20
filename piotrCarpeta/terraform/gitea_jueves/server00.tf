terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  alias = "server00"
    host = "ssh://10.250.12.3:22"
}

//VOLUMENES
#SERVER00_01
resource "docker_volume" "gitea_datav01_s00" {
  provider = docker.server00
  name = "gitea_datad"
}

resource "docker_volume" "musql_datav01_s00" {
  provider = docker.server00
  name = "mysql_datad"
}

//RED
#SERVER00_01
resource "docker_network" "gitea_network01_s00" {
  provider = docker.server00
  name = "gitea_net01_s00"
}

//IMAGENES

resource "docker_image" "gitea_s00" { //resource "<TERRAFORM_OBJECTO>" "<NOMBRE_QUE_NOS_PONEMOS>"
  provider     = docker.server00
  name         = "gitea/gitea:latest" // imagen de dockerhub
  keep_locally = true

}

resource "docker_image" "mysql_s00" {
  provider     = docker.server00
  name         = "mysql:8"
  keep_locally = true
}

//CONTENEDORES

resource "docker_container" "con_sql_gitea01_s00" {
  provider = docker.server00
  image    = docker_image.mysql_s00.name
  name     = "con_sql_gitea01_s00"
  hostname = "con_sql_gitea01_s00"
  env = [
    "MYSQL_ROOT_PASSWORD=gitea",
    "MYSQL_USER=gitea",
    "MYSQL_PASSWORD=gitea",
    "MYSQL_DATABASE=gitea"
  ]

  networks_advanced {
    name = docker_network.gitea_network01_s00.name
  }

  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.musql_datav01_s00.name
  }

}

resource "docker_container" "gitea_server00_s00" {
  provider = docker.server00
  image    = docker_image.gitea_s00.name
  name     = "gitea_server00_s00"

  networks_advanced {
    name = docker_network.gitea_network01_s00.name
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
    "GITEA__database__HOST=con_sql_gitea01_s00:3306",
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
    volume_name = docker_volume.gitea_datav01_s00.name
  }

  depends_on = [docker_container.con_sql_gitea01_s00]
  restart    = "always"

}

#SERVER00_02


//VOLUMENES
resource "docker_volume" "gitea_datav02_s00" {
  provider = docker.server00
  name = "gitea_datad1"
}

resource "docker_volume" "musql_datav02_s00" {
  provider = docker.server00
  name = "mysql_datad1"
}

//RED
resource "docker_network" "gitea_network02_s00" {
  provider = docker.server00
  name = "gitea_net02_s00"
}

//CONTENEDORES
resource "docker_container" "con_sql_gitea02_s00" {
  provider = docker.server00
  image    = docker_image.mysql_s00.name
  name     = "con_sql_gitea02_s00"
  hostname = "con_sql_gitea02_s00"
  env = [
    "MYSQL_ROOT_PASSWORD=gitea",
    "MYSQL_USER=gitea",
    "MYSQL_PASSWORD=gitea",
    "MYSQL_DATABASE=gitea"
  ]

  networks_advanced {
    name = docker_network.gitea_network02_s00.name
  }

  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.musql_datav02_s00.name
  }

}

resource "docker_container" "gitea_server02_s00" {
  provider = docker.server00
  image    = docker_image.gitea_s00.name
  name     = "gitea_server02_s00"

  networks_advanced {
    name = docker_network.gitea_network02_s00.name
  }

  ports {
    internal = 22
    external = 2122
  }
  ports {
    internal = 3000
    external = 3102
  }
  env = [
    "USER_UID=1000",
    "USER_GID=1000",
    "GITEA__database__DB_TYPE=mysql",
    "GITEA__database__HOST=con_sql_gitea02_s00:3306",
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
    volume_name = docker_volume.gitea_datav02_s00.name
  }

  depends_on = [docker_container.con_sql_gitea02_s00]
  restart    = "always"

}

