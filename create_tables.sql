-- Создание таблицы ролей
CREATE TABLE Role (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE Permission (
    permission_id SERIAL PRIMARY KEY,
    permission_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE RolePermission (
    role_id INTEGER NOT NULL REFERENCES Role(role_id),
    permission_id INTEGER NOT NULL REFERENCES Permission(permission_id),
    PRIMARY KEY (role_id, permission_id)
);

-- Создание таблицы пользователей
CREATE TABLE "User" (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role_id INTEGER NOT NULL REFERENCES Role(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Создание таблицы журнала действий
CREATE TABLE UserLog (
    log_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES "User"(user_id),
    action_type VARCHAR(50) NOT NULL,
    action_details TEXT,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы категорий
CREATE TABLE Category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image_url TEXT
);

-- Создание таблицы поставщиков
CREATE TABLE Supplier (
    supplier_id SERIAL PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_supplier_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Создание таблицы растений
CREATE TABLE Plant (
    plant_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    scientific_name VARCHAR(255),
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0) DEFAULT 0,
    category_id INTEGER NOT NULL REFERENCES Category(category_id),
    supplier_id INTEGER NOT NULL REFERENCES Supplier(supplier_id),
    care_level VARCHAR(50) CHECK (care_level IN ('Легкий', 'Средний', 'Сложный')),
    light_requirements VARCHAR(100),
    watering_frequency VARCHAR(100),
    max_height DECIMAL(5,2) CHECK (max_height >= 0),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы адресов доставки
CREATE TABLE DeliveryAddress (
    address_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES "User"(user_id),
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'Россия',
    is_default BOOLEAN DEFAULT FALSE
);

-- Создание таблицы заказов
CREATE TABLE "Order" (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES "User"(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(50) NOT NULL CHECK (status IN ('Ожидает оплаты', 'Собирается', 'Доставляется', 'Выполнен', 'Отменен')),
    delivery_address_id INTEGER NOT NULL REFERENCES DeliveryAddress(address_id),
    shipping_cost DECIMAL(6,2) DEFAULT 0 CHECK (shipping_cost >= 0),
    notes TEXT
);

-- Создание таблицы элементов заказа
CREATE TABLE OrderItem (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES "Order"(order_id),
    plant_id INTEGER NOT NULL REFERENCES Plant(plant_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0)
);

-- Создание таблицы руководств по уходу
CREATE TABLE CareGuide (
    guide_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id INTEGER NOT NULL REFERENCES "User"(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы связи растений и руководств по уходу
CREATE TABLE PlantCare (
    plant_id INTEGER NOT NULL REFERENCES Plant(plant_id),
    guide_id INTEGER NOT NULL REFERENCES CareGuide(guide_id),
    priority INTEGER DEFAULT 1 CHECK (priority >= 1),
    PRIMARY KEY (plant_id, guide_id)
);

-- Создание таблицы корзин
CREATE TABLE Cart (
    cart_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE REFERENCES "User"(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы элементов корзины
CREATE TABLE CartItem (
    cart_item_id SERIAL PRIMARY KEY,
    cart_id INTEGER NOT NULL REFERENCES Cart(cart_id),
    plant_id INTEGER NOT NULL REFERENCES Plant(plant_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(cart_id, plant_id)
);

-- Создание индексов для оптимизации производительности
CREATE INDEX idx_user_email ON "User"(email);
CREATE INDEX idx_user_role ON "User"(role_id);
CREATE INDEX idx_userlog_user_date ON UserLog(user_id, created_at);
CREATE INDEX idx_plant_category ON Plant(category_id);
CREATE INDEX idx_plant_supplier ON Plant(supplier_id);
CREATE INDEX idx_plant_price ON Plant(price);
CREATE INDEX idx_plant_availability ON Plant(is_available);
CREATE INDEX idx_order_user ON "Order"(user_id);
CREATE INDEX idx_order_status ON "Order"(status);
CREATE INDEX idx_order_date ON "Order"(order_date);
CREATE INDEX idx_orderitem_order ON OrderItem(order_id);
CREATE INDEX idx_orderitem_plant ON OrderItem(plant_id);
CREATE INDEX idx_deliveryaddress_user ON DeliveryAddress(user_id);
CREATE INDEX idx_cart_user ON Cart(user_id);
CREATE INDEX idx_cartitem_cart ON CartItem(cart_id);
CREATE INDEX idx_careguide_author ON CareGuide(author_id);
CREATE INDEX idx_plantcare_plant ON PlantCare(plant_id);
CREATE INDEX idx_plantcare_guide ON PlantCare(guide_id);