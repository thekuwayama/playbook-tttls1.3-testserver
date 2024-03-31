# playbook-tttls1.3-testserver

[![Actions Status](https://github.com/thekuwayama/playbook-tttls1.3-testserver/workflows/CI/badge.svg)](https://github.com/thekuwayama/playbook-tttls1.3-testserver/actions?workflow=CI)


## Set up python

```bash
$ source /path/to/virtualenv/bin/activate

$ pip install -r requirements.txt
```


## Deploy

### dev

```bash
$ docker image build --no-cache . -t playbook-tttls1.3-testserver/dev

$ docker run --privileged -d -p 4433:443 --name dev playbook-tttls1.3-testserver/dev /sbin/init

$ cd playbook

$ ansible-playbook -i dev private_certificate.yml https.yml
```

Check [https://localhost:4433](https://localhost:4433)

```bash
$ docker ps -ql | xargs docker stop
```


### prod

 ```bash
$ python gen_startup.py --user $USER --id_rsa_pub="`cat ~/.ssh/id_rsa.pub`" | pbcopy
```

Paste startup-script to settings.

```bash
$ cd playbook

$ ansible-playbook --ask-vault-pass -i prod --user $USER certbot.yml https.yml sshd_config.yml paranoids.yml
```

Check [https://thekuwayama.net](https://thekuwayama.net)
