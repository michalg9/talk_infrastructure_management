# What is OpenTofu/Terraform?

Following the offical Open Tofu [docs](https://opentofu.org/docs/intro/install/):

```bash
brew install opentofu
```

Generate a classic token (following [github docs](https://docs.github.com/en/authenticati
on/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)) with *full control over repos* and *delete repos*. You can call it *Naver OpenTofu demo*. Export the token as `GITHUB_TOKEN`:


```bash
export GITHUB_TOKEN=

gh auth login

# init / download providers
tofu init

# plan
tofu plan

# test
tofu test

# apply
tofu apply

# destroy
tofu destroy
```

Afterwards you can chceck your repositories at https://github.com/michalg9?tab=repositories

## References

- [OpenTofu documentations](https://opentofu.org/docs)
