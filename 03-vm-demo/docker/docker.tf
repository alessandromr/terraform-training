
resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_container" "nginx" {
  image    = docker_image.nginx.image_id
  name     = "nginx"
  must_run = true

  ports {
    internal = 80
    external = 80
  }
}
