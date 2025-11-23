# Runtime image – NOT the devcontainer
FROM python:3.12-slim

# Dagster needs this
ENV DAGSTER_HOME=/opt/dagster/dagster_home

# This will be our working directory inside the container
WORKDIR /opt/dagster/app/etl

# Basic build tools (needed for some Python deps like pandas)
RUN apt-get update \
    && apt-get install -y build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy your Dagster project from host into the image
# This copies everything that is currently in /workspaces/dagster/etl
COPY etl/ ./

# Install Python deps defined in pyproject.toml (+ pandas which we used)
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir .[dev] pandas

# Create Dagster home dir
RUN mkdir -p ${DAGSTER_HOME}

# Dagster webserver default port
EXPOSE 3000

# Start Dagster inside the container
# Same as what you do manually: `dagster dev` from the etl folder
CMD ["dagster", "dev", "-h", "0.0.0.0", "-p", "3000"]
