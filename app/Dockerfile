FROM perl:5.32
RUN cpanm Mojolicious && \
    cpanm Mojolicious::Plugin::Model::DB && \
    cpanm Mojo::mysql && \
    cpanm DBI
RUN cpanm Data::Validate::URI
WORKDIR /opt
COPY . .
CMD ["morbo", "/opt/script/shortr", "daemon"]
