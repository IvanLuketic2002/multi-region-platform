#!/bin/bash

# Boje za lepši ispis u terminalu
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Multi-Region Platform CLI ===${NC}"

case "$1" in
  test)
    echo -e "${BLUE}Pokrećem lokalne testove...${NC}"
    cd backend
    PYTHONPATH=. pytest
    ;;
  run)
    echo -e "${BLUE}Pokrećem aplikaciju lokalno...${NC}"
    cd backend
    source venv/bin/activate 2>/dev/null || true
    uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
    ;;
  docker-build)
    echo -e "${BLUE}Gradim lokalnu Docker sliku...${NC}"
    cd backend
    docker build -t myapp:latest .
    ;;
  docker-run)
    echo -e "${BLUE}Pokrećem Docker kontejner...${NC}"
    docker run -d -p 8000:8000 --name myapp-container myapp:latest
    echo -e "${GREEN}Kontejner je pokrenut na http://localhost:8000${NC}"
    ;;
  docker-stop)
    echo -e "${RED}Zaustavljam i brišem Docker kontejner...${NC}"
    docker stop myapp-container 2>/dev/null
    docker rm myapp-container 2>/dev/null
    echo -e "${GREEN}Ugašeno.${NC}"
    ;;
  push)
    if [ -z "$2" ]; then
      echo -e "${RED}Greška: Moraš uneti commit poruku!${NC}"
      echo "Primer: ./platform.sh push \"moja poruka\""
      exit 1
    fi
    echo -e "${BLUE}Automatski commit i push na GitHub...${NC}"
    git add .
    git commit -m "$2"
    git push origin main
    echo -e "${GREEN}Kod je poslat na GitHub! Prati Actions tab.${NC}"
    ;;
  *)
    echo "Dostupne komande:"
    echo "  ./platform.sh test                - Pokreće pytest lokalno"
    echo "  ./platform.sh run                 - Pokreće FastAPI lokalno sa reload-om"
    echo "  ./platform.sh docker-build        - Gradi Docker sliku"
    echo "  ./platform.sh docker-run          - Pokreće aplikaciju u Dockeru"
    echo "  ./platform.sh docker-stop         - Gasi i briše lokalni kontejner"
    echo "  ./platform.sh push \"poruka\"       - Brzi commit i push na GitHub"
    ;;
esac
