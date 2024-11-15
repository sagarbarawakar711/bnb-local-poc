# Use the official Nginx image from the Docker Hub
FROM nginx:latest


# Expose port 80 to access the website
EXPOSE 80

# Default command to start Nginx
CMD ["nginx", "-g", "daemon off;"]

