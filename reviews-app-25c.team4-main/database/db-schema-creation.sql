-- Create the products table
CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(80) NOT NULL
);

-- Create the reviews table
CREATE TABLE review (
    id INT PRIMARY KEY AUTO_INCREMENT,
    content VARCHAR(200) NOT NULL,
    product_id INT NOT NULL,
    polarity FLOAT,
    subjectivity FLOAT,
    FOREIGN KEY (product_id) REFERENCES product(id)
);
