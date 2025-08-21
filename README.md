# Docker Wrapper DIND

**A Docker wrapper image that runs any Docker image silently, supporting ECR or public images.**

This project provides a flexible Docker container that allows you to run other Docker images with logs silenced (or optionally verbose) while maintaining full container functionality. It essentially acts as a wrapper for Docker containers.

---

## Features

- Run **any Docker image** inside a wrapper.
- Optionally suppress logs completely or show them with `VERBOSE=1`.
- Supports environment variables, volumes, and command arguments.
- Works with **ECR**, **Docker Hub**, or any accessible registry.
- No real Docker-in-Docker required — uses host Docker socket.
- Run multiple images concurrently.

---

## Use Case

This image was built to satisfy a common DevOps requirement: sometimes teams want to **run containers silently**, without polluting CI/CD or application logs. Instead of modifying each individual image, this wrapper lets you:

- Run `nginx`, `redis`, `alpine`, or any custom image silently.
- Control verbosity via an environment variable.
- Run multiple images with independent execution and logging.

---

## Getting Started

### Prerequisites

- Docker installed on the host.
- Access to Docker images (ECR login if needed).
- Linux system with `/var/run/docker.sock` accessible.

---

### Build the Wrapper Image

Clone this repository:

```bash
git clone https://github.com/<your-username>/docker-wrapper-dind.git
cd docker-wrapper-dind
```

Build the image:

```bash
docker build -t docker-wrapper-dind:latest .
```

---

### Run Images Using the Wrapper

**Run any image silently:**

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock docker-wrapper-dind alpine:3.20 echo "Hello"
```

**Run image with verbose logs:**

```bash
docker run --rm -e VERBOSE=1 -v /var/run/docker.sock:/var/run/docker.sock docker-wrapper-dind nginx
```

**Run in detached mode:**

```bash
docker run -d -v /var/run/docker.sock:/var/run/docker.sock docker-wrapper-dind redis
```

**Passing environment variables:**

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -e FOO=bar docker-wrapper-dind alpine sh -c 'echo $FOO'
```

---

## How It Works

The wrapper:

1. Accepts the target Docker image and arguments.
2. Passes them to the Docker host via the mounted socket.
3. Silences stdout/stderr by default (or prints if `VERBOSE=1`).
4. Returns the exit code of the underlying container.

---

## Files

- `Dockerfile` – Builds the wrapper image.
- `entrypoint.sh` – Entry point script that runs the target image silently.

---

## Notes

- This wrapper **does not run a full Docker-in-Docker** — it uses the host Docker daemon.
- Only the host must have proper Docker permissions.
- Works best on Linux hosts with mounted `/var/run/docker.sock`.

---

## Example Scenarios

- Running multiple containers silently in CI/CD pipelines.
- Wrapping ECR images without modifying their Dockerfiles.
- Running test containers in a controlled verbose or silent mode.

---

## License

MIT License – free to use and modify.

