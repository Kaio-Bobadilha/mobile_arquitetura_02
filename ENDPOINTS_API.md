# Referência de Endpoints - DummyJSON API

## 🔐 Autenticação

### Login
**Endpoint:** `POST https://dummyjson.com/auth/login`

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "username": "emilys",
  "password": "emilyspass"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "username": "emilys",
  "email": "emily.johnson@x.dummyjson.com",
  "firstName": "Emily",
  "lastName": "Johnson",
  "gender": "female",
  "image": "https://dummyjson.com/icon/emilys/128",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Código de Erro (401):**
```json
{
  "message": "Invalid credentials"
}
```

---

### Obter Dados do Usuário Autenticado
**Endpoint:** `GET https://dummyjson.com/auth/me`

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "username": "emilys",
  "email": "emily.johnson@x.dummyjson.com",
  "firstName": "Emily",
  "lastName": "Johnson",
  "gender": "female",
  "image": "https://dummyjson.com/icon/emilys/128",
  "phone": "+92 xxx xxx xxxx",
  "domain": "example.com",
  "website": "https://example.com",
  "address": {
    "address": "626 Main St",
    "city": "Phoenix",
    "state": "Mississippi",
    "stateCode": "MS",
    "postalCode": "29112",
    "country": "United States"
  }
}
```

---

## 📦 Produtos

### Listar Todos os Produtos
**Endpoint:** `GET https://dummyjson.com/products?limit=0`

**Query Parameters:**
- `limit=0` - Retorna todos os produtos (default = 30)
- `skip=0` - Quantos pular (paginação)
- `select=title,price,image` - Campos a retornar (opcional)

**Request Headers:**
```
Content-Type: application/json
```

**Response (200 OK):**
```json
{
  "products": [
    {
      "id": 1,
      "title": "iPhone 9",
      "description": "An apple mobile which is nothing like apple",
      "price": 549,
      "discountPercentage": 12.96,
      "rating": 4.69,
      "stock": 94,
      "brand": "Apple",
      "category": "smartphones",
      "thumbnail": "https://cdn.dummyjson.com/products/images/smartphones/iphone-9/thumbnail.png",
      "images": [
        "https://cdn.dummyjson.com/products/images/smartphones/iphone-9/1.jpg",
        "https://cdn.dummyjson.com/products/images/smartphones/iphone-9/2.jpg",
        "https://cdn.dummyjson.com/products/images/smartphones/iphone-9/3.jpg",
        "https://cdn.dummyjson.com/products/images/smartphones/iphone-9/4.jpg",
        "https://cdn.dummyjson.com/products/images/smartphones/iphone-9/thumbnail.png"
      ]
    },
    ...
  ],
  "total": 194,
  "skip": 0,
  "limit": 0
}
```

---

### Obter Detalhes de um Produto
**Endpoint:** `GET https://dummyjson.com/products/{id}`

**Path Parameters:**
- `id` - ID do produto (ex: 1, 5, 10, etc.)

**Request Headers:**
```
Content-Type: application/json
```

**Response (200 OK):**
```json
{
  "id": 1,
  "title": "iPhone 9",
  "description": "An apple mobile which is nothing like apple",
  "price": 549,
  "discountPercentage": 12.96,
  "rating": 4.69,
  "stock": 94,
  "tags": ["smartphone", "ios"],
  "brand": "Apple",
  "category": "smartphones",
  "thumbnail": "https://cdn.dummyjson.com/products/images/smartphones/iphone-9/thumbnail.png",
  "images": [
    "https://cdn.dummyjson.com/products/images/smartphones/iphone-9/1.jpg",
    "https://cdn.dummyjson.com/products/images/smartphones/iphone-9/2.jpg"
  ],
  "weight": 0.168,
  "dimensions": {
    "width": 70.9,
    "height": 150.9,
    "depth": 8.68
  },
  "warrantyInformation": "1 year manufacturer warranty",
  "shippingInformation": "Ships in 1 month",
  "availabilityStatus": "In Stock",
  "reviews": [
    {
      "rating": 5,
      "comment": "Great product!",
      "date": "2024-05-23T08:56:21.618Z",
      "reviewerName": "John Doe",
      "reviewerEmail": "john@example.com"
    }
  ],
  "returnPolicy": "30 days return policy"
}
```

---

## 🔍 Buscar Produtos

### Buscar por Termo
**Endpoint:** `GET https://dummyjson.com/products/search?q={termo}`

**Query Parameters:**
- `q` - Termo de busca (ex: "iphone")

**Response:**
```json
{
  "products": [
    {
      "id": 1,
      "title": "iPhone 9",
      "price": 549,
      ...
    }
  ],
  "total": 5,
  "skip": 0,
  "limit": 30
}
```

---

## 📂 Categorias

### Listar Categorias
**Endpoint:** `GET https://dummyjson.com/products/categories`

