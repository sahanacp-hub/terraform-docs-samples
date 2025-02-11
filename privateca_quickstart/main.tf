# [START privateca_quickstart]
provider google{}
provider tls{}

resource "google_project_service" "privateca_api" {
  service            = "privateca.googleapis.com"
  disable_on_destroy = false
}

resource "tls_private_key" "example" {
  algorithm   = "RSA"
}

resource "tls_cert_request" "example" {
  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "google_privateca_ca_pool" "default" {
  name = "my-ca-pool"
  location = "us-central1"
  tier = "ENTERPRISE"
  publishing_options {
    publish_ca_cert = true
    publish_crl = true
  }
  labels = {
    foo = "bar"
  }
  issuance_policy {
    baseline_values {
      ca_options {
        is_ca = false
      }
      key_usage {
        base_key_usage {
          digital_signature = true
          key_encipherment = true
        }
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
}

resource "google_privateca_certificate_authority" "test-ca" {
  certificate_authority_id = "my-authority"
  location = "us-central1"
  pool = google_privateca_ca_pool.default.name
  config {
    subject_config {
      subject {
        country_code = "us"
        organization = "google"
        organizational_unit = "enterprise"
        locality = "mountain view"
        province = "california"
        street_address = "1600 amphitheatre parkway"
        postal_code = "94109"
        common_name = "my-certificate-authority"
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
  type = "SELF_SIGNED"
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }
}

resource "google_privateca_certificate" "default" {
  pool = google_privateca_ca_pool.default.name
  certificate_authority = google_privateca_certificate_authority.test-ca.certificate_authority_id
  location = "us-central1"
  lifetime = "860s"
  name = "my-certificate"
  pem_csr = tls_cert_request.example.cert_request_pem
}
# [END privateca_quickstart]
