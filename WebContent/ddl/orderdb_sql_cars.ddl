CREATE DATABASE orders;
go;

USE orders;
go;

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;   
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Sedan');
INSERT INTO category(categoryName) VALUES ('SUV');
INSERT INTO category(categoryName) VALUES ('Truck');
INSERT INTO category(categoryName) VALUES ('Motorcycle');
INSERT INTO category(categoryName) VALUES ('Electric Vehicle');

INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('Model S', 'Luxury Electric Sedan', 1, 79999);
INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('Accord', 'Reliable Family Sedan', 1, 24999);
INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('Model X', 'Premium Electric SUV', 2, 99999);
INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('CR-V', 'Compact SUV', 2, 32999);
INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('F-150', 'Popular Full-Size Truck', 3, 28999);
INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('Cybertruck', 'Electric Truck', 3, 49999);
INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('Ninja ZX-6R', 'Performance Motorcycle', 4, 9999);
INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('Sportster S', 'Classic Cruiser Motorcycle', 4, 15499);
INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('Model 3', 'Affordable Electric Sedan', 5, 39999);
INSERT INTO product(productName, productDesc, categoryId, productPrice) VALUES ('Leaf', 'Compact Electric Car', 5, 29999);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 79999);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 24999);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 99999);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 32999);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 28999);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 49999);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 9999);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 15499);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 39999);
INSERT INTO productinventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 29999);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test');

-- Order 1
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 167996.00)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 79999) -- Model S
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 28999) -- F-150
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 29999); -- Leaf

-- Order 2
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 144995.00)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 28999); -- F-150

-- Order 3
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 129995.00)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 49999) -- Cybertruck
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 9999); -- Ninja ZX-6R

-- Order 4
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 490991.00)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 3, 99999) -- Model X
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 2, 15499) -- Sportster S
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 9, 4, 39999); -- Model 3

-- Order 5
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 270991.00)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 28999) -- F-150
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 9, 2, 39999) -- Model 3
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 2, 3, 24999); -- Accord


-- New SQL DDL for lab 8
UPDATE Product SET productImageURL = 'img/carimg/1.webp' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/carimg/2.webp' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/carimg/3.webp' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/carimg/4.webp' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/carimg/5.webp' WHERE ProductId = 5;
UPDATE Product SET productImageURL = 'img/carimg/6.webp' WHERE ProductId = 6;
UPDATE Product SET productImageURL = 'img/carimg/7.webp' WHERE ProductId = 7;
UPDATE Product SET productImageURL = 'img/carimg/8.webp' WHERE ProductId = 8;
UPDATE Product SET productImageURL = 'img/carimg/9.webp' WHERE ProductId = 9;
UPDATE Product SET productImageURL = 'img/carimg/10.webp' WHERE ProductId = 10;