FROM cityofzion/neo-privatenet:2.8.0

LABEL maintainer="AxLabs (https://axlabs.com)"
LABEL authors="gsmachado"

WORKDIR /neo-python

ADD ./scripts/open-wallet.sh /opt/

RUN rm -rf /root/.neopython/Chains/privnet*
RUN chmod u+x /opt/open-wallet.sh
RUN sed -i '/sleep infinity/i \screen -dmS open-wallet expect /opt/open-wallet.sh /neo-python/neo-privnet.wallet coz \nscreen -S open-wallet -X stuff "coz^M"' /opt/run.sh

EXPOSE 30337
