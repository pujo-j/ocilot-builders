FROM python:3.8.2-slim

RUN python -m venv /venv

ENV VIRTUAL_ENV="/venv/"
ENV PATH=/venv/bin:$PATH
ENV PYTHONPATH=/app_module

RUN pip install --upgrade pip



