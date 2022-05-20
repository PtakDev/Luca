
provider "docker" {
  alias = "s12002"
  host = "ssh://curso@10.250.0.122:22"
}


//VOLUMENES
#s12002_01
resource "docker_volume" "gitea_datav_s12002" {
  provider = docker.s12002
  name = "gitea_datad_s12002"
}

resource "docker_volume" "musql_datav_s12002" {
  provider = docker.s12002
  name = "mysql_datad_s12002"
}

//RED
#s12002_01
resource "docker_network" "gitea_network_s12002" {
  provider = docker.s12002
  name = "gitea_net_s12002"
}

//IMAGENES

resource "docker_image" "gitea_s12002" { //resource "<TERRAFORM_OBJECTO>" "<NOMBRE_QUE_NOS_PONEMOS>"
  provider     = docker.s12002
  name         = "gitea/gitea:latest" // imagen de dockerhub
  keep_locally = true

}

resource "docker_image" "mysql_s12002" {
  provider     = docker.s12002
  name         = "mysql:8"
  keep_locally = true
}

//CONTENEDORES

resource "docker_container" "con_sql_gitea_s12002" {
  provider = docker.s12002
  image    = docker_image.mysql_s12002.name
  name     = "con_sql_gitea_s12002"
  hostname = "con_sql_gitea_s12002"
  env = [
    "MYSQL_ROOT_PASSWORD=gitea",
    "MYSQL_USER=gitea",
    "MYSQL_PASSWORD=gitea",
    "MYSQL_DATABASE=gitea"
  ]

  networks_advanced {
    name = docker_network.gitea_network_s12002.name
  }

  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.musql_datav_s12002.name
  }

}

resource "docker_container" "gitea_s120_s12002" {
  provider = docker.s12002
  image    = docker_image.gitea_s12002.name
  name     = "gitea_s120_s12002"

  networks_advanced {
    name = docker_network.gitea_network_s12002.name
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
    "GITEA__database__HOST=con_sql_gitea_s12002:3306",
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
    volume_name = docker_volume.gitea_datav_s12002.name
  }

  depends_on = [docker_container.con_sql_gitea_s12002]
  restart    = "always"

}


