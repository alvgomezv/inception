FROM alpine:3.18

RUN apk update && apk upgrade && apk add --no-cache mariadb mariadb-client openrc

RUN openrc && touch /run/openrc/softlevel

COPY conf/mariadb.conf /etc/mysql/my.cnf
RUN chmod 644 /etc/mysql/my.cnf

RUN mkdir -p /run/mysqld && \
	chown -R mysql /run/mysqld && \
	/etc/init.d/mariadb setup && \
	chown -R mysql /var/lib/mysql && \
	sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf

RUN chmod 777 /var/lib/mysql

COPY tools/mariadb.sh .
RUN chmod +x mariadb.sh

EXPOSE 3306

ENTRYPOINT ["./mariadb.sh" ]