FROM alpine:3.19

RUN apk update && \
    apk add --no-cache python3 py3-pip && \
    python3 -m venv /venv

WORKDIR /app

COPY ./app .

RUN /venv/bin/pip install --no-cache-dir -r requirements.txt

EXPOSE 80

CMD ["/venv/bin/python3", "app.py"]
#CMD ["sh", "-c", "while true; do echo 'Running infinite loop'; sleep 1; done"]
