FROM ubuntu:latest

# install runtime dependencies
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y curl bc

COPY simulate_requests ./
RUN chmod +x ./simulate_requests

ENTRYPOINT ["./simulate_requests"]