FROM node:20-bookworm-slim

ENV PYTHON_BIN=python3 \
    DATA_DIR=/var/data \
    NODE_ENV=production

RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm ci --omit=dev
COPY backend/ ./
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir pandas numpy scikit-learn \
    && mkdir -p /var/data
ENV PATH="/opt/venv/bin:${PATH}"

EXPOSE 10000
CMD ["sh", "-c", "[ -f /var/data/data.json ] || cp /app/backend/data.json /var/data/data.json; [ -f /var/data/audit.json ] || cp /app/backend/audit.json /var/data/audit.json; npm start"]
