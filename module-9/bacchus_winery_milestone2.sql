DROP DATABASE IF EXISTS bacchus_winery;
CREATE DATABASE bacchus_winery;
USE bacchus_winery;

CREATE TABLE department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    job_title VARCHAR(75) NOT NULL,
    department_id INT NOT NULL,
    manager_id INT NULL,
    hire_date DATE NOT NULL,
    CONSTRAINT fk_employee_department FOREIGN KEY (department_id) REFERENCES department(department_id),
    CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
);

CREATE TABLE employee_quarter_hours (
    employee_hours_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    work_year YEAR NOT NULL,
    quarter_number TINYINT NOT NULL CHECK (quarter_number BETWEEN 1 AND 4),
    hours_worked DECIMAL(6,2) NOT NULL CHECK (hours_worked >= 0),
    CONSTRAINT uq_employee_quarter UNIQUE (employee_id, work_year, quarter_number),
    CONSTRAINT fk_hours_employee FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE supplier (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL UNIQUE,
    contact_email VARCHAR(100),
    phone VARCHAR(25),
    supply_category VARCHAR(75) NOT NULL
);

CREATE TABLE supply_item (
    supply_item_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    item_name VARCHAR(75) NOT NULL,
    unit_of_measure VARCHAR(25) NOT NULL,
    reorder_level INT NOT NULL CHECK (reorder_level >= 0),
    quantity_on_hand INT NOT NULL CHECK (quantity_on_hand >= 0),
    CONSTRAINT uq_supplier_item UNIQUE (supplier_id, item_name),
    CONSTRAINT fk_supply_item_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

CREATE TABLE supply_delivery (
    supply_delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    expected_delivery_date DATE NOT NULL,
    actual_delivery_date DATE,
    shipment_status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_delivery_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

CREATE TABLE supply_delivery_item (
    delivery_item_id INT AUTO_INCREMENT PRIMARY KEY,
    supply_delivery_id INT NOT NULL,
    supply_item_id INT NOT NULL,
    quantity_delivered INT NOT NULL CHECK (quantity_delivered > 0),
    CONSTRAINT uq_delivery_supply_item UNIQUE (supply_delivery_id, supply_item_id),
    CONSTRAINT fk_delivery_item_delivery FOREIGN KEY (supply_delivery_id) REFERENCES supply_delivery(supply_delivery_id),
    CONSTRAINT fk_delivery_item_supply FOREIGN KEY (supply_item_id) REFERENCES supply_item(supply_item_id)
);

CREATE TABLE wine (
    wine_id INT AUTO_INCREMENT PRIMARY KEY,
    wine_name VARCHAR(50) NOT NULL UNIQUE,
    wine_type VARCHAR(50) NOT NULL,
    vintage_year YEAR NOT NULL,
    quantity_on_hand INT NOT NULL CHECK (quantity_on_hand >= 0),
    unit_price DECIMAL(8,2) NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE distributor (
    distributor_id INT AUTO_INCREMENT PRIMARY KEY,
    distributor_name VARCHAR(100) NOT NULL UNIQUE,
    contact_name VARCHAR(100),
    contact_email VARCHAR(100),
    phone VARCHAR(25),
    city VARCHAR(50),
    state CHAR(2)
);

CREATE TABLE distributor_wine (
    distributor_id INT NOT NULL,
    wine_id INT NOT NULL,
    date_added DATE NOT NULL,
    PRIMARY KEY (distributor_id, wine_id),
    CONSTRAINT fk_distributor_wine_distributor FOREIGN KEY (distributor_id) REFERENCES distributor(distributor_id),
    CONSTRAINT fk_distributor_wine_wine FOREIGN KEY (wine_id) REFERENCES wine(wine_id)
);

CREATE TABLE wine_order (
    wine_order_id INT AUTO_INCREMENT PRIMARY KEY,
    distributor_id INT NOT NULL,
    order_date DATE NOT NULL,
    ship_date DATE,
    shipment_status VARCHAR(30) NOT NULL,
    tracking_number VARCHAR(50),
    CONSTRAINT fk_order_distributor FOREIGN KEY (distributor_id) REFERENCES distributor(distributor_id)
);

CREATE TABLE wine_order_item (
    wine_order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    wine_order_id INT NOT NULL,
    wine_id INT NOT NULL,
    quantity_ordered INT NOT NULL CHECK (quantity_ordered > 0),
    sale_price DECIMAL(8,2) NOT NULL CHECK (sale_price >= 0),
    CONSTRAINT uq_order_wine UNIQUE (wine_order_id, wine_id),
    CONSTRAINT fk_order_item_order FOREIGN KEY (wine_order_id) REFERENCES wine_order(wine_order_id),
    CONSTRAINT fk_order_item_wine FOREIGN KEY (wine_id) REFERENCES wine(wine_id)
);

INSERT INTO department (department_name) VALUES
('Finance and Payroll'),
('Marketing'),
('Production'),
('Distribution'),
('Ownership'),
('Inventory Management');

INSERT INTO employee (first_name, last_name, job_title, department_id, manager_id, hire_date) VALUES
('Stan', 'Bacchus', 'Owner', 5, NULL, '2021-01-15'),
('Davis', 'Bacchus', 'Owner', 5, NULL, '2021-01-15'),
('Janet', 'Collins', 'Finance and Payroll Manager', 1, 1, '2018-03-01'),
('Roz', 'Murphy', 'Marketing Manager', 2, 2, '2017-06-20'),
('Bob', 'Ulrich', 'Marketing Assistant', 2, 4, '2020-09-14'),
('Henry', 'Doyle', 'Production Manager', 3, 1, '2016-02-10'),
('Maria', 'Costanza', 'Distribution Manager', 4, 2, '2019-11-05'),
('Lena', 'Brooks', 'Production Worker', 3, 6, '2022-04-18');

INSERT INTO employee_quarter_hours (employee_id, work_year, quarter_number, hours_worked) VALUES
(1, 2025, 1, 520.00), (1, 2025, 2, 515.00), (1, 2025, 3, 530.00), (1, 2025, 4, 525.00),
(2, 2025, 1, 518.00), (2, 2025, 2, 520.00), (2, 2025, 3, 522.00), (2, 2025, 4, 519.00),
(3, 2025, 1, 500.00), (3, 2025, 2, 498.00), (3, 2025, 3, 505.00), (3, 2025, 4, 510.00),
(4, 2025, 1, 495.00), (4, 2025, 2, 500.00), (4, 2025, 3, 502.00), (4, 2025, 4, 506.00),
(5, 2025, 1, 470.00), (5, 2025, 2, 480.00), (5, 2025, 3, 475.00), (5, 2025, 4, 482.00),
(6, 2025, 1, 540.00), (6, 2025, 2, 548.00), (6, 2025, 3, 552.00), (6, 2025, 4, 560.00),
(7, 2025, 1, 510.00), (7, 2025, 2, 515.00), (7, 2025, 3, 518.00), (7, 2025, 4, 520.00),
(8, 2025, 1, 480.00), (8, 2025, 2, 490.00), (8, 2025, 3, 500.00), (8, 2025, 4, 505.00);

INSERT INTO supplier (supplier_name, contact_email, phone, supply_category) VALUES
('Vineyard Packaging Co.', 'orders@vineyardpackaging.com', '555-100-1000', 'Bottles and Corks'),
('Premium Label and Box', 'sales@premiumlabelbox.com', '555-200-2000', 'Labels and Boxes'),
('Cellar Equipment Supply', 'service@cellarequipment.com', '555-300-3000', 'Vats and Tubing');

INSERT INTO supply_item (supplier_id, item_name, unit_of_measure, reorder_level, quantity_on_hand) VALUES
(1, '750ml Wine Bottles', 'case', 50, 120),
(1, 'Natural Corks', 'bag', 40, 90),
(2, 'Merlot Labels', 'roll', 25, 60),
(2, 'Shipping Boxes', 'bundle', 30, 75),
(3, 'Fermentation Vats', 'each', 2, 6),
(3, 'Food Grade Tubing', 'roll', 10, 22);

INSERT INTO supply_delivery (supplier_id, expected_delivery_date, actual_delivery_date, shipment_status) VALUES
(1, '2025-01-10', '2025-01-10', 'Delivered'),
(2, '2025-01-15', '2025-01-19', 'Delivered'),
(3, '2025-02-01', '2025-02-08', 'Delivered'),
(1, '2025-02-10', '2025-02-11', 'Delivered'),
(2, '2025-03-15', '2025-03-15', 'Delivered'),
(3, '2025-03-25', '2025-04-01', 'Delivered');

INSERT INTO supply_delivery_item (supply_delivery_id, supply_item_id, quantity_delivered) VALUES
(1, 1, 40),
(2, 3, 30),
(3, 5, 2),
(4, 2, 50),
(5, 4, 25),
(6, 6, 12);

INSERT INTO wine (wine_name, wine_type, vintage_year, quantity_on_hand, unit_price) VALUES
('Bacchus Merlot', 'Merlot', 2023, 850, 18.99),
('Bacchus Cabernet', 'Cabernet', 2023, 730, 21.99),
('Bacchus Chablis', 'Chablis', 2024, 640, 16.99),
('Bacchus Chardonnay', 'Chardonnay', 2024, 900, 17.99),
('Reserve Merlot', 'Merlot', 2022, 300, 28.99),
('Reserve Cabernet', 'Cabernet', 2022, 250, 31.99);

INSERT INTO distributor (distributor_name, contact_name, contact_email, phone, city, state) VALUES
('Tulsa Fine Wines', 'Angela Reed', 'areed@tulsafinewines.com', '555-411-1000', 'Tulsa', 'OK'),
('Oklahoma Beverage Group', 'Marcus Hall', 'mhall@okbeverage.com', '555-411-2000', 'Oklahoma City', 'OK'),
('Prairie State Distributors', 'Diane Lowe', 'dlowe@prairiestate.com', '555-411-3000', 'Wichita', 'KS'),
('Red River Wine Supply', 'Calvin Moore', 'cmoore@redriverwine.com', '555-411-4000', 'Dallas', 'TX'),
('Ozark Cellar Partners', 'Sofia Grant', 'sgrant@ozarkcellar.com', '555-411-5000', 'Springfield', 'MO'),
('Heartland Restaurant Supply', 'Evan King', 'eking@heartlandrestaurant.com', '555-411-6000', 'Little Rock', 'AR');

INSERT INTO distributor_wine (distributor_id, wine_id, date_added) VALUES
(1, 1, '2024-01-10'), (1, 2, '2024-01-10'),
(2, 1, '2024-02-15'), (2, 4, '2024-02-15'),
(3, 2, '2024-03-01'), (3, 3, '2024-03-01'),
(4, 1, '2024-03-20'), (4, 5, '2024-03-20'),
(5, 3, '2024-04-05'), (5, 4, '2024-04-05'),
(6, 2, '2024-05-12'), (6, 6, '2024-05-12');

INSERT INTO wine_order (distributor_id, order_date, ship_date, shipment_status, tracking_number) VALUES
(1, '2025-01-05', '2025-01-07', 'Shipped', 'BW1001'),
(2, '2025-01-12', '2025-01-15', 'Shipped', 'BW1002'),
(3, '2025-02-03', '2025-02-05', 'Shipped', 'BW1003'),
(4, '2025-02-20', '2025-02-23', 'Shipped', 'BW1004'),
(5, '2025-03-08', '2025-03-10', 'Shipped', 'BW1005'),
(6, '2025-03-22', NULL, 'Processing', NULL);

INSERT INTO wine_order_item (wine_order_id, wine_id, quantity_ordered, sale_price) VALUES
(1, 1, 60, 18.99),
(1, 2, 40, 21.99),
(2, 4, 75, 17.99),
(3, 3, 50, 16.99),
(4, 5, 25, 28.99),
(5, 4, 80, 17.99),
(6, 6, 30, 31.99);
