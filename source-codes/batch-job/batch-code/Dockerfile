FROM bash

WORKDIR /job

COPY primegen.sh ./

RUN chmod +x ./primegen.sh

# ENTRYPOINT ["sleep", "3600"]

ENTRYPOINT ["bash", "./primegen.sh"]

CMD ["42"]