**Response (200 OK):**
```json
[
  "smartphones",
  "laptops",
  "fragrances",
  "skincare",
  "groceries",
  "home-decoration",
  "furniture",
  "tops",
  "womens-dresses",
  "womens-shoes",
  "mens-shirts",
  "mens-shoes",
  "mens-watches",
  "womens-watches",
  "womens-bags",
  "womens-jewellery",
  "sunglasses",
  "automotive",
  "motorcycle",
  "vehicle"
]
```

---

### Produtos por Categoria
**Endpoint:** `GET https://dummyjson.com/products/category/{categoria}`

**Path Parameters:**
- `categoria` - Nome da categoria (ex: "smartphones")

**Response:**
```json
{
  "products": [...],
  "total": 5,
  "skip": 0,
  "limit": 30
}
```

---

## 👥 Usuários de Teste

### Credenciais Disponíveis

| Username | Password | Nome Completo |
|----------|----------|---------------|
| emilys | emilyspass | Emily Johnson |
| michaelw | michaelwpass | Michael Williams |
| sophiab | sophiabpass | Sophia Brown |
| jamesh | jameshpass | James Harris |
| evangr | evangrpass | Evan Green |

---

## 🛠️ Manipulação de Dados

### Adicionar Produto
**Endpoint:** `POST https://dummyjson.com/products/add`

**Request:**
```json
{
  "title": "Novo Produto",
  "price": 99.99,
  "description": "Descrição do produto"
}
```

**Response:**
```json
{
  "id": 195,
  "title": "Novo Produto",
  "price": 99.99,
  "description": "Descrição do produto",
  ...
}
```

---

### Atualizar Produto
**Endpoint:** `PUT https://dummyjson.com/products/{id}`

**Request:**
```json
{
  "title": "Produto Atualizado",
  "price": 149.99
}
```

---

### Deletar Produto
**Endpoint:** `DELETE https://dummyjson.com/products/{id}`

**Response:**
```json
{
  "id": 1,
  "title": "iPhone 9",
  "isDeleted": true
}
```

---

## 📊 Paginação

A maioria dos endpoints suporta paginação:

```
GET https://dummyjson.com/products?skip=10&limit=20
```

**Parâmetros:**
- `skip` - Número de itens para pular (default: 0)
- `limit` - Número de itens a retornar (default: 30, máx: 0 para todos)

---

## ⚠️ Códigos de Erro

| Código | Mensagem | Causa |
|--------|----------|-------|
| 200 | OK | Requisição bem-sucedida |
| 400 | Bad Request | Parâmetros inválidos |
| 401 | Unauthorized | Token ausente ou inválido |
| 403 | Forbidden | Sem permissão |
| 404 | Not Found | Recurso não encontrado |
| 500 | Internal Server Error | Erro no servidor |

---

## 🔑 Headers Comuns

### Request
```http
Content-Type: application/json
Authorization: Bearer {token}  // Apenas para endpoints protegidos
```

### Response
```http
Content-Type: application/json
X-Total-Count: 194             // Total de itens (em alguns endpoints)
```

---

## 📝 Exemplo de Requisição Completa

### Login com cURL
```bash
curl -X POST https://dummyjson.com/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "emilys",
    "password": "emilyspass"
  }'
```

### Obter Perfil com cURL
```bash
curl -X GET https://dummyjson.com/auth/me \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGc..."
```

### Listar Produtos com cURL
```bash
curl -X GET "https://dummyjson.com/products?limit=0" \
  -H "Content-Type: application/json"
```

---

## 🌐 Base URL

```
https://dummyjson.com
```

Todos os endpoints começam com esta URL base.

---

## 📚 Documentação Oficial

- [DummyJSON Docs](https://dummyjson.com/docs)
- [DummyJSON Auth](https://dummyjson.com/docs/auth)
- [DummyJSON Products](https://dummyjson.com/docs/products)
- [DummyJSON API em Português](https://dummyjson.com/docs/intro)

---

## 🧪 Teste com Postman

Import este JSON no Postman:

```json
{
  "info": {
    "name": "DummyJSON API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Login",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\"username\": \"emilys\", \"password\": \"emilyspass\"}"
        },
        "url": {
          "raw": "https://dummyjson.com/auth/login",
          "protocol": "https",
          "host": ["dummyjson", "com"],
          "path": ["auth", "login"]
        }
      }
    },
    {
      "name": "Get Profile",
      "request": {
        "method": "GET",
        "header": [
          {
            "key": "Authorization",
            "value": "Bearer {{token}}"
          }
        ],
        "url": {
          "raw": "https://dummyjson.com/auth/me",
          "protocol": "https",
          "host": ["dummyjson", "com"],
          "path": ["auth", "me"]
        }
      }
    },
    {
      "name": "Get Products",
      "request": {
        "method": "GET",
        "url": {
          "raw": "https://dummyjson.com/products?limit=0",
          "protocol": "https",
          "host": ["dummyjson", "com"],
          "path": ["products"],
          "query": [{"key": "limit", "value": "0"}]
        }
      }
    }
  ]
}
```

---

**Última atualização:** 2024
**API Versão:** v1
**Status:** Ativo e funcional
