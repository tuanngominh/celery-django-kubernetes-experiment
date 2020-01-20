FROM python:3.8

WORKDIR /code/server

RUN pip install -U pip && \
    pip install poetry
RUN poetry config virtualenvs.create false

COPY poetry.lock pyproject.toml ./

ARG PRODUCTION
RUN poetry install ${PRODUCTION:+--no-dev}

COPY . .

CMD ["./mysite/manage.py", "runserver", "0.0.0.0:8000"]
