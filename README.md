# gcc-docker
gcc docker images based on Alpine Linux. Available on [docker hub here](https://hub.docker.com/r/infinitecoder/gcc/).

This repo contains the Dockerfile for gcc builds using Alpine Linux as base image. The images are focused on optimisation of gcc itself, as well as on keeping the size of the docker image small.

## Usage
1. Install docker and start docker service.
2. Pull the image

       docker pull infinitecoder/gcc:<tag>
   where \<tag> is either devel ( for the latest image), or version number of gcc (eg: 7.3)
3. To use the image interactively use,

       docker run -it -v /home/mydir/:/home/code infinitecoder/gcc:<tag>
      
## License
This project is licensed under the MIT license. Refer LICENSE for more information.
