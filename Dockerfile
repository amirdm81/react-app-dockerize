# ----------------------------
# Stage 1: Build with Node.js
# ----------------------------
FROM node:20.9.0-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# ----------------------------
# Stage 2: Serve with NGINX
# ----------------------------
FROM nginx:alpine

# Remove default NGINX config
RUN rm /etc/nginx/conf.d/default.conf

# Add custom NGINX config to listen on port 5002
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built app from Node stage to NGINX html directory
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 5002

CMD ["nginx", "-g", "daemon off;"]
