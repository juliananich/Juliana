# Use a minimal, actively supported Alpine base
FROM python:3.11-alpine3.20

# Force the OS to fetch and install the latest security patches
RUN apk update && apk upgrade --no-cache

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set the working directory
WORKDIR /usr/src/app

# Copy dependency requirements
COPY requirements.txt .

# Upgrade Python packaging tools and install requirements
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY app/ app/

# Transfer ownership of the app directory to the non-root user
RUN chown -R appuser:appgroup /usr/src/app

# Drop root privileges by switching to the application user
USER appuser

EXPOSE 8080

CMD ["python", "app/main.py"]
