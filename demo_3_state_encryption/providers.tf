terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.1.0"
    }
  }

  encryption {
    key_provider "pbkdf2" "foo" {
      # Specify a long / complex passphrase (min. 16 characters)
      passphrase = "correct-horse-battery-staple"

      # Adjust the key length to the encryption method (default: 32)
      key_length = 32

      # Specify the number of iterations (min. 200.000, default: 600.000)
      iterations = 600000

      # Specify the salt length in bytes (default: 32)
      salt_length = 32

      # Specify the hash function (sha256 or sha512, default: sha512)
      hash_function = "sha512"
    }

     method "aes_gcm" "yourname" {
      keys = key_provider.pbkdf2.foo
    }

    # Uncomment for state encryption
    state {
      method = method.aes_gcm.yourname
      fallback {
        # The empty fallback block allows reading unencrypted state files.
      }
    }
  }
}
