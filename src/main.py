from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Control Keys API", version="1.0.0")

# Configuração do CORS para permitir chamadas do seu Frontend com Yarn/Vite
origins = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"status": "Backend online", "projeto": "Control Keys"}

@app.get("/api/health")
def health_check():
    return {"status": "healthy"}