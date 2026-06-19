-- CREATE DATABASE IF NOT EXISTS db_key_control;
-- USE db_key_control;

-- 1. Tabela Unificada de Status
CREATE TABLE tb_status (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    status_key VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    CONSTRAINT uk_status_key UNIQUE (status_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Tabela de Pessoas (Cadastro Base)
CREATE TABLE tb_people (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    public_id CHAR(36) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    department VARCHAR(100),
    status_id BIGINT NOT NULL,
    CONSTRAINT uk_people_public_id UNIQUE (public_id),
    CONSTRAINT fk_people_status FOREIGN KEY (status_id) REFERENCES tb_status(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Tabela de Funcionários (Aptos a retirar chaves)
CREATE TABLE tb_employees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    person_id BIGINT NOT NULL,
    registration_number VARCHAR(50) NOT NULL,
    status_id BIGINT NOT NULL,
    CONSTRAINT uk_employee_registration UNIQUE (registration_number),
    CONSTRAINT fk_employees_person FOREIGN KEY (person_id) REFERENCES tb_people(id),
    CONSTRAINT fk_employees_status FOREIGN KEY (status_id) REFERENCES tb_status(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Tabela de Usuários (Operadores/Recepcionistas)
CREATE TABLE tb_users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    person_id BIGINT NOT NULL,
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    status_id BIGINT NOT NULL,
    CONSTRAINT uk_users_username UNIQUE (username),
    CONSTRAINT fk_users_person FOREIGN KEY (person_id) REFERENCES tb_people(id),
    CONSTRAINT fk_users_status FOREIGN KEY (status_id) REFERENCES tb_status(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Tabela de Chaves (Inventário Físico)
CREATE TABLE tb_keys (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    key_code VARCHAR(50) NOT NULL,
    room_name VARCHAR(100) NOT NULL,
    status_id BIGINT NOT NULL,
    CONSTRAINT uk_keys_code UNIQUE (key_code),
    CONSTRAINT fk_keys_status FOREIGN KEY (status_id) REFERENCES tb_status(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Tabela de Controle de Movimentação (Histórico de Retiradas e Devoluções)
CREATE TABLE tb_key_control (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    log_date DATE NOT NULL,
    key_id BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    withdrawal_time TIME NOT NULL,
    has_employee_withdrawal_sign BOOLEAN NOT NULL DEFAULT FALSE,
    withdrawal_receptionist_user_id BIGINT NOT NULL,
    return_time TIME DEFAULT NULL,
    has_employee_return_sign BOOLEAN NOT NULL DEFAULT FALSE,
    return_receptionist_user_id BIGINT DEFAULT NULL,
    status_id BIGINT NOT NULL,
    CONSTRAINT fk_control_key FOREIGN KEY (key_id) REFERENCES tb_keys(id),
    CONSTRAINT fk_control_employee FOREIGN KEY (employee_id) REFERENCES tb_employees(id),
    CONSTRAINT fk_control_withdrawal_receptionist FOREIGN KEY (withdrawal_receptionist_user_id) REFERENCES tb_users(id),
    CONSTRAINT fk_control_return_receptionist FOREIGN KEY (return_receptionist_user_id) REFERENCES tb_users(id),
    CONSTRAINT fk_control_status FOREIGN KEY (status_id) REFERENCES tb_status(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inserção de Cargas Iniciais (Exemplo de Status)
INSERT INTO tb_status (status_key, category, description) VALUES
('ACTIVE', 'PEOPLE', 'Cadastro de pessoa ativo no sistema'),
('INACTIVE', 'PEOPLE', 'Cadastro de pessoa inativo'),
('EMP_ACTIVE', 'EMPLOYEES', 'Funcionário ativo e apto a retirar chaves'),
('EMP_SUSPENDED', 'EMPLOYEES', 'Funcionário suspenso temporariamente'),
('USR_ACTIVE', 'USERS', 'Operador com acesso ativo ao sistema'),
('USR_BLOCKED', 'USERS', 'Operador bloqueado'),
('KEY_AVAILABLE', 'KEYS', 'Chave disponível no claviculário'),
('KEY_WITHDRAWN', 'KEYS', 'Chave retirada por um funcionário'),
('KEY_MAINTENANCE', 'KEYS', 'Chave em manutenção ou cópia indisponível'),
('ST_OPEN', 'KEY_CONTROL', 'Movimentação aberta (chave pendente de devolução)'),
('ST_COMPLETED', 'KEY_CONTROL', 'Movimentação concluída (chave devolvida)');