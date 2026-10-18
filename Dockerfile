# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Install git (required by the RSS plugin)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy only the requirements first (Layer Caching optimization)
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port 8000 to the outside world
EXPOSE 8000

# Command to run when the container starts
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]