FROM microsoft/aspnet:1.0.0-rc1-update1

# If working behind a cntlm proxy, uncomment below
ENV http_proxy "http://10.0.2.2:3128"
ENV https_proxy "http://10.0.2.2:3128"
ENV NO_PROXY "192.168.99.*"

# Copy the project dependencies
COPY ./project.json /api/
WORKDIR /api
RUN ["dnu","restore"]

# Copy the project source code
COPY . /api
WORKDIR /api


EXPOSE 1000
ENTRYPOINT ["dnx", "-p", "project.json", "web"]
