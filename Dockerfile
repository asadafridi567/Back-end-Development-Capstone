# Use the correct base image with up-to-date repositories.
FROM python:3.9.16-slim

# Set environment variables for Python
ENV PYTHONBUFFERED 1
ENV PYTHONWRITEBYTECODE 1

# Install netcat, which is used in the entrypoint.sh script.
RUN apt-get update \
    && apt-get install -y netcat

# Set the application directory
ENV APP=/app
WORKDIR $APP

# Copy and install Python dependencies
COPY requirements.txt $APP
RUN pip3 install -r requirements.txt

# Copy the rest of the application files
COPY . $APP

# Expose the port for the Django application
EXPOSE 8000

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Set the entrypoint to run the entrypoint.sh script
ENTRYPOINT ["/bin/bash","/app/entrypoint.sh"]

# Set the default command to start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]