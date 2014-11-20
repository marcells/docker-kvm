## Docker image to run ASP.NET vNext on Linux

__Base image:__ marcells/mono

### What is installed?

- KVM
- Kestrel

### What is exposed?

Port `5004` (default port for Kestrel) and the `/data` directory can be used as volume

### How to run?

Below are some samples how to run the container. Also take a look at the [Docker Documentation](http://docs.docker.com/reference/commandline/cli/#run).

#### Without port publishing and without a mounted volume (quick command just for playing around)
`sudo docker run -it marcells/kvm`

#### With dynamically published ports and bound volume
`sudo docker run -it -v $(pwd)/data:/data -P marcells/kvm`

#### With fixed port mapping and bound volume
`sudo docker run -it -v $(pwd)/data:/data -p 5001:5001 marcells/kvm`