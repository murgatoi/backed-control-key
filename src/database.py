from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

# URL de Conexão: mysql+pymysql://usuario:senha@nome_do_container_docker/nome_do_banco
DATABASE_URL = "mysql+pymysql://root:root_password_local@mysql_db:3306/control_keys_db"

engine = create_engine(
    DATABASE_URL, 
    pool_pre_ping=True  # Testar a conexão antes de enviar queries (evita quedas)
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Dependência para obter a sessão do banco nas rotas da API
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()