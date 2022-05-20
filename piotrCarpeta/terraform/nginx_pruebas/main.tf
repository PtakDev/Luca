terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

// Destino
provider "docker" {
  alias = "server00" # El alias ("nombre") de target
  host = "ssh://10.250.12.1:22" # Especifica el destino y tipo de conexcion.
}

// Destino
provider "docker" {
  alias = "server01" # El alias ("nombre") de target
  # Si el destino no esta especificado, el destino es el localhost
}

// Pull de imagen de nginx para la machina server00
resource "docker_image" "img_nginx_s00" {
  provider = docker.server00 # Apunta a destino (server00)
  name = "nginx:latest" # Nombre del imagen y su version
  keep_locally = true # Guarda el imagen en la machina de destino
}

// Pull de imagen de nginx para la machina server01
resource "docker_image" "img_nginx_s01" {
  provider = docker.server00 # Apunta a destino (server01)
  name = "nginx:latest" # Nombre del imagen y su version
  keep_locally = true # Guarda el imagen en la machina de destino
}

// Contenedor de nginx para la machina "servidor00"
resource "docker_container" "nginx_s00_n01" {
  provider = docker.server00 # Especifica el provedor con alias server01
  image = docker_image.img_nginx_s00.name # Especifica la imagen que necesita usar para crear el contenedor
  name  = "nginx_c1" # Nombre del contenedor
  // Puertos de contenedor
  ports {
    internal = 80
    external = 8000
  }
}

// Contenedor de nginx para la machina "servidor01"
resource "docker_container" "nginx_s01_n01" {
  provider = docker.server01 # Especifica el provedor con alias server01
  image = docker_image.img_nginx_s01.name #Especifica la imagen que necesita usar para crear el contenedor
  name  = "nginx_c1" #Nombre del contenedor
  // Puertos de contenedor
  ports {
    internal = 80
    external = 8000
  }
}

// Contenedor de nginx para la machina "servidor00"
resource "docker_container" "nginx_s00_n02" {
  provider = docker.server00 # Especifica el provedor con alias server01
  image = docker_image.img_nginx_s00.name #Especifica la imagen que necesita usar para crear el contenedor
  name  = var.caontainer02 #Nombre del contenedor declarado en variable.
  // Puertos de contenedor
  ports {
    internal = 80
    external = 8001
  }
}

// Contenedor de nginx para la machina "servidor01"
resource "docker_container" "nginx_s01_n02" {
  provider = docker.server01 # Especifica el provedor con alias server01
  image = docker_image.img_nginx_s01.name #Especifica la imagen que necesita usar para crear el contenedor
  name  = var.caontainer02 #Nombre del contenedor declarado en variable.
  // Puertos de contenedor
  ports {
    internal = 80
    external = 8001
  }
}