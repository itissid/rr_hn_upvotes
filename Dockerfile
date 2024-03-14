# --- Stage 1: Python environment setup ---
FROM python:3.11-slim as backend-builder

ARG CONTAINER_PROJECT_DIR=recurrent-rebels-week2-hackernews-upvotes

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.5.1 

RUN apt-get update && apt-get install -y --no-install-recommends \
    git gcc g++ git sqlite3 musl-dev vim tmux \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install "poetry==$POETRY_VERSION"

# Copy the Python project files to the container
ARG PROJECT_DIR
COPY ${PROJECT_DIR}/pyproject.toml /$CONTAINER_PROJECT_DIR/
COPY ${PROJECT_DIR}/poetry.lock /$CONTAINER_PROJECT_DIR/
RUN ls -l /$CONTAINER_PROJECT_DIR/poetry.lock || true
WORKDIR /$CONTAINER_PROJECT_DIR
RUN touch README.md
COPY ${PROJECT_DIR}/src /$CONTAINER_PROJECT_DIR/src

RUN poetry check
RUN poetry build
# Listing the build artifacts, adjust if necessary
RUN ls -lart /$CONTAINER_PROJECT_DIR/dist || true

# Note: The second stage is omitted since you want to stop after the first stage.
FROM backend-builder as jupyter-env

RUN poetry install --no-dev
EXPOSE 8888

# Add a command for starting the Jupyter server
CMD ["poetry", "run", "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser"]