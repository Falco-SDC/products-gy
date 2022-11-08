


--------------
--PRODUCT TABLE
--------------

DROP TABLE IF EXISTS product cascade;

CREATE TABLE product
(
    id INTEGER,
    name VARCHAR NULL DEFAULT NULL,
    slogan VARCHAR NULL DEFAULT NULL,
    description VARCHAR NULL DEFAULT NULL,
    category VARCHAR NULL DEFAULT NULL,
    default_price INTEGER NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

COPY product (id, name, slogan, description, category, default_price)
FROM '/Users/gabeyamartino/Desktop/SDC_data/product.csv'
DELIMITER ',' CSV HEADER;

---------------
--FEATURES TABLE
---------------

DROP TABLE IF EXISTS features cascade;

CREATE TABLE IF NOT EXISTS features
(
    id INTEGER,
    product_id INTEGER NULL DEFAULT NULL,
    feature VARCHAR NULL DEFAULT NULL,
    value VARCHAR NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

-- FOREIGN KEY
ALTER TABLE features ADD FOREIGN KEY (product_id) REFERENCES product (id);

-- INDEX
CREATE INDEX feat_index ON features (product_id);

COPY features
FROM '/Users/gabeyamartino/Desktop/SDC_data/features.csv'
DELIMITER ','
CSV HEADER;


----------------
-- RELATED TABLE
----------------

DROP TABLE IF EXISTS related cascade;


CREATE TABLE IF NOT EXISTS related
(
    id INTEGER NOT NULL,
    current_product_id INTEGER,
    related_product_id INTEGER,
    PRIMARY KEY (id)
);

-- FOREIGN KEY
ALTER TABLE related ADD FOREIGN KEY (current_product_id) REFERENCES product (id);

-- INDEX
CREATE INDEX rel_index ON related (current_product_id);


COPY related
FROM '/Users/gabeyamartino/Desktop/SDC_data/related.csv'
DELIMITER ','
CSV HEADER;



---------------
-- STYLES TABLE
---------------

DROP TABLE IF EXISTS styles cascade;


CREATE TABLE IF NOT EXISTS styles
(
    style_id INTEGER NOT NULL,
    product_id INTEGER,
    name VARCHAR NULL DEFAULT NULL,
    sale_price SMALLINT DEFAULT NULL,
    original_price INTEGER,
    "default?" boolean,
    PRIMARY KEY (style_id)
);

--FOREIGN KEY
ALTER TABLE styles ADD FOREIGN KEY (product_id) REFERENCES product (id);

-- INDEX
CREATE INDEX style_index ON styles (product_id);

COPY styles
FROM '/Users/gabeyamartino/Desktop/SDC_data/styles.csv'
(format csv, null "null",
DELIMITER ',',
HEADER);



-------------
-- SKUS TABLE
-------------

DROP TABLE IF EXISTS skus cascade;


CREATE TABLE IF NOT EXISTS skus
(
    id INTEGER NOT NULL,
    style_id INTEGER,
    size VARCHAR NULL DEFAULT NULL,
    quantity INTEGER,
    PRIMARY KEY (id)
);

--FOREIGN KEY
ALTER TABLE skus ADD FOREIGN KEY (style_id) REFERENCES styles (style_id);

--INDEX
CREATE INDEX skus_index ON skus (style_id);

COPY skus
FROM '/Users/gabeyamartino/Desktop/SDC_data/skus.csv'
DELIMITER ','
CSV HEADER;



-- ---------------
-- -- PHOTOS TABLE
-- ---------------

DROP TABLE IF EXISTS photos cascade;


CREATE TABLE IF NOT EXISTS photos
(
    id INTEGER NOT NULL,
    style_id INTEGER,
    url VARCHAR NULL DEFAULT NULL,
    thumbnail_url VARCHAR NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

--FOREIGN KEY
ALTER TABLE photos ADD FOREIGN KEY (style_id) REFERENCES styles (style_id);

--INDEX
CREATE INDEX photos_index ON photos (style_id);

COPY photos
FROM '/Users/gabeyamartino/Desktop/SDC_data/photos.csv'

DELIMITER ','
QUOTE E'\b'
CSV HEADER;