
FROM node:18-alpine

WORKDIR /usr/src/app

COPY app/package*.json ./
RUN npm install

COPY app/ .

ENV LOG_LEVEL=info

CMD ["npm", "start"]
