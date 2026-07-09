# 1. Koristimo zvaničnu laganu Python sliku
FROM python:3.10-slim

# 2. Postavljamo radni direktorijum unutar kontejnera
WORKDIR /app

# 3. Kopiramo requirements.txt prvo (da iskoristimo Docker cache za slojeve)
COPY requirements.txt .

# 4. Instaliramo zavisnosti bez keširanja kako bi slika bila što manja
RUN pip install --no-cache-dir -r requirements.txt

# 5. Kopiramo ostatak koda (app/ folder) u kontejner
COPY app/ ./app/

# 6. Otvaramo port 8000 na kontejneru
EXPOSE 8000

# 7. Komanda koja pokreće Uvicorn server unutar kontejnera
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
