FROM python:3.11-slim

WORKDIR /app

COPY . .
COPY requirements.txt .

RUN pip install --upgrade --force-reinstall --no-cache-dir -r requirements.txt

CMD ["tail", "-f", "/dev/null"]
