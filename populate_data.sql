-- Заполнение таблицы ролей
INSERT INTO Role (role_name, description, permissions) VALUES
('Администратор', 'Полный доступ ко всем функциям системы', 'all'),
('Менеджер', 'Управление товарами, заказами и поставщиками', 'manage_products,manage_orders,manage_suppliers'),
('Клиент', 'Стандартный пользователь с правами на покупки', 'purchase,view_products');

-- Заполнение таблицы пользователей
INSERT INTO "User" (username, email, password_hash, first_name, last_name, phone, role_id, is_active) VALUES
('admin', 'admin@greenhouse.ru', 'hashed_password_1', 'Анна', 'Иванова', '+79161234567', 1, TRUE),
('manager1', 'manager@greenhouse.ru', 'hashed_password_2', 'Петр', 'Смирнов', '+79161234568', 2, TRUE),
('client1', 'client1@mail.ru', 'hashed_password_3', 'Мария', 'Петрова', '+79161234569', 3, TRUE),
('client2', 'client2@mail.ru', 'hashed_password_4', 'Алексей', 'Кузнецов', '+79161234570', 3, TRUE),
('client3', 'client3@mail.ru', 'hashed_password_5', 'Екатерина', 'Воробьева', '+79161234571', 3, TRUE);

-- Заполнение таблицы категорий
INSERT INTO Category (name, description, image_url) VALUES
('Комнатные растения', 'Растения для выращивания в помещении', '/images/room_plants.jpg'),
('Суккуленты', 'Засухоустойчивые растения с мясистыми листьями', '/images/succulents.jpg'),
('Орхидеи', 'Экзотические цветущие растения', '/images/orchids.jpg'),
('Пальмы', 'Крупные декоративные растения', '/images/palms.jpg'),
('Травы', 'Пряные и ароматические растения', '/images/herbs.jpg');

-- Заполнение таблицы поставщиков
INSERT INTO Supplier (company_name, contact_person, email, phone, address, is_active) VALUES
('Цветочная Ферма', 'Ирина Васильева', 'info@flowerfarm.ru', '+78001234567', 'Москва, ул. Садовая, 15', TRUE),
('ЭкоРастения', 'Дмитрий Соколов', 'sales@ecoplants.ru', '+78001234568', 'Санкт-Петербург, пр. Цветочный, 28', TRUE),
('Тропики Дома', 'Ольга Морозова', 'contact@tropicshome.ru', '+78001234569', 'Краснодар, ул. Тропическая, 5', TRUE),
('Зеленый Мир', 'Сергей Попов', 'order@greenworld.ru', '+78001234570', 'Екатеринбург, ул. Зеленая, 42', TRUE);

-- Заполнение таблицы растений
INSERT INTO Plant (name, scientific_name, description, price, stock_quantity, category_id, supplier_id, care_level, light_requirements, watering_frequency, max_height, is_available) VALUES
('Фикус Бенджамина', 'Ficus benjamina', 'Популярное комнатное дерево с мелкими листьями', 2500.00, 15, 1, 1, 'Средний', 'Яркий рассеянный свет', '1 раз в неделю', 200.00, TRUE),
('Алоэ Вера', 'Aloe vera', 'Лечебное суккулентное растение', 800.00, 30, 2, 2, 'Легкий', 'Прямое солнце', '1 раз в 2 недели', 60.00, TRUE),
('Фаленопсис', 'Phalaenopsis', 'Орхидея-бабочка с длительным цветением', 1800.00, 12, 3, 3, 'Средний', 'Рассеянный свет', '1 раз в 10 дней', 70.00, TRUE),
('Драцена Маргината', 'Dracaena marginata', 'Пальмовидное растение с красными краями листьев', 3200.00, 8, 4, 1, 'Легкий', 'Полутень', '1 раз в неделю', 250.00, TRUE),
('Базилик', 'Ocimum basilicum', 'Пряная трава для кулинарии', 300.00, 25, 5, 4, 'Легкий', 'Прямое солнце', 'Каждые 2-3 дня', 40.00, TRUE),
('Кактус Цереус', 'Cereus', 'Колонновидный кактус с ночным цветением', 1200.00, 20, 2, 2, 'Легкий', 'Прямое солнце', '1 раз в 3 недели', 100.00, TRUE),
('Монстера', 'Monstera deliciosa', 'Крупное растение с резными листьями', 4500.00, 5, 1, 3, 'Средний', 'Рассеянный свет', '1 раз в неделю', 300.00, TRUE);

-- Заполнение таблицы адресов доставки
INSERT INTO DeliveryAddress (user_id, address_line1, address_line2, city, state, postal_code, country, is_default) VALUES
(3, 'ул. Ленина, 25', 'кв. 14', 'Москва', 'Московская область', '101000', 'Россия', TRUE),
(3, 'пр. Мира, 89', 'кв. 56', 'Москва', 'Московская область', '101001', 'Россия', FALSE),
(4, 'ул. Пушкина, 12', 'кв. 23', 'Санкт-Петербург', 'Ленинградская область', '190000', 'Россия', TRUE),
(5, 'ул. Гагарина, 45', 'кв. 7', 'Казань', 'Татарстан', '420000', 'Россия', TRUE);

-- Заполнение таблицы корзин
INSERT INTO Cart (user_id) VALUES
(3), (4), (5);

-- Заполнение таблицы элементов корзины
INSERT INTO CartItem (cart_id, plant_id, quantity) VALUES
(1, 1, 1), (1, 2, 2), (2, 3, 1), (3, 5, 3);

-- Заполнение таблицы заказов
INSERT INTO "Order" (user_id, total_amount, status, delivery_address_id, shipping_cost, notes) VALUES
(3, 4100.00, 'Выполнен', 1, 300.00, 'Доставить до 18:00'),
(4, 1800.00, 'Доставляется', 3, 250.00, 'Осторожно, хрупкий товар'),
(5, 900.00, 'Собирается', 4, 200.00, 'Позвонить за час до доставки');

-- Заполнение таблицы элементов заказа
INSERT INTO OrderItem (order_id, plant_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 2500.00, 2500.00),
(1, 2, 2, 800.00, 1600.00),
(2, 3, 1, 1800.00, 1800.00),
(3, 5, 3, 300.00, 900.00);

-- Заполнение таблицы руководств по уходу
INSERT INTO CareGuide (title, content, author_id) VALUES
('Уход за фикусами', 'Фикусы предпочитают яркий рассеянный свет и умеренный полив...', 2),
('Полив суккулентов', 'Суккуленты требуют редкого, но обильного полива...', 2),
('Цветение орхидей', 'Для регулярного цветения орхидеям необходим перепад температур...', 2);

-- Заполнение таблицы связи растений и руководств
INSERT INTO PlantCare (plant_id, guide_id, priority) VALUES
(1, 1, 1), (2, 2, 1), (3, 3, 1), (2, 1, 2);

-- Заполнение таблицы журнала действий
INSERT INTO UserLog (user_id, action_type, action_details, ip_address, user_agent) VALUES
(3, 'LOGIN', 'Успешный вход в систему', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(3, 'ADD_TO_CART', 'Добавлен товар: Фикус Бенджамина', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(4, 'PLACE_ORDER', 'Оформлен заказ №2', '192.168.1.101', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'),
(2, 'UPDATE_PRODUCT', 'Обновлена цена растения: Монстера', '192.168.1.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');