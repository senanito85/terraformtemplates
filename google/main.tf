terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.58.0"
    }
  }
}

provider "google" {
  credentials = file("thedock-d3fd0697d15d.json")
  project = "infrastructure-231700"
  region = "europe-west2"
  #zone    = "australia-southeast1-b"
}

data "google_compute_address" "cobalt-accentric-demo" {
  name = "cobalt-accentric-demo"
}

resource "google_compute_address" "cobalt-accentric-demo" {
  name = "cobalt-accentric-demo"
  description = "demo instance of cobalt for accentric Ip"
}

resource "google_compute_instance" "cobalt-demo-accentric" {
  name         = "cobalt-demo-accentric"
  machine_type = "e2-standard-2"
  tags         = ["http-server","https-server","public-sql-server"]
  zone         = "europe-west2-c"
  description = "Demo instance of Cobalt app for Accentric"

  boot_disk {
    device_name = "cobalt-demo-accentric-disk"
    initialize_params {
      image = "debian-cloud/debian-9"
      size = 40
    }
  }

  network_interface {
    network = "default"
    subnetwork = "default"
    access_config {
      network_tier = "PREMIUM"
      nat_ip = google_compute_address.cobalt-accentric-demo.address
    }
  }

  service_account {
    email  = "264030832675-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  provisioner "local-exec" {
    working_dir = "./ansible"
    command = "sleep 5"
  }

  provisioner "local-exec" {
    working_dir = "./ansible"
    command = "ansible-playbook -i hosts site.yml --vault-password-file vault.password --key-file ~/.ssh/google_compute_known_hosts"
  }

}

output "ip" {
   value = google_compute_address.cobalt-accentric-demo.address
}
