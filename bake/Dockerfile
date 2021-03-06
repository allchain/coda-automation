ARG BAKE_VERSION

FROM codaprotocol/coda-daemon:${BAKE_VERSION}

ARG COMMIT_HASH=master
ARG TESTNET_NAME=turbo-pickles
ARG CONFIG_FILE="/root/daemon.json"

RUN curl https://raw.githubusercontent.com/MinaProtocol/coda-automation/${COMMIT_HASH}/terraform/testnets/${TESTNET_NAME}/genesis_ledger.json -o "${CONFIG_FILE}"

RUN head ${CONFIG_FILE}

RUN coda daemon -config-file ${CONFIG_FILE} -generate-genesis-proof true; \
  mv ~/.coda-config/genesis/genesis_* /var/lib/coda/

RUN curl https://raw.githubusercontent.com/MinaProtocol/coda-automation/${COMMIT_HASH}/terraform/testnets/${TESTNET_NAME}/peers.txt -o /root/peers.txt

RUN echo '#!/bin/bash -x\n\
mkdir -p .coda-config\n\
touch .coda-config/coda-prover.log\n\
touch .coda-config/coda-verifier.log\n\
touch .coda-config/mina-best-tip.log\n\
command=$1 \n\
shift \n\
while true; do\n\
  rm -f /root/.coda-config/.mina-lock\n\
  coda "$command" -config-file "'${CONFIG_FILE}'" "$@" 2>&1 >coda.log &\n\
  coda_pid=$!\n\
  tail -q -f coda.log &\n\
  tail_pid=$!\n\
  wait "$coda_pid"\n\
  echo "Coda process exited with status code $?"\n\
  sleep 10\n\
  kill "$tail_pid"\n\
  if [ ! -f stay_alive ]; then\n\
    exit 0\n\
  fi\n\
done'\
> init_coda_baked.sh

RUN chmod +x init_coda_baked.sh

ENV CODA_TIME_OFFSET 0

ENTRYPOINT ["/usr/bin/dumb-init", "/root/init_coda_baked.sh"]
