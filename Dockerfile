FROM node:16.20.0-alpine3.16 AS build-env

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install
RUN npm install -g nx

COPY src ./src
COPY tailwind.config.js tsconfig.json tsconfig.app.json tailwind.config.js angular.json ./

RUN npm run build:prod

FROM nginx:1.13.9-alpine

COPY --from=build-env /app/dist/bc-copy-website/ /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
