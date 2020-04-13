FROM axlabs/neo-privatenet:2.10.2

LABEL maintainer="AxLabs (https://axlabs.com)"
LABEL authors="gsmachado"

WORKDIR /neo-python

COPY ./scripts/protocol.privnet-1.json /neo-python/neo/data/protocol.privnet-1.json
COPY ./scripts/protocol.privnet-2.json /neo-python/neo/data/protocol.privnet-2.json
COPY ./scripts/protocol.privnet-3.json /neo-python/neo/data/protocol.privnet-3.json

RUN rm -rf /root/.neopython/*
RUN sed -i '/sleep infinity/i \screen -S node1 -X stuff "import key KxDgvEKzgSBPPfuVfw67oPQBSjidEiqTHURKSDL1R7yGaGYAeYnr^M" \nscreen -S node1 -X stuff "rebuild index^M" \nsleep 15' /opt/run.sh
RUN sed -i '/^expect\s\"neo>\"$/d' /opt/start_consensus_node.sh