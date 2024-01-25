terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.104.0"
    }
  }
}


provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = pathexpand("~/.ssh/authorized_key.json")
  zone                     = "ru-central1-a"
}

resource "yandex_vpc_address" "addr" {
  name = "vm-adress"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}


resource "yandex_vpc_network" "network" {
  name = "sf_network"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.7.0/24"]
}

resource "yandex_compute_instance" "vm" {
  name                      = "vm1"
  allow_stopping_for_update = true
  zone                      = "ru-central1-a"
  resources {

    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet1.id
    nat            = true
    nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}
#VM2
resource "yandex_vpc_address" "addr2" {
  name = "vm-adress2"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}
resource "yandex_compute_instance" "vm2" {
  name                      = "vm2"
  allow_stopping_for_update = true
  zone                      = "ru-central1-a"
  resources {

    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet1.id
    nat            = true
    nat_ip_address = yandex_vpc_address.addr2.external_ipv4_address[0].address
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}
#VM3
resource "yandex_vpc_address" "addr3" {
  name = "vm-adress3"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}
resource "yandex_compute_instance" "vm3" {
  name                      = "vm3"
  allow_stopping_for_update = true
  zone                      = "ru-central1-a"
  resources {

    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8qs4k9kv4rdj5mgq02"
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet1.id
    nat            = true
    nat_ip_address = yandex_vpc_address.addr3.external_ipv4_address[0].address
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

data "yandex_compute_image" "my_image" {
  image_id = "fd8bu9gsckcm2351kqaq"
}
output "external_ip_address_vm1" {
  value = yandex_vpc_address.addr.external_ipv4_address[0].address
}

output "external_ip_address_vm2" {
  value = yandex_vpc_address.addr2.external_ipv4_address[0].address
}
output "external_ip_address_vm3_ansible" {
  value = yandex_vpc_address.addr3.external_ipv4_address[0].address
}
