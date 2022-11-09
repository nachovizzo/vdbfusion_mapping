# [vdbfusion_mapping](https://github.com/Kin-Zhang/vdbfusion_mapping) on Docker

This is just using Kin's [ROS wrapper](https://github.com/Kin-Zhang/vdbfusion_mapping) of
[vdbfusion](https://github.com/PRBonn/vdbfusion). Nothing less, nothing more.

I used my own [ros_in_docker](https://github.com/nachovizzo/ros_in_docker) template to achieve this.

## Instructions

```
make init   # patch build system
make docker # creates the underlying docker container with all dependencies
make build  # build the whole thing
make dev    # enter hacker mode(developer mode)
```


After this, just follow whatever instructions to launch you can find in the original repository of
[vdbfusion_mapping](https://github.com/Kin-Zhang/vdbfusion_mapping) on Docker

**NOTE:** Make sure to load your data into the contianer by `export ROS_BAGS=<path>`

In my particular case I can run the pipeline by just doing the following

```sh
export ROS_BAGS=/home/ivizzo/data/voxblox/
make run
# inside the container
roslaunch vdbfusion_ros vdbfusion_mapping_cow.launch bag_file:=$(realpath bags/data.bag)
```
