# custom-exim-deb
Docker recipe to build a customised exim4-daemon-wormnet `.deb`,
inspired by <http://patchlog.com/linux/debian-building-custom-exim-packages/>

Invoke with `docker build -t exim-build .`; for me on my laptop
it takes about two minutes to prepare the build environment, and
about three minutes to compile Exim.
You can then `docker run -it exim-build` and work out where to put the `.deb` files

I'm not proud of this--it contains much thuggery;
any contributions to make it less brutal (but still work) most welcome.
