#Specify a base image
FROM node:11

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

#Specify a working directory
WORKDIR /usr/app

#Copy the dependencies file
COPY ./package.json ./

#Install dependencies
RUN yarn  

#Copy remaining files
COPY ./ ./

#Default command
CMD ["yarn","start"]