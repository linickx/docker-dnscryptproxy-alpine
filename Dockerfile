FROM alpine:3

LABEL maintainer="Nick [linickx.com]"
LABEL version="0.1"

# Install
RUN apk update \
    && apk add dnscrypt-proxy tzdata

# Enable the Server Listeners
RUN sed -i "s|listen_addresses = \['127.0.0.1:53'\]|#listen_addresses = ['127.0.0.1:53']|" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
RUN sed -i "\|listen_addresses = \['127.0.0.1:53'\]|a listen_addresses = ['0.0.0.0:53']" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# Send query logs to the console
RUN sed -i "\|file = '/var/log/dnscrypt-proxy/query.log'|a file = '/dev/stdout'" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
RUN sed -i "s|log_files_max_size = 10|#log_files_max_size = 10|" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
RUN sed -i "\|log_files_max_size = 10|a log_files_max_size = 0" /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# Setup DNS Ports
EXPOSE 53/tcp
EXPOSE 53/udp

ENTRYPOINT ["/usr/bin/dnscrypt-proxy"]
CMD ["-config", "/etc/dnscrypt-proxy/dnscrypt-proxy.toml"]
