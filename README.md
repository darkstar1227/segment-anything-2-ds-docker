[![Docker](https://img.shields.io/docker/pulls/justinlee901227/sam2)](https://hub.docker.com/r/justinlee901227/sam2)
# Segment anything 2 docker

Segment anything 2 is publish by Meta research.

https://github.com/facebookresearch/segment-anything-2

I make this to provide a docker image for those who more like to use docker during development.

The image with demo build in Jupyter start when run the docker container.

```jsx
docker run -d --gpus all justinlee901227/sam2:<version>-demo
```

Then, I also provide those not with the Jupyter start for building the application without Jupyter.

```jsx
FROM justinlee901227/sam2:<version>
```
