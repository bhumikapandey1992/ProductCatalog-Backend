# 1) Base Python image
FROM python:3.10-slim

# 2) Install OS-level build deps & MySQL client headers
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    netcat-openbsd \
&& rm -rf /var/lib/apt/lists/*

# 3) Set working dir
WORKDIR /app

# 4) Install Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5) Copy project code
COPY . .

# 6) Make wait-for-db script executable
RUN chmod +x wait-for-db.sh

# 7) Expose Django’s port
EXPOSE 8000

# 8) Wait for DB then start Gunicorn
ENTRYPOINT ["./wait-for-db.sh", "db", "3306", "--"]
CMD ["gunicorn", "catalog.wsgi:application", "--bind", "0.0.0.0:8000"]