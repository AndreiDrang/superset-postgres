FROM apache/superset:5.0.0

USER root

# Install dependencies in a single layer and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN uv pip install --no-cache-dir psycopg2-binary

COPY superset_config.py /etc/superset/superset_config.py
ENV SUPERSET_CONFIG_PATH=/etc/superset/superset_config.py

# Switch back to superset user for security
USER superset
