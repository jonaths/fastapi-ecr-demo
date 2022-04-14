FROM python:3.8.0-slim

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# Install dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get autoremove -y \
    && apt-get install -y \
        gcc \
        build-essential \
        zlib1g-dev \
        wget \
        unzip \
        cmake \
        python3-dev \
        gfortran \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
    && apt-get clean

# Install dependencies:
COPY requirements.txt .

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Run the application:
COPY app/ app/
COPY .env .

WORKDIR app/

CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8080"]