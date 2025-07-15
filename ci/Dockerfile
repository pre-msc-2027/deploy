FROM node as builder

WORKDIR /app

# Copy the script into the image
COPY setup.sh .

# Make the script executable
RUN chmod +x setup.sh

# Run the script
RUN ./setup.sh

FROM nginx

ARG BUILD_DIR

# Copy build output from builder to Nginx's html folder
COPY --from=builder /app/${BUILD_DIR} /usr/share/nginx/html

EXPOSE 80
