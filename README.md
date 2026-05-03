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

$ docker run --privileged -d -p 4433:443 --name dev playbook-tttls1.3-testserver/dev /sbin/init

$ uv run ansible-playbook -i playbook/dev playbook/private_certificate.yml playbook/https.yml
```

Check [https://localhost:4433](https://localhost:4433)

```bash
$ docker ps -ql | xargs docker stop

$ docker container prune
```


### prod

 ```bash
$ uv run python gen_startup.py --user $USER --id_rsa_pub="`cat ~/.ssh/id_rsa.pub`" | pbcopy
```

Paste startup-script to settings.

```bash
$ uv run ansible-playbook --ask-vault-pass -i playbook/prod --user $USER playbook/certbot.yml playbook/https.yml playbook/sshd_config.yml playbook/paranoids.yml
```

Check [https://thekuwayama.net](https://thekuwayama.net)
