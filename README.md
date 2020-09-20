# Just a POC

A small POC to demonstrate the use of PHP 5.6 and PHP 7.4 side-to-side on the same server.

DISCLAIMER: This is a POC and shouldn't be used as-is on a public server.

Run the Docker container with:

```shell script
$ docker run -d --name php-poc -p 80:80 -p 443:443 php-poc
```

Then, change your local DNS so both domains `php56.example.local` and `php74.example.local` points to `127.0.0.1`.

```shell script
# On a linux box:
$ echo 127.0.0.1 php56.example.local php74.example.local >> /etc/hosts
```

Test the URL on your web browser.

[PHP 5.6](https://php56.example.local)

[PHP 7.4](https://php74.example.local)

Enjoy!