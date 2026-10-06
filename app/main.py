from fastapi import FastAPI

app = FastAPI(title="Test REST API", version="1.0.0")


@app.get("/")
def root():
    return {
        "message": "Hello from Test REST API",
        "version": "1.0.0"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy",
        "service": "test-api"
    }


@app.get("/users")
def get_users():
    return {
        "users": [
            {
                "id": 1,
                "name": "Dara",
                "email": "dara@example.com"
            },
            {
                "id": 2,
                "name": "Sokha",
                "email": "sokha@example.com"
            },
            {
                "id": 3,
                "name": "Vicham",
                "email": "vicham@example.com"
            }
        ]
    }


@app.get("/products")
def get_products():
    return {
        "products": [
            {
                "id": 1,
                "name": "Laptop",
                "price": 1200
            },
            {
                "id": 2,
                "name": "Phone",
                "price": 800
            },
            {
                "id": 3,
                "name": "Monitor",
                "price": 300
            }
        ]
    }