-- Active: 1725741785348@@127.0.0.1@3306@walmart
CREATE TABLE walmart (
    invoice_id INTEGER PRIMARY KEY,
    Branch VARCHAR(8),
    City VARCHAR(21),
    category VARCHAR(23),
    unit_price FLOAT,
    quantity INTEGER,
    date VARCHAR(11),
    time VARCHAR(16),
    payment_method VARCHAR(12),
    rating FLOAT,
    profit_margin FLOAT,
    total_price FLOAT
);
