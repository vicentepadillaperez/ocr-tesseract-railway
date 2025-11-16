# 1) Imagen base con Node (funciona sin problemas en Railway)
FROM node:18-bullseye

# 2) Instalar tesseract + idioma español + inglés
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-spa \
    tesseract-ocr-eng \
    && rm -rf /var/lib/apt/lists/*

# 3) Carpeta de trabajo
WORKDIR /usr/src/app

# 4) Copiar package.json e instalar dependencias
COPY package.json ./
RUN npm install --production

# 5) Copiar servidor
COPY index.js ./

# 6) Exponer puerto para Railway
EXPOSE 3000

# 7) Comando final
CMD ["npm", "start"]
