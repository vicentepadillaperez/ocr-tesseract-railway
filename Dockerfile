# Imagen base con Tesseract ya instalado
FROM jitesoft/tesseract-ocr:5-latest

# Instalar Node.js y npm dentro del contenedor
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    rm -rf /var/lib/apt/lists/*

# Carpeta de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copiar archivos de Node
COPY package.json ./
RUN npm install --production

# Copiar el servidor index.js
COPY index.js ./

# Exponer el puerto donde correrá Express
EXPOSE 3000

# Comando final para ejecutar tu servidor OCR
CMD ["npm", "start"]
