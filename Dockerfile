# https://docs.docker.com/engine/reference/builder/

FROM node:lts

EXPOSE 3000/tcp
ENV PORT=3000
ENV NODE_ENV=production

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --verbose
COPY . .

USER node

CMD [ "node", "index.js"]
