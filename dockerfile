FROM python:3.11-slim

WORKDIR /app

# Instala dependências do sistema necessárias para compilar pacotes, se houver
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copia e instala as dependências do Python
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copia o resto do código
COPY . .

EXPOSE 8000

# Roda o Uvicorn apontando para o main.py dentro de src/
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]