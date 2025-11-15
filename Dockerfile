FROM jitesoft/tesseract-ocr:5-latest

# Cambiar a usuario root para poder usar apt-get
USER root

# Instalar Node.js y npm dentro del contenedor
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY package.json ./
RUN npm install --production

COPY index.js ./

EXPOSE 3000

CMD ["npm", "start"]
