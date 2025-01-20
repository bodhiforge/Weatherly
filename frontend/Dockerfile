# Use the official Node.js image
FROM node:20

# Set working directory
WORKDIR /app

# Copy only the package.json and yarn.lock initially for dependency installation
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the app files
COPY . .

# Expose the development server port
EXPOSE 3000

# Default command to start the React development server
CMD ["yarn", "start"]
