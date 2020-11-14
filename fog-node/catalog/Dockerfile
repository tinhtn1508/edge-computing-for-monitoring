#Specify a base image
FROM node:12

#Specify a working directory
WORKDIR /usr/app

#Copy the dependencies file
COPY ./ ./

#Install dependencies
RUN npm install

#Default command
CMD ["npm","start"]