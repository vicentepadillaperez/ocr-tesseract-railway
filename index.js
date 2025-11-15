import express from 'express';
import multer from 'multer';
import { execFile } from 'child_process';

const app = express();
const upload = multer({ dest: '/tmp' });
const PORT = process.env.PORT || 3000;

// Endpoint de salud
app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

// Endpoint principal de OCR
app.post('/ocr', upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }

  const lang = req.body.lang || 'spa+eng';
  const psm = req.body.psm || '6';
  const oem = req.body.oem || '1';

  // Ejecutamos Tesseract dentro del contenedor Docker
  execFile(
    'tesseract',
    [
      req.file.path,
      'stdout',       // salida por consola
      '-l', lang,     // idiomas
      '--oem', oem,   // engine mode (LSTM)
      '--psm', psm    // page segmentation mode
    ],
    { maxBuffer: 10 * 1024 * 1024 },
    (error, stdout, stderr) => {
      if (error) {
        console.error('Tesseract error:', error, stderr);
        return res.status(500).json({
          error: 'Tesseract failed',
          detail: stderr.toString(),
        });
      }

      res.json({
        text: stdout.toString(),
        params: { lang, psm, oem }
      });
    }
  );
});

app.listen(PORT, () => {
  console.log(`OCR service running on port ${PORT}`);
});
