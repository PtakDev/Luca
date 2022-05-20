terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

# providers remotos
provider "docker" {
  alias = "s01"
  host  = "ssh://10.250.0.1"
}

provider "docker" {
  alias = "s02"
  host  = "ssh://10.250.0.6"
}


# definiciones de imagenes
resource "docker_image" "nginx_i1s01" {
  provider     = docker.s01
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_image" "nginx_i2s01" {
  provider     = docker.s01
  name         = "nginx:alpine"
  keep_locally = false
}

resource "docker_image" "nginx_i1s02" {
  provider     = docker.s02
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_image" "nginx_i2s02" {
  provider     = docker.s02
  name         = "nginx:alpine"
  keep_locally = false
}

# contenedores
resource "docker_container" "nginx_c1s01" {
  provider = docker.s01
  image    = docker_image.nginx_i1s01.name
  name     = "nginx_d01s01"
  ports {
    internal = 80
    external = 8210
  }
}
resource "docker_container" "nginx_c2s01" {
  provider = docker.s01
  image    = docker_image.nginx_i2s01.name
  name     = "nginx_d02s01"
  ports {
    internal = 80
    external = 8220
  }
}

resource "docker_container" "nginx_c1s02" {
  provider = docker.s02
  image    = docker_image.nginx_i1s02.name
  name     = "nginx_d01s02"
  ports {
    internal = 80
    external = 8010
  }
}
resource "docker_container" "nginx_c2s02" {
  provider = docker.s02
  image    = docker_image.nginx_i2s02.name
  name     = "nginx_d02s02"
  ports {
    internal = 80
    external = 8020
  }
}
