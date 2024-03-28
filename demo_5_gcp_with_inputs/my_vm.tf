resource "google_service_account" "default" {
  account_id   = "sa-${var.instance_name}"
  display_name = "Custom SA for VM Instance ${var.instance_name}"
}

resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo '${var.secret_message}' > /hello.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  #  TO SHOW - this will break apply because SSD is not availible for e2-micro
  # // Local SSD disk
  # scratch_disk {
  #   interface = "NVME"
  # }

}
