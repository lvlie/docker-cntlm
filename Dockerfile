FROM alpine

RUN apk add --no-cache curl gcc make musl-dev && \
    curl -o /cntlm-0.92.3.tar.gz http://kent.dl.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.gz && \
    tar -xvzf /cntlm-0.92.3.tar.gz && \
    cd /cntlm-0.92.3 && ./configure && make && make install && \
    rm -Rf cntlm-0.92.3.tar.gz cntlm-0.92.3 && \
    apk del --no-cache gcc make musl-dev

ENV USERNAME   example
ENV PASSWORD   UNSET
ENV DOMAIN     example.com
ENV PROXY      example.com:3128
ENV LISTEN     0.0.0.0:3128
ENV PASSLM     UNSET
ENV PASSNT     UNSET
ENV PASSNTLMV2 UNSET

EXPOSE 3128

ADD start.sh /start.sh

CMD chmod +x /start.sh && \
    /start.sh
    
HEALTHCHECK CMD https_proxy=http://localhost:3128 \
                http_proxy=http://localhost:3128 \
                curl --fail https://www.google.com/ || exit 1
