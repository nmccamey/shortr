DROP DATABASE IF EXISTS shortr;
CREATE DATABASE shortr;
USE shortr;

CREATE TABLE urls (
    url_id INT NOT NULL AUTO_INCREMENT,
    token varchar(20) UNIQUE,
    destination_url TEXT,
    destination_url_hash char(24),
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (url_id),
    INDEX (token),
    INDEX (destination_url_hash)
) AUTO_INCREMENT=50000000;

GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
