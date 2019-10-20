# playbook-tttls1.3-testserver


## Set up python

```bash
$ source /path/to/virtualenv/bin/activate

$ pip install -r requirements.txt
```


## Deploy

### dev

```bash
$ cd playbook

$ ssh-keygen -f ./id_rsa -t rsa -b 4096 -N ''

$ docker build . -t playbook-tttls1.3-testserver/dev

$ docker run --privileged -d -p 2222:22 -p 4433:443 playbook-tttls1.3-testserver/dev /sbin/init

$ ansible-playbook --ask-vault-pass -i dev private_certificate.yml https.yml paranoids.yml
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
