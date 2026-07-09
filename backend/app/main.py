from fastapi import FastAPI

app = FastAPI(title="Multi-Region Enterprise API")

@app.get("/")
def read_root():
    return {"message": "Hello from Multi-Region Enterprise Platform!", "status": "running"}

@app.get("/health")
def health_check():
    # Kasnije ćemo ovde dodati proveru konekcije sa bazom
    return {"status": "healthy", "region": "local"}
