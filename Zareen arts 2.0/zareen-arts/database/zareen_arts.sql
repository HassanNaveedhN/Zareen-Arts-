CREATE DATABASE IF NOT EXISTS zareen_arts
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE zareen_arts;


DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS products;


CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category ENUM('cakes','resin') NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    size_prices JSON NULL,
    image VARCHAR(255) NULL,
    active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    rating TINYINT NOT NULL,
    comment TEXT NOT NULL,
    approved TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,

    customer_name VARCHAR(120) NOT NULL,

    phone VARCHAR(40) NOT NULL,

    email VARCHAR(150),

    city VARCHAR(100) NOT NULL,

    address TEXT NOT NULL,

    delivery_date DATE NOT NULL,

    payment_method VARCHAR(50) NOT NULL,

    payment_reference VARCHAR(150),

    custom_notes TEXT,

    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,

    status VARCHAR(30) DEFAULT 'pending',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,

    order_id INT NOT NULL,

    product_id INT NOT NULL,

    product_name VARCHAR(150) NOT NULL,

    quantity INT NOT NULL,

    customization JSON,

    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY(order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    FOREIGN KEY(product_id)
        REFERENCES products(id)
);


INSERT INTO products
(
    id,
    name,
    category,
    description,
    price,
    size_prices,
    image
)
VALUES

(
    1,
    'Caramel Three Milk Cake',
    'cakes',
    'Soft vanilla sponge with creamy frosting.',
    2500,
    '{"1 Pound":2500,"2 Pound":5000,"3 Pound":7500,"4 Pound":10000}',
    'images/Caramel three milk.jpg'
),

(
    2,
    'Red Velvet Cake',
    'cakes',
    'Rich red velvet layers with cream cheese frosting.',
    3200,
    '{"1 Pound":3200,"2 Pound":6400,"3 Pound":9600,"4 Pound":12800}',
    'images/Red Velvet .png'
),

(
    3,
    'Chocolate Fudge Cake',
    'cakes',
    'Deep chocolate cake with smooth fudge frosting.',
    3000,
    '{"1 Pound":3000,"2 Pound":6000,"3 Pound":9000,"4 Pound":12000}',
    'images/Chocolate fudge cake.jfif'
),

(
    4,
    'Black Forest Cake',
    'cakes',
    'Classic black forest cake with rich chocolate and cherries.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/Forest.jfif'
),

(
    15,
    'Choco Lava Cake',
    'cakes',
    'Rich chocolate cake with a molten chocolate center.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/Chocolate Lava Cake.jfif'
),

(
    16,
    'Pineapple Loaded Cake',
    'cakes',
    'Soft cake loaded with pineapple and cream.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/pineapple.jfif'
),

(
    17,
    'Mango Cream Cake',
    'cakes',
    'Fresh mango cake with creamy layers.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/Mango Cake.jfif'
),

(
    18,
    'Hummingbird Cake',
    'cakes',
    'Moist and flavorful hummingbird cake.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/Hummingbird Cake.jfif'
),

(
    19,
    'New York Cheesecake',
    'cakes',
    'Creamy New York style cheesecake.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/cheesecake.jfif'
),

(
    20,
    'Tiramisu Cake',
    'cakes',
    'Soft tiramisu cake with coffee and cream.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/Tiramisu.jfif'
),

-- (
--     21,
--     'Tres Leches Cake',
--     'cakes',
--     'Soft milk-soaked cake with creamy topping.',
--     3500,
--     '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
--     'images/tres.jfif'
-- ),

(
    22,
    'Lotus Three Milk Cake',
    'cakes',
    'Three milk cake topped with Lotus spread.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/lotus cake.jfif'
),

(
    23,
    'Three Milk Cake',
    'cakes',
    'Soft three milk cake with creamy topping.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/three milk.jfif'
),

(
    24,
    'Classic Pound Cake',
    'cakes',
    'Classic soft and buttery pound cake.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/classic cake.jfif'
),

(
    25,
    'Angel Fruit Cake',
    'cakes',
    'Light fruit cake with creamy topping.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/fruit Cake.jfif'
),

(
    26,
    'Marble Cake',
    'cakes',
    'Classic marble cake with vanilla and chocolate.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/marbel cake.jfif'
),

(
    27,
    'Custom Birthday Cake',
    'cakes',
    'Your theme, colors, message and design.',
    3500,
    '{"1 Pound":3500,"2 Pound":7000,"3 Pound":10500,"4 Pound":14000}',
    'images/custom 2.jfif'
),

(
    5,
    'Resin Flower Tray',
    'resin',
    'Hand-poured resin tray with preserved flowers.',
    3000,
    NULL,
    'images/resin tray.jfif'
),

(
    6,
    'Resin Mirror Art',
    'resin',
    'Decorative mirror with custom resin details.',
    4500,
    NULL,
    'images/resin mirror.jfif'
),

(
    7,
    'Resin Key Chain',
    'resin',
    'Ocean-inspired handmade resin artwork.',
    700,
    NULL,
    'images/key chain resin.jfif'
),

(
    8,
    'Wedding Resin Keepsake',
    'resin',
    'Preserve flowers and memories in resin.',
    5000,
    NULL,
    'images/wedding resin.jpeg'
),

(
    9,
    'Resin Necklace',
    'resin',
    'Custom resin necklace.',
    800,
    NULL,
    'images/necklace.jfif'
),

(
    10,
    'Floral Resin Jhumka',
    'resin',
    'Floral custom jhumka for daily use in resin.',
    2000,
    NULL,
    'images/jhumka.jfif'
),

(
    11,
    'Resin Pendant Set',
    'resin',
    'Beautiful handmade resin pendant set.',
    1200,
    NULL,
    'images/Tops.jfif'
),

(
    12,
    'Resin Bracelet',
    'resin',
    'Beautiful handmade resin bracelet.',
    2000,
    NULL,
    'images/Tops.jfif'
),

(
    13,
    'Resin Pendant Set',
    'resin',
    'Preserve flowers and memories in resin.',
    2000,
    NULL,
    'images/Tops.jfif'
),

(
    14,
    'Resin Pendant Set',
    'resin',
    'Preserve flowers and memories in resin.',
    2000,
    NULL,
    'images/Tops.jfif'
);


INSERT INTO reviews
(
    name,
    rating,
    comment
)
VALUES

(
    'Ayesha',
    5,
    'The cake looked exactly like the reference picture and tasted amazing.'
),

(
    'Maham',
    5,
    'Loved the resin tray. The flowers and finishing were beautiful.'
),

(
    'Sara',
    4,
    'Very cooperative with customization. I will order again.'
);