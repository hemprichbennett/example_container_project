A basic tutorial for using containerised computing in our analyses.

# setup

To run this simple example you'll need [Docker](https://docs.docker.com/get-docker/) installed on your machine, and (if you're on Windows or Mac), this will require the Docker Desktop platform to be running. Other container software is available, but this is by far the most common and so is the one I've chosen to go with

If you've got git installed on your machine (please do so, but thats a different tutorial...) then you can download this repo by opening your terminal or powershell, moving to the location that you want this folder to go, and using the command `git clone https://github.com/hemprichbennett/example_container_project.git`. If you don't have git installed, you can download a .zip file using the green 'code' button above.

# Building the image

Once you have the files downloaded, go into the folder we've just obtained (example_container_project) in your terminal. This folder contains a Dockerfile, which we need to build. We can do this with the command `docker build -t cero_image .`. To break this down, we are using Docker to *build* an image, and giving it the title 'cero_image', using the flag `-t cero_image`. We then use the `.` character, which generally means 'here' in computer speak. So we're saying "build a Docker image, name it cero_image, and use the Dockerfile that's here".

This will give us a Docker image which is set up using all of the parameters laid out in the Dockerfile: take the most recent version of the 'rstudio' docker image which the 'rocker' group have released, run some basic linux commands to ensure its up to date, install a few dependencies, and then use R to install the three desired packages.

I've used the rstudio image, but there are very many more to choose from. The main R images are listed [here](https://www.rocker-project.org/images/), and the full dizzying array of images can be viewed and added to at [docker hub](https://hub.docker.com).

However as we're using an image that we based on the rstudio image, we probably want to run rstudio. We do this by *running* the image as a container; basically an image is a static item, and a container is the image when it's running. When we run this container we want it to be able to access some files from our computer, in this case the script and rproject file that I've created. To do this, we have to provide the image with the path to this folder, and then mount them in the image.

# Run the image

`docker run -p 8787:8787 --rm -v <long_absolute_path>/example_container_project:/home/rstudio/example_container_project/ cero_image`

This command looks more intense than it is, so to break it down:
- `docker run` runs a docker image
- `-p 8787:8787` tells docker that you want the container to be accessible to other machines, and that you want it to be available on port 8787. Other port numbers are available, but this tends to be the one thats used by default. As the container thinks that it is its own independent machine, we need to say where the container itself will be open to receiving any traffic from, and so we tell it to listen on port 8787. So `-p 8787:8787` means that port 8787 on your local machine is equal to port 8787 on the container. Importantly, this is why you'll see a message in your terminal giving a password for you to use to access the container, and telling you that you can specify a password in future: anyone on your local network can access this container now, so long as they have the password. This lets you access it from other computers, but without password-protection it leaves you vulnerable to hackers. TLDR: just use this parameter and never think about it again unless you're running multiple rstudio containers at the same time, like a lunatic.
- `--rm ` remove the container after you finish using it. As you can rebuild the container from the image, you probably want to include this. Otherwise you'll quickly clog your hard drive up with old containers.
- `-v <long_absolute_path>/example_container_project:/home/rstudio/example_container_project/ `
specifies which folder you want the container to be able to see, edit and use, and where it sees it. The requirement to specify this means that you can restrict your ability to screw up files from other work, which is generally a good thing. As with the above `-p` command, you're using the notation `local thing:remote thing`, and so the path on the left-hand side is the path on your actual computer that you'll be making visible, and the right-hand side is what the container will perceive as existing (in this case, it will see and work on a folder at /home/rstudio/example_container_project). Replace the <long_absolute_path> bit with the relevant absolute path on your computer.
- `cero_image` is just the name of the image to run.


When you enter the above command, you should see a happy message in your terminal saying that the service is starting, and giving you a random password to use for this session. You now need to access the service through your internet browser. On some machines you can access the image at `localhost:8787`, on some you may need to find your ip address and then use, for example `1234.1.1.1:8787`, if your ip address was 1234.1.1.1.


And that, really, should be it! You now have a containerised instance of rstudio, with all the relevant code and data available. Any changes you make to the mounted folder while in this container should persist after you close it, and the container can be rebuilt from the image at any point.

# A few more advanced things

There may occasionally be situations where you want to archive the container, perhaps as you've made changes to it such as installing packages etc. While it's better to do those steps when building your first image from the Dockerfile, an occasional archive can be handy. A running image can be saved as a compressed file (a .tar file) with a command such as `docker save cero_image > cero_archived_image.tar`. This archived image can then be relaunched with `docker load --cero_archived_image.tar`

Some of us may want to enter a running container in a bash session, to do that we first need to find the containers ID using `docker ps` or `docker container ls`. When we have that we can enter it with `docker exec -it container_id bash`

Images can also be stored at [docker hub](https://hub.docker.com). You'll need to set up an account and a repo for the image, you can then use commands such as `docker commit -m "commit message" container_id dockerhub_user/repo` to stop the container and save changes to the image. Then use `docker push dockerhub_user/repo` to push it.



# Useful further resources
- Insert some here.