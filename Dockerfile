FROM axlabs/neo-privatenet:2.10.2

LABEL maintainer="AxLabs (https://axlabs.com)"
LABEL authors="gsmachado"

WORKDIR /neo-python

ADD ./scripts/neo-python_jsonrpc_run.sh /opt/
COPY ./scripts/protocol.privnet-1.json /neo-python/neo/data/protocol.privnet-1.json
COPY ./scripts/protocol.privnet-2.json /neo-python/neo/data/protocol.privnet-2.json

RUN rm -rf /root/.neopython/*
RUN chmod u+x /opt/neo-python_jsonrpc_run.sh
RUN sed -i '/sleep infinity/i \screen -S node1 -X stuff "import key KxDgvEKzgSBPPfuVfw67oPQBSjidEiqTHURKSDL1R7yGaGYAeYnr^M" \nscreen -S node1 -X stuff "rebuild index^M" \nsleep 15 \nscreen -dmS neo-python expect /opt/neo-python_jsonrpc_run.sh /neo-python/neo-privnet.wallet \nscreen -S neo-python -X stuff "coz^M"' /opt/run.sh
RUN sed -i '/^expect\s\"neo>\"$/d' /opt/start_consensus_node.sh

EXPOSE 30337
EXPOSE 30338