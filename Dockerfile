FROM python:3.8-slim

# Set pip to have cleaner logs and no saved cache
ENV PIP_NO_CACHE_DIR=false \
    PIPENV_HIDE_EMOJIS=1 \
    PIPENV_IGNORE_VIRTUALENVS=1 \
    PIPENV_NOSPIN=1

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y xsltproc curl && \
    curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb \
        && echo 'd9f259a67e05e1c221d48b504453645e6c491fab wkhtmltox.deb' | sha1sum -c - \
        && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb && \
        apt-get autoremove

# Install pipenv
RUN pip install -U pipenv

# Create the working directory
WORKDIR /bot

# Install project dependencies
COPY Pipfile* ./
RUN pipenv install --system --deploy

# Copy the source code in last to optimize rebuilding the image
COPY . .

ENTRYPOINT ["python3"]
CMD ["-m", "bot"]