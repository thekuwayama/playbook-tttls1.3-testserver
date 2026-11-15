# playbook-tttls1.3-testserver

[![Actions Status](https://github.com/thekuwayama/playbook-tttls1.3-testserver/workflows/CI/badge.svg)](https://github.com/thekuwayama/playbook-tttls1.3-testserver/actions?workflow=CI)


## Set up python

```bash
$ uv venv

$ source .venv/bin/activate

$ uv python install

$ uv pip install -r requirements.txt
```


## Deploy

### dev

```bash
$ docker image build --no-cache . -t playbook-tttls1.3-testserver/dev

$ docker run --privileged -d -p 4433:443 -p 1443:1443 --name dev playbook-tttls1.3-testserver/dev /sbin/init

$ uv run ansible-playbook -i playbook/dev playbook/private_certificate.yml playbook/https.yml playbook/biryani.yml
```

Check [https://localhost:4433](https://localhost:4433) and [https://localhost:1443](https://localhost:1443)

```bash
$ docker ps -ql | xargs docker stop

$ docker container prune
```


### prod

Login via SSH on first boot and run:

```bash
$ ssh ubuntu@160.16.64.99

$ echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu
```

```bash
$ uv run ansible-playbook --ask-vault-pass -i playbook/prod --user ubuntu playbook/certbot.yml playbook/https.yml playbook/biryani.yml playbook/sshd_config.yml playbook/paranoids.yml
```

Check [https://thekuwayama.net](https://thekuwayama.net) and [https://thekuwayama.net:1443](https://thekuwayama.net:1443)
