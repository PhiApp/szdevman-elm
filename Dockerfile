FROM nginx:1.19.8

COPY nginx.conf /etc/nginx/nginx.conf

RUN apt update && apt install npm -y 

WORKDIR /code

COPY package.json .

RUN npm install

COPY . /code

RUN npm run prod && mkdir /var/www && cp -r dist /var/www/html