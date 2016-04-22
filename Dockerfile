FROM microsoft/aspnet:1.0.0-rc1-update1

# If working behind a cntlm proxy, uncomment below
ENV HTTP_PROXY "http://localhost:3128"
ENV HTTPS_PROXY "http://localhost:3128"
ENV NO_PROXY "192.168.99.*"

COPY . /app
WORKDIR /app
RUN ["dnu", "restore"]


EXPOSE 7000/tcp
ENTRYPOINT ["dnx", "-p", "project.json", "web"]
