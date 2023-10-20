FROM python:3.9-slim AS builder

USER root

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PIPENV_PIPFILE=/home/admin/obs/Pipfile
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /home/admin/obs
COPY Pipfile Pipfile.lock ./
RUN pip install pipenv && \
    pipenv requirements > requirements.txt

FROM rockylinux/rockylinux:8.6

USER root

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV VIRTUAL_ENV=/home/admin/obs/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /home/admin/obs
RUN dnf update -y && dnf install -y \
    python39
COPY --from=builder /home/admin/obs/requirements.txt .
RUN python3 -m venv $VIRTUAL_ENV && \
    python -m pip install -U pip && \
    python -m pip install -r requirements.txt
COPY app ./app

ENTRYPOINT [ "gunicorn" ]
CMD ["-b", "0.0.0.0:9001", "app.main:app"]
