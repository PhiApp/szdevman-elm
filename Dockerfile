FROM nginx:1.19.8

RUN apt update && apt install npm -y 

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf.template /etc/nginx/templates/

WORKDIR /code

COPY package.json .

RUN npm install

COPY . /code

RUN npm run prod && mkdir /var/www && cp -r dist /var/www/html
