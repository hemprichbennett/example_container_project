# example_container_project

A very basic tutorial for using containerised computing in our analyses.

To run this simple example you'll need [Docker](https://docs.docker.com/get-docker/) installed on your machine, and (if you're on Windows or Mac), this will require the Docker Desktop platform to be running. Other container software is available, but this is by far the most common and so is the one I've chosen to go with

If you've got git installed on your machine (please do so, but thats a different tutorial...) then you can download this repo by opening your terminal or powershell, moving to the location that you want this folder to go, and using the command `git clone https://github.com/hemprichbennett/example_container_project.git`. If you don't have git installed, you can download a .zip file using the green 'code' button above.


Once you have the files downloaded, go into the folder we've just obtained (example_container_project) in your terminal. This folder contains a Dockerfile, which we need to build. We can do this with the command `docker build -t cero_image .`. To break this down, we are using Docker to *build* an image, and giving it the title 'cero_image', using the flag `-t cero_image`. We then use the `.` character, which generally means 'here' in computer speak. So we're saying "build a Docker image, name it cero_image, and use the Dockerfile that's here".

This will give us a Docker image which is set up using all of the parameters laid out in the Dockerfile: take the most recent version of the 'rstudio' docker image which the 'rocker' group have released, run some basic linux commands to ensure its up to date, install a few dependencies, and then use R to install the three desired packages.

I've used the rstudio image, but there are very many more to choose from. The main R images are listed [here](https://www.rocker-project.org/images/), and the full dizzying array of images can be viewed and added to at [docker hub](https://hub.docker.com)