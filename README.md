# Horse Clean API (Lazarus)

API REST desenvolvida em **Lazarus / FreePascal**, utilizando o framework **Horse**, com aplicação prática de **Clean Architecture**, **SOLID** e **padrões de projeto**, focada em backend.

Este projeto faz parte de um **desafio técnico e estudo prático**, indo do zero (estrutura e banco) até endpoints REST funcionais.

---

## 🎯 Objetivo do Projeto

Demonstrar, na prática, como construir uma API REST em Pascal aplicando:

- Clean Architecture
- SOLID
- Separação de responsabilidades
- Repositórios desacoplados
- Casos de uso explícitos
- Infraestrutura isolada
- Boas práticas de API REST

Tudo isso **sem frameworks mágicos** e sem containers de DI, para deixar as decisões arquiteturais claras.

---

## 🧱 Arquitetura

O projeto segue os princípios da **Clean Architecture**, com dependências fluindo sempre para dentro.

src/
├── domain/ → Entidades e contratos (regras de negócio)
├── application/ → Casos de uso e DTOs
├── infrastructure/ → Banco de dados e repositórios concretos
└── presentation/ → Controllers e rotas (Horse)


### Camadas

- **Domain**
  - Entidades ricas (não anêmicas)
  - Interfaces de repositório
  - Nenhuma dependência externa

- **Application**
  - Casos de uso (UseCases)
  - Orquestração das regras de negócio
  - DTOs para entrada e saída

- **Infrastructure**
  - SQLite com SQLDB
  - Implementações concretas de repositórios
  - Conversões de tipos (DateTime, boolean, etc.)

- **Presentation**
  - Controllers HTTP
  - Parse de JSON (`fpjson`)
  - Nenhuma regra de negócio

---

## 🛠️ Tecnologias Utilizadas

- **Lazarus / FreePascal**
- **Horse** (framework HTTP)
- **SQLite**
- **SQLDB**
- **fpjson / jsonparser**
- Arquitetura limpa (Clean Architecture)

---

## 📦 Funcionalidades Implementadas

Recurso: **Category**

Campos:
- `id`
- `nome`
- `descricao`
- `ativo`
- `created_at`
- `updated_at`

### Endpoints disponíveis

| Método | Rota | Descrição |
|------|------|----------|
| POST | `/categories` | Criar categoria |
| GET | `/categories/:id` | Buscar categoria por ID |
| PUT | `/categories/:id` | Atualizar nome e descrição |
| PATCH | `/categories/:id/enable` | Ativar categoria |
| PATCH | `/categories/:id/disable` | Desativar categoria |

> O estado ativo/inativo é tratado explicitamente, sem misturar responsabilidades com update de dados.

---

## 🗄️ Banco de Dados

SQLite com script manual de criação.

📄 `database/schema.sql`

```sql
CREATE TABLE IF NOT EXISTS categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  descricao TEXT,
  ativo INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT
);


As datas são armazenadas em formato ISO 8601, garantindo compatibilidade com APIs e integrações.


🚀 Executando o Projeto

1)Clone o repositório

2)Abra o projeto no Lazarus

3)Crie o banco de dados SQLite (database/app.db)

4)Execute o script schema.sql

5)Rode a aplicação


🧠 Decisões Arquiteturais Importantes

Controllers não contêm regra de negócio

Casos de uso representam intenções claras

Entidades protegem seu próprio estado

Infraestrutura faz conversões de tipos

SQLite pode ser trocado sem impactar domínio ou aplicação

Factories estão sendo introduzidas gradualmente para evitar overengineering


📌 Estado Atual do Projeto

Arquitetura base completa

CRUD parcialmente implementado

Controllers ainda conhecem algumas implementações concretas
(Factory / Composition Root em evolução)

Isso é intencional, para fins didáticos e de aprendizado progressivo.

👨‍💻 Autor

Projeto desenvolvido como estudo prático de backend e arquitetura de software utilizando Lazarus e FreePascal.


“Arquitetura limpa não é sobre pastas, é sobre dependências.”